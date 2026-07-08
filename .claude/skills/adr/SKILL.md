---
name: adr
description: Create a new Architecture Decision Record in docs/adr/ following this repo's format (Japanese, MADR-style). Use when a design or tooling decision has been made and should be recorded, or when the user asks to write an ADR.
---

# Create a new ADR

1. List `docs/adr/` and take the next sequential number (zero-padded to 4
   digits). Read the most recent ADR to match tone and depth — see
   `docs/adr/0001-dotfiles-symlink-management.md` as the reference.

2. Create `docs/adr/NNNN-<kebab-case-slug>.md` written in **Japanese**
   (the slug stays English), with this structure:

   ```markdown
   # ADR NNNN: <決定内容を一文で>

   - **Status**: Accepted   <!-- or Proposed / Superseded by ADR-XXXX -->
   - **Date**: YYYY-MM-DD

   ## Context
   <なぜこの決定が必要になったか。要件を箇条書きで>

   ## Decision
   <決定内容を太字で一文、続けて具体的な運用方法>

   ## Alternatives Considered
   | 方法 | 不採用の理由 |
   |------|--------------|

   ## Consequences
   <良い影響・悪い影響の両方>

   ## Revisit Criteria
   <この決定を再検討するトリガー条件>
   ```

3. Fill in real trade-offs from the conversation. Alternatives must include the
   strongest rival and an honest reason for rejecting it — not strawmen.

4. If the new ADR supersedes an old one, update the old ADR's Status to
   `Superseded by ADR-NNNN`.

5. Reference the new ADR from `README.md` / `CLAUDE.md` if the decision changes
   documented workflows.
