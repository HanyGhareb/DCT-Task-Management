# Budget Utilization — Missing-Data Analysis (2026-07-02)

Companion to [`budget_utilization_query.sql`](budget_utilization_query.sql) (v7).
Snapshot taken against PROD after the 2026-07-02 reloads
(`ATD_PROJECTS_BUDGET` = 1,352 rows / **5,277.4M AED**; report = 1,352 budgeted lines).

Coverage at time of analysis:

| Report column | Filled | Gap |
|---|---|---|
| Department / Appropriation / Program | 100% | — |
| Chapter | 99.5% | 13 lines ≈ **349M** (gap 2) |
| Sector / Cost centre | 94.6% | 73 lines ≈ **371.7M** (gap 1) |

Both gaps are **source-data gaps, not query issues** — each fills automatically once
the data below is fixed; no query change needed. Re-check by re-running the
coverage counts (or just the query) after the next task/extract reload.

---

## Gap 1 — Sector blank on 73 budgeted lines (≈ 371.7M AED, 7% of budget)

**Cause:** Sector is mapped from the cost-centre **code**
(`DCT_GL_SEG_CLASS_MAP`, type `SECTOR`). These 73 tasks have an empty
`ATD_TASKS.COST_CENTER` **code**, and their projects have **no transactions yet**
to infer it from. Note `TASK_ORGANIZATION` (the org *name*) IS populated on every
one of them — the data exists in Fusion; the extract's cost-centre code column
just isn't populated for these tasks.

**Fix:** populate `COST_CENTER` for these tasks in the Fusion task setup /
Projects-Tasks extract. Sector then resolves via the defined SECTOR mapping
automatically.

**The 73 lines (ordered by budget):**

