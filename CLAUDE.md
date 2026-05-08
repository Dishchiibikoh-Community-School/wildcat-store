# Wildcat Store

## Rules
- Check Obsidian project note before starting work: `C:\Users\Cerus\OneDrive\Documents\Obsidian Vault\projects\wildcat-store.md`
- Update Session Log at end of each session
- Run /graphify . after major refactors
- Use `py -m graphify` not `graphify` directly (Windows PATH issue)

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- For cross-module "how does X relate to Y" questions, prefer `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"` over grep — these traverse the graph's EXTRACTED + INFERRED edges instead of scanning files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
