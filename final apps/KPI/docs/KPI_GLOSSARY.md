# Finance KPI App 213 — Bilingual Business Glossary

**Status:** DRAFT FOR BUSINESS REVIEW  
**Owner:** Finance KPI product owner  
**Rule:** approved terms become the source for all v2 i18n labels; internal framework terms
must not appear in primary user journeys.

## 1. Core navigation

| Concept | English label | Arabic label | Usage note | Approval |
|---|---|---|---|---|
| Landing page | Home | الرئيسية | Role-aware work requiring attention | PENDING |
| User work | My tasks | مهامي | Prefer over “My Worklist” | PENDING |
| Executive performance | Scorecard | بطاقة أداء المؤشرات | Prefer over generic “Dashboard” | PENDING |
| KPI browse area | KPIs | مؤشرات الأداء | Business pages, not registry setup | PENDING |
| Reports | Reports | التقارير | | PENDING |
| Admin area | Administration | الإدارة | KPI admin only | PENDING |
| Alerts | Notifications | الإشعارات | Available from top-bar bell | PENDING |

## 2. Measurement and task language

| Concept | English label | Arabic label | Avoid | Approval |
|---|---|---|---|---|
| KPI result for one period | Measurement | قياس المؤشر | Result instance | PENDING |
| Work requiring immediate action | Due now | مستحق الآن | Open period | PENDING |
| Submission deadline | Due date | تاريخ الاستحقاق | Period end (unless identical) | PENDING |
| Late task | Overdue | متأخر | Expired | PENDING |
| Near deadline | Due soon | مستحق قريبًا | Warning status | PENDING |
| Work started but not sent | Draft | مسودة | Incomplete record | PENDING |
| Sent into approval | Awaiting approval | بانتظار الاعتماد | Submitted instance | PENDING |
| Sent back to preparer | Returned for revision | معاد للتعديل | Rejected, when revision is allowed | PENDING |
| Fully accepted | Approved | معتمد | Completed instance | PENDING |
| Official expected level | Target | المستهدف | Threshold | PENDING |
| Calculated performance | Achievement | الإنجاز | Result % | PENDING |
| Rating on DOF 1–5 scale | Score | الدرجة | Band result | PENDING |
| Supporting material | Supporting documents | المستندات الداعمة | Evidence register | PENDING |
| Mandatory supporting item | Required document | مستند مطلوب | Required evidence flag | PENDING |
| Free supporting item | Other supporting document | مستند داعم آخر | Generic evidence | PENDING |

## 3. Source and entry language

| Concept | English label | Arabic label | Avoid | Approval |
|---|---|---|---|---|
| Value obtained from GL | From the General Ledger | من الأستاذ العام | AUTO | PENDING |
| Broader system-derived value | System figure | الرقم المستخرج من النظام | System suggestion | PENDING |
| Value typed/changed by preparer | Entered manually | مُدخل يدويًا | MANUAL | PENDING |
| Use system-derived value | Use system figure | استخدام رقم النظام | Use suggestion | PENDING |
| Explain changed system value | Reason for changing the system figure | سبب تعديل رقم النظام | Notes | PENDING |
| Recalculate source value | Refresh system figure | تحديث رقم النظام | Refresh suggestion | PENDING |
| Saved feedback | Saved just now | تم الحفظ الآن | Result saved | PENDING |
| Save failure | We couldn't save your changes | تعذر حفظ التغييرات | Failed | PENDING |

## 4. Wizard and approval actions

| Concept | English label | Arabic label | Usage note | Approval |
|---|---|---|---|---|
| Numeric entry step | Figures | الأرقام | Use only when KPI is numeric | PENDING |
| Rubric entry step | Assessment | التقييم | Use for weighted criteria | PENDING |
| Upload step | Supporting documents | المستندات الداعمة | | PENDING |
| Final step | Review and submit | المراجعة والتقديم | | PENDING |
| Continue | Continue | متابعة | Primary within wizard | PENDING |
| Previous step | Back | رجوع | | PENDING |
| Send to workflow | Submit for approval | تقديم للاعتماد | | PENDING |
| Accept outcome | Approve | اعتماد | Render only from server outcome | PENDING |
| Send back for correction | Return for revision | إعادة للتعديل | Comment required | PENDING |
| Terminal negative outcome | Reject | رفض | Confirm business consequence | PENDING |
| Approver decision page | Review submission | مراجعة الطلب | Avoid “Act on task” | PENDING |
| Approval history | Approval history | سجل الاعتماد | Prefer over “workflow timeline” | PENDING |
| Submission acknowledgement | Submitted successfully | تم التقديم بنجاح | Include reference and next step | PENDING |

## 5. Score interpretation

| Meaning | English label | Arabic label | Rule to confirm | Approval |
|---|---|---|---|---|
| Better than target | Above target | أعلى من المستهدف | KPI polarity aware | PENDING |
| Target achieved | On target | محقق للمستهدف | Tolerance to confirm | PENDING |
| Worse than target | Below target | أقل من المستهدف | KPI polarity aware | PENDING |
| Strong score | Strong performance | أداء قوي | Score mapping to confirm | PENDING |
| Middle score | Moderate performance | أداء متوسط | Score mapping to confirm | PENDING |
| Low score | Needs attention | يحتاج إلى متابعة | Score mapping to confirm | PENDING |
| Missing official data | No approved results yet | لا توجد نتائج معتمدة بعد | Do not show an empty chart | PENDING |
| Partial year | Based on {n} approved measurements | استنادًا إلى {n} من القياسات المعتمدة | | PENDING |
| Comparison improved | Improved from last year | تحسن عن السنة السابقة | | PENDING |
| Comparison declined | Lower than last year | أقل من السنة السابقة | Avoid judgmental wording | PENDING |
| No prior comparison | No previous-year result | لا توجد نتيجة للسنة السابقة | | PENDING |

