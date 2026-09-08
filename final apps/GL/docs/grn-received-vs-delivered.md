# GRN: Fusion "Received" vs "Delivered" — project cost = the DELIVER leg

**Fusion-verified fact, 2026-09-06 (user confirmed with PO Order Life Cycle + Manage Project Costs screenshots).**

## The rule

Fusion's PO **Order Life Cycle** chart shows four bars: Ordered / **Received** / **Delivered** / Invoiced.
They are NOT the same thing:

| Fusion bar | Fusion step | Grain | Charges the project/budget? |
|---|---|---|---|
| **Received** | `RECEIVE` into Receiving | PO schedule | **No** — goods/services acknowledged only |
| **Delivered** | `Deliver To Expense Destination` | PO distribution | **Yes** — the ONLY step that carries project / task / expenditure type and hits the charge account |

The platform GRN actual (`ATD_GRN_ALL_V2` → `grn_all_v2` → butil GRN figure, GRN drill,
briefing-book/register GRN sheets) is the **Deliver leg, NET of `Correction To Deliver`
reversals**. It reconciles to Fusion's **Delivered** bar to the fils — never to the Received bar.
A `Correction To Deliver` pushes cost back out of the project into Receiving; the RECEIVE leg
(and the Received bar) is untouched by it.

## Consequence: negative "Uninvoiced AED" is a REAL signal

Register Uninvoiced = delivered (received-to-project) − invoiced, per PO distribution.
Since invoices match to the PO independently of delivery, invoiced can legitimately exceed
delivered. After the LINE-GRAIN PO RULE fix (2026-09-06) removed all attribution errors,
a negative Uninvoiced means exactly: **fully billed, but the cost is not (or no longer)
delivered to the project** — a genuine receiving/finance follow-up item, kept visible by design
(never floored to 0).

Live 2026 picture (all sectors/types): 67 negative rows, −1.72M AED total, all genuine —
either invoicing ahead of delivery, or invoice value slightly above receipt value (price/FX,
~1–2%: Avoris, Factum Arte, travel agencies).

## The proven case — PO 451102006280 (BLR WORLD PROJECT MANAGEMENT)

Project 4517000064 "ZNM - Interpretation", task 4510778, expenditure type 422621,
MSS Learning and Pu… organization. PO description: "Jan/Feb/March 2026 invoice for ZNM/BLR
Museum Educators".

| Date | Receipt | Transaction | Amount AED | Fusion Manage Project Costs trx |
|---|---|---|---|---|
| 05-May-2026 | 451204000294 | Deliver To Expense Destination | +1,313,060.98 | 1466137 |
| 13-May-2026 | 451204000294 | **Correction To Deliver** | **−1,295,882.24** | 1497105 |
| 02-Jun-2026 | 451204000409 | Deliver To Expense Destination | +17,178.74 | 1515247 |
| | | **Net delivered / project cost** | **34,357.48** | Total 34,357.48 |

Fusion Order Life Cycle for the PO: Ordered 1,330,239.72 · **Received 1,330,239.72** ·
**Delivered 34,357.48** · Invoiced 1,330,239.72. Our `grn_all_v2` rows are byte-identical to
Fusion Manage Project Costs (3 expenditure items, total 34,357.48).

So the A.2 register's −1,295,882 Uninvoiced on this PO is correct: the full delivery of
05-May was corrected back on 13-May while the 1.33M stayed invoiced — the project carries
34K of cost against 1.33M billed until Receiving re-delivers.

## Related

- LINE-GRAIN PO RULE (corrected invoices: line PO wins over stale dist PO) — CLAUDE.md
  Database Layer block, 2026-09-06.
- GRN AED = `ledger_amount` (never × conversion_rate) — CLAUDE.md GL row, 2026-07-10.
- GRN gap-fill (`otbi-atd/db/84`): injects receipts that have NO costing rows at all;
  it does NOT apply here — a corrected delivery IS costed (the +/− pair exists), so the
  net stays at the corrected value.
