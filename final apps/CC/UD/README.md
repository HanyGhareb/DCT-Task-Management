# UD — User Stories (Credit Cards, App 202)

> **UD = User-story Development.** This folder is the per-app backlog of **user stories**,
> each taken through its own **Dev → Test → Deploy** lifecycle. One folder per story.

Every app has a sibling `UD/` folder using this same layout. A **UD** is a self-contained
unit of work: a business-language user story, its acceptance criteria, and the tracked state
of building it, testing it, and shipping it to PROD.

## Layout

```
CC/UD/
  README.md                                 ← this file (the convention)
  UD-CC-01_<First-Story-Title>/
    UD-CC-01_<First-Story-Title>.md     ← the story pack (spec + Dev/Test/Deploy trackers)
    assets/                                 ← optional: mockups, diagrams, screenshots
  UD-CC-02_<Next-Story>/
    ...
```

## Naming

- **ID:** `UD-CC-<NN>` — app code + zero-padded 2-digit sequence (`UD-CC-01`, `UD-CC-02`, …).
  Sequence is **global-sequential per app** and never reused.
- **Folder:** `UD-CC-<NN>_<Short-Title-Kebab>`.
- **Doc:** same basename as the folder, `.md`.

## The story pack (one `.md` per UD)

Each pack has five parts, all in one file so a reviewer sees the whole unit at once:

1. **Story & scope** — persona, `As a / I want / So that`, in/out of scope.
2. **User stories + acceptance criteria** — `US-nn` sub-stories, each with Given/When/Then.
3. **Dev tracker** — the build broken into tasks, each mapped to the real DB script / ORDS
   handler / view + a status (`✅ Done` · `🟡 In progress` · `⬜ To do`).
4. **Test tracker** — test cases (Happy / Edge / Error / Boundary) tied to the UAT round, each
   with a status.
5. **Deploy tracker** — the deploy checklist (DB scripts, ORDS/synonyms, APP_VERSION bump,
   smoke test) + PROD deployment log.

## Lifecycle status (line at the top of each pack)

`Status: Draft → In Dev → In Test → Deployed → Verified`

---

*No stories yet. The first will be `UD-CC-01_<Short-Title>` — create its folder here when work starts.*