## 6. KPI names and plain-language prompts

### Revenue Growth (`REV_GROWTH`)

| Content | English | Arabic | Approval |
|---|---|---|---|
| Name | Revenue Growth | نمو الإيرادات | Existing seed — confirm |
| Current-year question | What was total actual revenue in {year}? | ما إجمالي الإيرادات الفعلية في سنة {year}؟ | PENDING |
| Prior-year question | What was total actual revenue in {year-1}? | ما إجمالي الإيرادات الفعلية في سنة {year-1}؟ | PENDING |
| Explanation | Compares this year's actual revenue with the previous year. | يقارن الإيرادات الفعلية لهذه السنة بالسنة السابقة. | PENDING |

Do not display A/B letters in the preparer flow.

### Optimization Plan (`OPT_PLAN`)

| Content | English | Arabic | Approval |
|---|---|---|---|
| Name | Optimization Plan — Chapters 1, 2 and 3 | خطة التحسين — الأبواب 1 و2 و3 | Existing seed — punctuation simplified |
| Intro question | Assess the approved optimization plan for {year}. | قيّم خطة التحسين المعتمدة لسنة {year}. | PENDING |
| Data Quality | Data quality | جودة البيانات | Existing seed |
| Approval Status | Approval status | حالة الاعتماد | Existing seed |
| Execution Plan | Execution plan | خطة التنفيذ | Existing seed |
| Results Achieved | Results achieved | النتائج المحققة | Existing seed |
| Explanation | Rates the quality, approval, execution, and achieved savings of the plan. | يقيّم جودة الخطة واعتمادها وتنفيذها والوفورات المحققة. | PENDING |

Maturity-level names and descriptions remain circular-controlled content and require business
confirmation before shortening.

### Cash Management and Financial Planning (`CASH_MGMT`)

| Content | English | Arabic | Approval |
|---|---|---|---|
| Name | Cash Management and Financial Planning | إدارة النقد والتخطيط المالي | Confirm whether exclusion belongs in subtitle |
| Scope | Excluding capital projects | باستثناء المشاريع الرأسمالية | Existing seed |
| Actual question | What was actual operating expenditure for {quarter}? | ما المصروفات التشغيلية الفعلية للربع {quarter}؟ | PENDING |
| Forecast question | What was forecast cash flow for {quarter}? | ما التدفق النقدي المتوقع للربع {quarter}؟ | PENDING |
| Explanation | Measures the difference between actual expenditure and forecast cash flow. Lower variance is better. | يقيس الفرق بين المصروفات الفعلية والتدفق النقدي المتوقع. كلما قل الانحراف كان الأداء أفضل. | PENDING |

Do not lead with `Abs(1 − Actual / Forecast) × 100`; keep the formula under “How this is
scored”.

### Compliance with Financial Law (`FIN_LAW_COMP`)

| Content | English | Arabic | Approval |
|---|---|---|---|
| Name | Compliance with Financial Law, Resolutions and Circulars | الامتثال للقانون المالي والقرارات والتعاميم | Existing seed — confirm |
| Intro question | Record achievement for each compliance requirement in {year}. | سجّل نسبة الإنجاز لكل متطلب امتثال في سنة {year}. | PENDING |
| Explanation | Combines eight financial-compliance requirements into one annual score. | يجمع ثمانية متطلبات للامتثال المالي في درجة سنوية واحدة. | PENDING |

The eight existing criterion names and their collection cadence remain controlled business
content. Confirm whether users should enter them throughout the year or once annually.

## 7. Administration-only terminology

These terms may appear inside Administration but should not appear in the preparer’s primary
journey.

| Internal concept | English admin label | Arabic admin label | Approval |
|---|---|---|---|
| KPI registry | KPI definitions | تعريفات مؤشرات الأداء | PENDING |
| Score bands | Scoring rules | قواعد احتساب الدرجة | PENDING |
| Weighted criteria | Assessment criteria and weights | معايير التقييم وأوزانها | PENDING |
| Calculation method | Calculation method | طريقة الاحتساب | PENDING |
| Polarity | Performance direction | اتجاه الأداء | PENDING |
| Source mapping | System data source | مصدر بيانات النظام | PENDING |
| Period generation | Open measurement year | فتح سنة القياس | PENDING |
| Scorecard weight | Overall score weight | وزن الدرجة الإجمالية | PENDING |
| Assignment | Responsible preparer | مُعدّ المؤشر المسؤول | PENDING |
| Evidence requirement | Required document setup | إعداد المستندات المطلوبة | PENDING |

## 8. Terms prohibited from primary journeys

- Result instance / workflow instance.
- KPI × period matrix.
- Provenance.
- AUTO / MANUAL.
- Figure A / Figure B.
- Band operator, threshold, first-match evaluation.
- Resolver, outcome set, source module, record ID.
- Generate periods.

These may remain in technical documentation or controlled Administration screens where needed.

## 9. Business sign-off

| Reviewer role | Name | Decision | Date | Comments |
|---|---|---|---|---|
| KPI product owner | TBC | PENDING | | |
| Arabic-language reviewer | TBC | PENDING | | |
| Preparer representative | TBC | PENDING | | |
| Approver representative | TBC | PENDING | | |
| Executive representative | TBC | PENDING | | |

After approval, update the status to `APPROVED`, record the date, and use this file as the
source for v2 English and Arabic i18n keys.

