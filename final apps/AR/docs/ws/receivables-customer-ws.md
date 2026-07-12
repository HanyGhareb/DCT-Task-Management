# DoF Receivables SOAP — Customer Integration Spec (App 206 / AR Customer page)

Extracted 2026-07-08 from the user-provided SoapUI project `DOF-Fusion-UAT-soapui-project.xml`
(DoF Fusion integration via the Abu Dhabi government API gateway / webMethods CentraSite).
**Do NOT store passwords/API keys in this file or in any frontend code** — they live in
`DCT_SYSTEM_SETTINGS` as SECRET-type settings (see § Settings).

---

## 1. Service shape — generic SOAP wrapper

One WSDL, one operation. Every business call is routed by an `OperationName` inside the body
(`InputPayload` is `anyType` — no XSD validation of the inner payload; "required" is enforced
by the Fusion backend, not the schema).

```
POST <endpoint>            SOAPAction: ADGSoapWraperProcess
Headers: x-CentraSite-APIKey: <key>   +  HTTP Basic (ADGE_DCT_INTG_SVC / <password>)
Content-Type: text/xml;charset=UTF-8

<soapenv:Envelope>
  <soapenv:Body>
    <adg:ADGRequestPayload xmlns:adg="http://xmlns.oracle.com/ADGGenericSoapWrapperApplication/ADGGenericSoapWrapperProcess">
      <adg:OperationName>CreateCustomers</adg:OperationName>
      <adg:InputPayload> ...business XML... </adg:InputPayload>
    </adg:ADGRequestPayload>
  </soapenv:Body>
</soapenv:Envelope>
```

Response = `ADGResponsePayload/OutputPayload` (anyType). Gateway errors come back as SOAP
faults, e.g. `faultstring: Native service provider error. HTTP statusCode: 401`.

## 2. Environments (VERIFIED 2026-07-08)

| Env | Endpoint | API key | Basic pw | Reachability |
|---|---|---|---|---|
| STAGE/UAT | `https://stage-api.abudhabi.ae/ws/Receivables_TEST/1.0` | `1d9b23f1-bfca-43fc-8099-944fd7faf664` | (stage pw — TO CONFIRM, backend returned 401 with both pw values found in the SoapUI file) | ✅ OPEN — reachable from dev VM AND from the ADB (`apex_web_service` HTTP 200 on `?wsdl`) |
| STAGE/UAT alt | `https://stage-api.abudhabi.ae/ws/Receivables_DGE-GD_UAT/1.0` | same | same | same gateway |
| PROD | `https://api.abudhabi.ae/ws/Receivables/1.0` | `030140d2-...283b` (per SoapUI; the `1d9b23f1` key is the STAGE key) | prod pw | ❌ IP-WHITELISTED — TCP reset from dev VM and ADB (129.151.135.88). Whitelist request required. |

Date format everywhere: `DD-MM-YYYY`.

## 3. Operations relevant to the AR Customer page

### 3.1 CreateCustomers (create AND update)
`InputPayload > CreateCustomers > arg0 > postCustomerData` (repeatable — bulk supported).
`TRX_OPER` = `CREATE` | `UPDATE-SITE-CUSTOMER`.
Creation is **asynchronous**: the record lands in a Fusion interface; the assigned
`CUSTOMER_CODE` appears later via `getEntityCustomerDtls` with `STATUS=PROCESSED`.

### 3.2 getEntityCustomerDtls (query / status check / dup check)
`InputPayload > getEntityCustomerDtls > arg0`:
`CUSTOMER_CODE, CUSTOMER_TYPE, CUST_UNIQUE_NUMBER, CUST_VAT_NUMBER, PERSON_IDEN_NUM,
CR_NUMBER, CUST_NAME, ORG_CODE (DCT), CUST_SOURCE_SYSTEM, P_FROM_DATE, P_TO_DATE,
PAGE_NO (paged), STATUS (e.g. PROCESSED)` — all optional filters.

(The service also exposes `CreateARInvoice`, `getARInvoiceDtls`, `CreateARReceipt`,
`getStdReceiptDtls` — out of scope for this page, same wrapper pattern.)

## 4. postCustomerData — full attribute catalog

Schema-wise everything is optional (`anyType`); **Req** below = consistently populated in all
production CREATE samples → treat as mandatory on the form. **LOV** = pre-defined value set
observed (seed in `DCT_LOOKUP_VALUES`, editable in Admin lookups).

