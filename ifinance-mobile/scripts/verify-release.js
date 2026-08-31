/* eslint-env node */
const fs = require('fs');

const required = ['GOOGLE_SERVICES_JSON', 'EXPO_PUBLIC_SENTRY_DSN', 'SENTRY_AUTH_TOKEN', 'SENTRY_ORG', 'SENTRY_PROJECT'];
const missing = required.filter((name) => !process.env[name]);

if (process.env.GOOGLE_SERVICES_JSON && !fs.existsSync(process.env.GOOGLE_SERVICES_JSON)) {
  throw new Error('GOOGLE_SERVICES_JSON must point to the EAS-provided Firebase JSON file.');
}
if (missing.length) {
  throw new Error(`Missing production EAS variables: ${missing.join(', ')}`);
}

console.log('Production credential contract is complete.');