| Project # | Project Name | Task | Task Organization | Budget (AED) |
|---|---|---|---|---:|
| 4511001322 | The Sphere | Sponsorship Fees-L1 | DCT Planning, Strategy and Operations Department | 73,500,000 |
| 4511001328 | MOTN-Abu Dhabi | Co-Invest Events-N | DCT Destinations Management Department | 48,375,000 |
| 4511001340 | Formula 1 | Celebrities-L | DCT Planning, Strategy and Operations Department | 26,217,746 |
| 4511001246 | Coldplay Concert | Co-Invest Events-N | DCT Destinations Management Department | 16,220,963 |
| 4511000926 | Hype Beast - BRED | Co-Invest Events-N | DCT Destinations Management Department | 16,195,975 |
| 4511000723 | Comic Con | IP Events-N | DCT Abu Dhabi Events Bureau | 14,440,000 |
| 4511001362 | NBA Campaign | Celebrities-L | DCT Planning, Strategy and Operations Department | 13,909,851 |
| 4511001428 | Ghagha Island | Lease Improve-NC1 | DCT Culture | 12,000,000 |
| 4511001347 | Tripadvisor | Media Mgmnt &Buy-L | DCT Planning, Strategy and Operations Department | 11,200,000 |
| 4511001052 | 50 Best World | Sponsorship Fees-N | DCT Tendering and Projects Control | 10,269,708 |
| 4511001320 | Starzplay UFC | Sponsorship Fees-N1 | DCT Planning, Strategy and Operations Department | 9,250,000 |
| 4511001239 | Afterlife concert | Co-Invest Events-N | DCT Destinations Management Department | 9,180,000 |
| 4511001330 | MOTN-Al Dhafra | Co-Invest Events-N | DCT Destinations Management Department | 8,203,557 |
| 4511001346 | Airports - UAE | Offline Ads-L | DCT Planning, Strategy and Operations Department | 7,500,000 |
| 4511001401 | F1 Music Festival | Co-Invest Events-N | DCT Destinations Management Department | 7,340,000 |
| 4511000088 | CS-Prog-Dep-AD-Art | Event Management-N | DCT Visitor Experience | 7,234,509 |
| 4511001118 | VIP & Stakeholder | General Retainer-N | DCT Tourism Sector Management Office Division | 5,529,319 |
| 4511001170 | Sheikh Zayed Festival | Sponsorship Fees-N | DCT Tendering and Projects Control | 5,000,000 |
| 4511001350 | Airports - UK | Offline Ads-L | DCT Planning, Strategy and Operations Department | 4,215,465 |
| 4511001349 | Airports - USA | Offline Ads-L | DCT Planning, Strategy and Operations Department | 4,180,071 |
| 4511001060 | MELT Golf Classic Steve Harvey | Sponsorship Fees-N | DCT Tendering and Projects Control | 4,000,000 |
| 4511000718 | UAE warriors | Sponsorship Fees-L | DCT Planning, Strategy and Operations Department | 3,673,000 |
| 4511000723 | Comic Con | Talent Fees-N | DCT Planning, Strategy and Operations Department | 3,610,000 |
| 4511001169 | AUH Int. Boat Show | Sponsorship Fees-N | DCT Tendering and Projects Control | 3,500,000 |
| 4511001248 | Abu Dhabi Hunting Exhibition | Activation&Prog-N | DCT Tourism Sector Management Office Division | 3,500,000 |
| 4511000816 | The Abu Dhabi Culture Award | Event Management-N | DCT Visitor Experience | 3,038,800 |
| 4511001245 | AUH Comedy Week | Event Management-N | DCT Visitor Experience | 3,000,000 |
| 4511000285 | Event- SZHF | Event Management-N2 | DCT Strategic Planning Office - ALC | 2,970,000 |
| 4511001271 | Girona Laliga sponsorship | Sponsorship Fees-L | DCT Planning, Strategy and Operations Department | 2,745,400 |
| 4511000364 | MC - DM - China | SM Mgmnt Rtnr-N | DCT Creative and Production | 2,446,802 |
| 4511001355 | Airports - Germany | Offline Ads-L | DCT Planning, Strategy and Operations Department | 2,357,532 |
| 4511000744 | Michellin Audit | Audit Services-N | DCT Licensing | 2,250,000 |
| 4511001369 | UFC campaign | Celebrities-L | DCT Planning, Strategy and Operations Department | 2,195,027 |
| 4511001356 | Airports - China | Offline Ads-L | DCT Planning, Strategy and Operations Department | 2,152,151 |
| 4511001359 | Airports - France | Offline Ads-L | DCT Planning, Strategy and Operations Department | 1,964,618 |
| 4511001367 | Airports - Italy | Offline Ads-L | DCT Planning, Strategy and Operations Department | 1,340,747 |
| 4511000088 | CS-Prog-Dep-AD-Art | Media Mgmnt &Buy-N | DCT Strategic Planning Office - ALC | 1,299,240 |
| 4511000453 | TS - DM - MS | MediaBuyRetainer-L | DCT Planning, Strategy and Operations Department | 1,260,003 |
| 4511000643 | CS - IH - IPE ICH | ICH Management-N | DCT Intangible Cultural Heritage | 1,140,000 |
| 4511001329 | MOTN-Al Ain | Co-Invest Events-N | DCT Destinations Management Department | 1,024,000 |
| 4511001070 | Capital Briefing | Hospitality-N | DCT Tourism Sector Management Office Division | 1,000,000 |
| 4511001370 | Airports - Russia | Offline Ads-L | DCT Planning, Strategy and Operations Department | 998,957 |
| 4511001328 | MOTN-Abu Dhabi | Facilities Rent-N | DCT Visitor Experience | 975,609 |
| 4511001469 | We are Ona & Salt Camp | Event Management-N | DCT Visitor Experience | 854,046 |
| 4511001119 | Festival & Celebration Concert | Event Management-N | DCT Visitor Experience | 795,297 |
| 4511000859 | Egyptian Super Cup | Event Management-N | DCT Visitor Experience | 755,447 |
| 4511000188 | CS-Art-Dep-Music | Activation&Prog-N | DCT Tourism Sector Management Office Division | 745,000 |
| 4511000357 | CS - CP - Sounds of the UAE | Event Management-N | DCT Visitor Experience | 700,000 |
| 4511000920 | City of Music | Media Mgmnt &Buy-N | DCT Strategic Planning Office - ALC | 678,558 |
| 4511000642 | CS - IH -ICHE | ICH Management-N | DCT Intangible Cultural Heritage | 590,000 |
| 4511000373 | MC - Spon. - Jiu Jitsu | Sponsorship Fees-N | DCT Tendering and Projects Control | 500,000 |
| 4511000914 | Handicrafts Heritage Festival | Media Mgmnt &Buy-N | DCT Strategic Planning Office - ALC | 449,604 |
| 4511000188 | CS-Art-Dep-Music | Talent Fees-N | DCT Planning, Strategy and Operations Department | 391,185 |
| 4511001310 | ICOM 2025 | Concept Develop-N | DCT Library Management Division | 340,000 |
| 4511000357 | CS - CP - Sounds of the UAE | Talent Fees-N | DCT Planning, Strategy and Operations Department | 305,000 |
| 4511000356 | CS - Prog. - Music - Umsiyat | Talent Fees-N | DCT Planning, Strategy and Operations Department | 293,773 |
| 4511000638 | CS - IH - ATP | Training & Dev-N | DCT Visitor Experience | 243,772 |
| 4511000087 | CS-Int Her-Element | Event Management-N | DCT Visitor Experience | 180,000 |
| 4511000087 | CS-Int Her-Element | Other Expenses-N | DCT Tourism Sector Management Office Division | 180,000 |
| 4511001194 | UNWTO Renewal | Licenses Fees-N | DCT Visitor Experience | 158,000 |
| 4511001082 | Stakeholder Engagement | Activation&Prog-N | DCT Tourism Sector Management Office Division | 150,000 |
| 4511000188 | CS-Art-Dep-Music | Mission & Travel-N | DCT Visitor Experience | 145,000 |
| 4511000635 | CS - IH - ADAR | Freelancers-N | DCT Visitor Experience | 136,228 |
| 4511001371 | Diwali | Media Mgmnt &Buy-L | DCT Planning, Strategy and Operations Department | 135,966 |
| 4511001067 | Accommodation for VIP guests | Talent Accom-N | DCT Tourism Sector Management Office Division | 98,800 |
| 4511000709 | FM - Al Ain Warehouse | Maintenance-N1 | DCT Facilities Management and General Services | 80,000 |
| 4511000088 | CS-Prog-Dep-AD-Art | Mission & Travel-N | DCT Visitor Experience | 80,000 |
| 4511000356 | CS - Prog. - Music - Umsiyat | Activation&Prog-N | DCT Tourism Sector Management Office Division | 76,422 |
| 4511000356 | CS - Prog. - Music - Umsiyat | Hospitality-N | DCT Tourism Sector Management Office Division | 70,000 |
| 4511000645 | CS - IH - TPABCP | ICH Management-N | DCT Intangible Cultural Heritage | 50,000 |
| 4511000088 | CS-Prog-Dep-AD-Art | Collaterals-N | DCT Marketing and Communications - Unit | 37,260 |
| 4511001083 | Stakeholder Eng. Activities | Entertainment-N | DCT Tourism Sector Management Office Division | 30,000 |
| 4511001309 | UNESCO International Jazz Day | Event Management-N | DCT Visitor Experience | 1 |