| # | Field | Req | LOV / format / default |
|---|---|---|---|
| 1 | TRX_OPER | ✔ | `CREATE`, `UPDATE-SITE-CUSTOMER` |
| 2 | CUSTOMER_TYPE | ✔ | `ORGANIZATION` (PERSON presumed for individuals) |
| 3 | CUSTOMER_NAME | ✔ | free text |
| 4 | CUSTOMER_NAME_AR | ✔ | free text (samples fall back to the EN name) |
| 5 | CUSTOMER_CATEGORY_NAME | ✔ | `High Value Customer` |
| 6 | CUSTOMER_CLASS_NAME | ✔ | `Local Company`, `International`, `Local` |
| 7 | CUSTOMER_PROFILE | — | `DEFAULT` |
| 8 | COUNTRY_CODE | ✔ | ISO-2 (`AE`…) — LOV from `DCT_COUNTRY` reference table |
| 9 | EMIRATE | ✔ | `Abu Dhabi` (+ other emirates) |
| 10 | CITY | ✔ | free text |
| 11 | ADDRESS1 | ✔ | free text |
| 12–14 | ADDRESS2 / ADDRESS3 / ADDRESS4 | — | free text |
| 15 | POSTAL_CODE | — | free text (`NA` used when none) |
| 16 | PO_BOX_NUMBER | — | free text |
| 17 | AREA | — | free text |
| 18 | SITE_NAME | ✔ | free text (city in samples) |
| 19 | SITE_CODE | ✔ | trade licence # or legacy # in samples |
| 20 | SITE_NUMBER | — | free text |
| 21 | SITE_END_DATE | — | DD-MM-YYYY |
| 22 | CUST_SITE_PURPOSE | ✔ | `BOTH` (BILL_TO / SHIP_TO presumed) |
| 23 | LEGACY_CUSTOMER_NUMBER | ✔ | our reference — key for status lookup |
| 24 | LEGACY_CUSTOMER_SITE_NUMBER | ✔ | our site reference |
| 25 | TRADE_LICENSE_NUM | cond. | required for licensed orgs (`CN-…`) |
| 26 | CONTACT_PERSON | ✔ | free text |
| 27 | CONTACT_NUMBER | — | free text |
| 28 | EMAIL_ADDRESS | — | email |
| 29 | PREF_CONTACT_METHOD | — | `EMAIL` |
| 30 | PREF_DELIVERY_METHOD | — | `EMAIL` |
| 31 | ACCT_CONTACT_RESP_TYPE | — | `Statement` |
| 32 | PERSON_IDEN_TYPE | cond. | `ID_NUMBER`, `EMAIL` |
| 33 | PERSON_IDENTIFIER | cond. | pairs with PERSON_IDEN_TYPE |
| 34 | VAT_NUMBER | cond. | 15-digit TRN; required when VAT-registered |
| 35 | VAT_REGISTERATION_TYPE | ✔ | `VAT` |
| 36 | VAT_REG_START_DATE / VAT_REG_END_DATE | — | DD-MM-YYYY |
| 37 | TAX_REGIME_CODE | ✔ | `VAT_REGIME_UAE` |
| 38 | TAX_REG_NUM_FLAG | cond. | `Y`/`N` — `N` when no TRN |
| 39 | TAX_REG_NUM_REASON | cond. | `NO TRADE LICENSE` (required when flag = N) |
| 40 | PAYMENT_TERMS | — | `IMMEDIATE` |
| 41 | COLLECTOR_NAME | ✔ | `Default Collector` |
| 42 | GENERATE_BILL_FLAG | — | `Y`/`N` |
| 43 | SEND_STATEMENT | — | `Y`/`N` |
| 44 | STATEMENT_CYCLE | — | `Monthly` |
| 45 | STATEMENT_PREF_DELIVERY_METHOD | — | `EMAIL` |
| 46 | SEND_CREDIT_BALANCE | — | `Y`/`N` |
| 47 | SEND_DUNNING_LETTERS | — | `Y`/`N` |
| 48 | ACCT_ESTD_DATE | — | DD-MM-YYYY |
| 49–59 | BANK_ACCT_NAME, ACCT_PRIMARY_IND, BANK_FROM_DATE, BANK_ACCT_NUMBER, BANK_ACCT_CURRENCY, BANK_NAME, BRANCH_NAME, BANK_HOME_COUNTRY_CODE, BANK_ACCT_COUNTRY_CODE, PRIMARY_OWNER, IBAN | — | bank section (all optional) |
| 60–65 | PARENT_CUST_ACCT_NO, CHILD_CUST_ACCT_NO, ACC_REL_ADDR_SET, RECIPROCAL_RELATIONSHIP, REL_START_DATE, CONTEXT_VALUE | — | account-relationship section |
| 66 | SOURCE_SYSTEM | ✔ | fixed `DCT_SYSTEM` |
| 67 | ORG_CODE | ✔ | fixed `DCT` |
| 68 | ATTRIBUTE10 | — | `Y` in all prod samples (flex attribute) |

## 5. Settings (DCT_SYSTEM_SETTINGS / module AR)

| Key | Type | Purpose |
|---|---|---|
| `AR_WS_ENV` | TEXT | `STAGE` / `PROD` — selects endpoint+key+password triplet |
| `AR_WS_URL_STAGE` / `AR_WS_URL_PROD` | TEXT | endpoints above |
| `AR_WS_APIKEY_STAGE` / `AR_WS_APIKEY_PROD` | SECRET | x-CentraSite-APIKey |
| `AR_WS_USER` | TEXT | `ADGE_DCT_INTG_SVC` |
| `AR_WS_PASSWORD_STAGE` / `AR_WS_PASSWORD_PROD` | SECRET | Basic auth |
| `AR_WS_LIVE` | Y/N | `N` = mock mode (no outbound call; simulated response) |

## 6. Open items

- [ ] Confirm current STAGE Basic-auth password (gateway passes, backend 401s).
- [ ] PROD IP whitelisting: ADB outbound `129.151.135.88` (+ web tier `129.151.159.189` as
      stable relay fallback, dev `94.59.158.153`) for consumer `ADGE_DCT_INTG_SVC`.
- [ ] Confirm PROD API key (`030140d2-…` per SoapUI — the `1d9b23f1-…` key is STAGE's).
