# Graph Report - .  (2026-05-05)

## Corpus Check
- 2 files · ~220,191 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 49 nodes · 67 edges · 8 communities detected
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 7 edges (avg confidence: 0.88)
- Token cost: 46,600 input · 11,649 output

## Community Hubs (Navigation)
- [[_COMMUNITY_7 Habits & Behavior Rewards|7 Habits & Behavior Rewards]]
- [[_COMMUNITY_Site Shell & Brand Hub|Site Shell & Brand Hub]]
- [[_COMMUNITY_Stationery Products|Stationery Products]]
- [[_COMMUNITY_Wildcat Mascot Identity|Wildcat Mascot Identity]]
- [[_COMMUNITY_Fun Products|Fun Products]]
- [[_COMMUNITY_Tech Products|Tech Products]]
- [[_COMMUNITY_Apparel Products|Apparel Products]]
- [[_COMMUNITY_Accessories Products|Accessories Products]]

## God Nodes (most connected - your core abstractions)
1. `Store Grid Container` - 16 edges
2. `Habits Modal` - 9 edges
3. `Wildcat Store (Site)` - 6 edges
4. `Wildcat Logo Image` - 5 edges
5. `Home Page` - 4 edges
6. `Feature: Leader in Me 7 Habits` - 4 edges
7. `Store Page (Current Collection)` - 4 edges
8. `Concept: Wildcat Bucks (WB)` - 4 edges
9. `Category: Stationery` - 4 edges
10. `Features Section` - 3 edges

## Surprising Connections (you probably didn't know these)
- `Concept: Wildcat Bucks (WB)` --conceptually_related_to--> `Concept: In-Person Friday Lunch Redemption`  [INFERRED]
  index.html → index.html  _Bridges community 0 → community 1_

## Hyperedges (group relationships)
- **All Feature Cards (Earning Methods)** —  [EXTRACTED 1.00]
- **Leader in Me 7 Habits (Complete Set)** —  [EXTRACTED 1.00]
- **All Store Products (Current Collection)** —  [EXTRACTED 1.00]

## Communities

### Community 0 - "7 Habits & Behavior Rewards"
Cohesion: 0.22
Nodes (11): Concept: Wildcat Bucks (WB), Feature: Leader in Me 7 Habits, Feature: Attendance, Features Section, Habit 1: Be Proactive, Habit 2: Begin with the End in Mind, Habit 3: Put First Things First, Habit 4: Think Win-Win (+3 more)

### Community 1 - "Site Shell & Brand Hub"
Cohesion: 0.27
Nodes (10): Concept: In-Person Friday Lunch Redemption, CTA: Browse The Store, Footer, Hero Section (Earn. Save. Redeem.), Home Page, Wildcat Store Logo, Navigation Bar, Store Page (Current Collection) (+2 more)

### Community 2 - "Stationery Products"
Cohesion: 0.53
Nodes (6): Category: Stationery, Product: Highlighters (20 WB, Stationery), Product: Neon Gel Pens (25 WB, Stationery), Product: Pencil Kit (30 WB, Stationery), Product: Spiral Notebook (15 WB, Stationery), Store Grid Container

### Community 3 - "Wildcat Mascot Identity"
Cohesion: 0.4
Nodes (6): Blue and White Color Scheme, Fierce Roaring Feline Profile, School Brand Identity, Athletic/Esports Mascot Logo Style, Wildcat Mascot, Wildcat Logo Image

### Community 4 - "Fun Products"
Cohesion: 0.5
Nodes (4): Category: Fun, Habit 7: Sharpen the Saw, Product: Sticker Pack (10 WB, Fun), Product: Stress Ball (15 WB, Fun)

### Community 5 - "Tech Products"
Cohesion: 0.5
Nodes (4): Category: Tech, Product: LED Key Light (35 WB, Tech, OUT OF STOCK), Product: Phone Stand (45 WB, Tech), Product: Wireless Earbuds (200 WB, Tech)

### Community 6 - "Apparel Products"
Cohesion: 0.5
Nodes (4): Category: Apparel, Product: Baseball Cap (75 WB, Apparel), Product: Knit Beanie (60 WB, Apparel), Product: Wildcat Hoodie (2000 WB, Apparel)

### Community 7 - "Accessories Products"
Cohesion: 0.5
Nodes (4): Category: Accessories, Product: Gym Bag (50 WB, Accessories), Product: Spirit Lanyard (20 WB, Accessories), Product: Matte Water Bottle (80 WB, Accessories)

## Knowledge Gaps
- **8 isolated node(s):** `Habit 2: Begin with the End in Mind`, `Habit 3: Put First Things First`, `Habit 4: Think Win-Win`, `Habit 5: Seek First to Understand, Then to Be Understood`, `Habit 6: Synergize` (+3 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Store Grid Container` connect `Stationery Products` to `Site Shell & Brand Hub`, `Fun Products`, `Tech Products`, `Apparel Products`, `Accessories Products`?**
  _High betweenness centrality (0.513) - this node is a cross-community bridge._
- **Why does `Store Page (Current Collection)` connect `Site Shell & Brand Hub` to `Stationery Products`?**
  _High betweenness centrality (0.306) - this node is a cross-community bridge._
- **Why does `Wildcat Store (Site)` connect `Site Shell & Brand Hub` to `7 Habits & Behavior Rewards`?**
  _High betweenness centrality (0.256) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Wildcat Logo Image` (e.g. with `School Brand Identity` and `Athletic/Esports Mascot Logo Style`) actually correct?**
  _`Wildcat Logo Image` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Habit 2: Begin with the End in Mind`, `Habit 3: Put First Things First`, `Habit 4: Think Win-Win` to the rest of the system?**
  _8 weakly-connected nodes found - possible documentation gaps or missing edges._