---

## Gap 2 — Chapter blank on 13 budgeted lines (≈ 349M AED)

**Cause:** the tasks' `APPROPRIATION` codes below have **no CHAPTER mapping**
defined in the GL classification model (`DCT_GL_SEG_CLASS_MAP`, type `CHAPTER`)
— and they are also absent from the loaded COA combinations, so they look like
non-standard / legacy codes:

| Appropriation code | Budget lines | Budget (M AED) |
|---|---:|---:|
| 50723 | 4 | 140.00 |
| 50729 | 2 | 139.56 |
| 50730 | 1 | 67.00 |
| 0 (none) | 6 | 2.16 |

**Fix (either):**
1. Add CHAPTER mappings for `50723` / `50729` / `50730` in the GL app (App 210 →
   Classifications / Mapping); or
2. Correct the appropriation on those tasks in Fusion if the codes are wrong
   (standard codes look like `200104`).
   The `0` lines simply have no appropriation set on the task.

---

## Related fix already applied (same day)

The projects reload changed `ATD_PROJECTS.PROJECT_NUMBER` to VARCHAR2 (Trust
projects use numbers like `T4514`), which invalidated `DCT_ACTUAL_V` with
ORA-01790 (UNION branches mixed NUMBER/VARCHAR2 project_number). Fixed in
`db/v2/32_dct_actuals_reporting.sql` (AP branch `TO_CHAR(l.project_number)`,
GL branch `CAST(NULL AS VARCHAR2(30))`) and redeployed — all views VALID.
