-- Run this in Supabase SQL Editor
-- This creates the items table, storage bucket, and secure RLS policies.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
    user_id  uuid primary key references auth.users(id) on delete cascade,
    username text unique,
    created_at timestamptz not null default now()
);

-- Safe migration: add username column if this table already existed
alter table public.admin_users add column if not exists username text unique;

alter table public.admin_users enable row level security;

drop policy if exists "Admins can view own admin record" on public.admin_users;
create policy "Admins can view own admin record"
on public.admin_users
for select
to authenticated
using (user_id = auth.uid());

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1
        from public.admin_users
        where user_id = auth.uid()
    );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

-- Secure username-to-email lookup for admin login.
-- Returns an email only when both username and password are valid.
-- This prevents username-only enumeration.
create or replace function public.get_admin_email(p_username text, p_password text)
returns text
language sql
stable
security definer
set search_path = public
as $$
    select u.email
    from public.admin_users a
    join auth.users u on u.id = a.user_id
    where lower(a.username) = lower(trim(p_username))
      and p_password is not null
      and length(trim(p_password)) > 0
        and u.encrypted_password::text = extensions.crypt(p_password, u.encrypted_password::text)
      and u.email_confirmed_at is not null
    limit 1;
$$;

revoke all on function public.get_admin_email(text, text) from public;
grant execute on function public.get_admin_email(text, text) to anon;

create table if not exists public.items (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    price numeric(10,2) not null check (price >= 0),
    category text not null default 'General',
    description text not null default '',
    image_url text not null,
    image_path text not null,
    thumb_url text,
    thumb_path text,
    in_stock boolean not null default true,
    created_at timestamptz not null default now()
);

alter table public.items add column if not exists thumb_url text;
alter table public.items add column if not exists thumb_path text;

create table if not exists public.item_audit_log (
    id bigint generated always as identity primary key,
    action text not null check (action in ('insert', 'update', 'delete')),
    item_id uuid not null,
    actor_user_id uuid,
    item_name text,
    item_price numeric(10,2),
    occurred_at timestamptz not null default now()
);

do $$
begin
    if exists (
        select 1
        from pg_constraint
        where conname = 'item_audit_log_action_check'
          and conrelid = 'public.item_audit_log'::regclass
    ) then
        alter table public.item_audit_log drop constraint item_audit_log_action_check;
    end if;
end $$;

alter table public.item_audit_log
    add constraint item_audit_log_action_check
    check (action in ('insert', 'update', 'delete'));

create index if not exists items_price_idx on public.items (price desc);
create index if not exists items_created_at_idx on public.items (created_at desc);

alter table public.items enable row level security;
alter table public.item_audit_log enable row level security;

drop policy if exists "Admins can read audit logs" on public.item_audit_log;
create policy "Admins can read audit logs"
on public.item_audit_log
for select
to authenticated
using (public.is_admin());

create or replace function public.log_item_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    if tg_op = 'INSERT' then
        insert into public.item_audit_log (action, item_id, actor_user_id, item_name, item_price)
        values ('insert', new.id, auth.uid(), new.name, new.price);
        return new;
    elsif tg_op = 'UPDATE' then
        insert into public.item_audit_log (action, item_id, actor_user_id, item_name, item_price)
        values ('update', new.id, auth.uid(), new.name, new.price);
        return new;
    elsif tg_op = 'DELETE' then
        insert into public.item_audit_log (action, item_id, actor_user_id, item_name, item_price)
        values ('delete', old.id, auth.uid(), old.name, old.price);
        return old;
    end if;

    return null;
end;
$$;

drop trigger if exists trg_item_audit on public.items;
create trigger trg_item_audit
after insert or update or delete on public.items
for each row
execute function public.log_item_audit();

drop policy if exists "Public can read items" on public.items;
create policy "Public can read items"
on public.items
for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated can insert items" on public.items;
drop policy if exists "Anon can insert items" on public.items;
drop policy if exists "Admins can insert items" on public.items;
create policy "Admins can insert items"
on public.items
for insert
to authenticated
with check (public.is_admin());

drop policy if exists "Authenticated can update items" on public.items;
drop policy if exists "Anon can update items" on public.items;
drop policy if exists "Admins can update items" on public.items;
create policy "Admins can update items"
on public.items
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Authenticated can delete items" on public.items;
drop policy if exists "Anon can delete items" on public.items;
drop policy if exists "Admins can delete items" on public.items;
create policy "Admins can delete items"
on public.items
for delete
to authenticated
using (public.is_admin());

insert into storage.buckets (id, name, public)
values ('store-images', 'store-images', true)
on conflict (id) do nothing;

-- Bucket policies for store images
-- Public can view images
drop policy if exists "Public can view store images" on storage.objects;
create policy "Public can view store images"
on storage.objects
for select
to anon, authenticated
using (bucket_id = 'store-images');

-- Admin dashboard can upload images
drop policy if exists "Authenticated can upload store images" on storage.objects;
drop policy if exists "Anon can upload store images" on storage.objects;
drop policy if exists "Admins can upload store images" on storage.objects;
create policy "Admins can upload store images"
on storage.objects
for insert
to authenticated
with check (
    bucket_id = 'store-images'
    and public.is_admin()
    and name like (auth.uid()::text || '/%')
);

-- Admin dashboard can update images
drop policy if exists "Authenticated can update store images" on storage.objects;
drop policy if exists "Anon can update store images" on storage.objects;
drop policy if exists "Admins can update store images" on storage.objects;
create policy "Admins can update store images"
on storage.objects
for update
to authenticated
using (
    bucket_id = 'store-images'
    and public.is_admin()
    and name like (auth.uid()::text || '/%')
)
with check (
    bucket_id = 'store-images'
    and public.is_admin()
    and name like (auth.uid()::text || '/%')
);

-- Admin dashboard can delete images
drop policy if exists "Authenticated can delete store images" on storage.objects;
drop policy if exists "Anon can delete store images" on storage.objects;
drop policy if exists "Admins can delete store images" on storage.objects;
create policy "Admins can delete store images"
on storage.objects
for delete
to authenticated
using (
    bucket_id = 'store-images'
    and public.is_admin()
    and name like (auth.uid()::text || '/%')
);

-- Add one admin user after creating that auth account.
-- Replace with your real admin email and run once:
-- insert into public.admin_users (user_id)
-- select id from auth.users where email = 'admin@your-school.org'
-- on conflict (user_id) do nothing;
