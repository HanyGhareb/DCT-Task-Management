# SoapUI CreateCustomers generator (AR Customer / DoF Fusion Receivables)

Turns an **Excel sheet of customers** into a **SoapUI project** you can open on
your machine and run against the DoF gateway — endpoint, `x-CentraSite-APIKey`
header, Basic-auth credentials and the full `CreateCustomers` envelope are all
pre-wired (one `<postCustomerData>` per Excel row).

Wire spec: `final apps/AR/docs/ws/receivables-customer-ws.md`.

> The AR JET app has the same generator built into the **AR Customers** page
> (SoapUI Generator button, AR_ADMIN only) — `Jet/js/services/soapuiGen.js` is a
> browser port of this script; **keep the two in sync** when the wire catalog changes.

## Requirements

Python 3.8+ with `openpyxl` (`pip install openpyxl`). SoapUI 5.x on your machine.

## 1. Get the Excel template

```bash
python generate_soapui_customers.py --make-template customers_template.xlsx
```

- **Customers** sheet: all 69 wire columns. **Orange headers = required** (21);
  hover any header for hints (allowed values, date format, default).
- Row 2 is an **example row** — replace it (an untouched example row is skipped).
- **LOVs** sheet: the pre-defined value list for every constrained field.
- Leave a cell empty and the generator applies the standard defaults
  (`TRX_OPER=CREATE`, `CUSTOMER_TYPE=ORGANIZATION`, `ORG_CODE=DCT`,
  `SOURCE_SYSTEM=DCT_SYSTEM`, `COLLECTOR_NAME=Default Collector`,
  `VAT_REGISTERATION_TYPE=VAT`, `TAX_REGIME_CODE=VAT_REGIME_UAE`,
  `COUNTRY_CODE=AE`, `EMIRATE=Abu Dhabi`, `CUST_SITE_PURPOSE=BOTH`,
  `CUSTOMER_CATEGORY_NAME=High Value Customer`, `ATTRIBUTE10=Y`;
  `CUSTOMER_NAME_AR` falls back to the EN name).
- Dates: real Excel dates or `DD-MM-YYYY` text both work (ISO is converted).
- Numbers (VAT/phone) are cleaned (`104206210700003`, never `…3.0`).

## 2. Generate the SoapUI project

```bash
# UAT / stage gateway
python generate_soapui_customers.py --excel customers.xlsx --env stage --out DCT-CreateCustomers.xml

# production gateway (different endpoint AND different API key — handled automatically)
python generate_soapui_customers.py --excel customers.xlsx --env prod --out DCT-CreateCustomers.xml
```

Useful flags: `--chunk 50` customers per request (big sheets become several
requests: "CreateCustomers 1-50 of 380", …), `--password` / `--apikey` /
`--endpoint` overrides, `--sheet` name, `--trx-oper UPDATE-SITE-CUSTOMER`.

Rows failing required-field validation abort generation with a per-row report.

## 3. Run it in SoapUI

1. **File → Import Project** → pick the generated XML.
2. Expand *ADGGenericSoapWrapperProcess_… → ADGSoapWraperProcess*.
3. Open a request and hit ▶ (green arrow). Header, endpoint and Basic auth are
   already set. Run chunks in order.

## Notes / gotchas

- Your machine's IP must be allowed by the gateway — PROD (`api.abudhabi.ae`)
  resets non-whitelisted sources; STAGE is generally open.
- The STAGE Basic-auth password embedded by default is the one from the original
  SoapUI project and returned 401 on 2026-07-08 — pass the current UAT password
  with `--password` if it was rotated.
- Creation is **asynchronous**: a SUCCESS response means "accepted into the
  Fusion interface". Fetch the assigned customer codes later with the
  `getEntityCustomerDtls` operation (`STATUS=PROCESSED`) or via the AR app's
  *Check Status*.
