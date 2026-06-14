// Playwright E2E for the Task Management JET SPA (App 207).
// Prereq: run the dev-proxy (python "final apps/TM/Jet/dev-proxy.py") so the app
// is served at http://localhost:8080 with /ords proxied to ADB and /shared mapped.
//   npx playwright test "final apps/TM/tests/e2e"
// Auth uses the login page's quick-login buttons (no credentials in this file).
const { test, expect } = require('@playwright/test');
const BASE = process.env.TM_E2E_BASE || 'http://localhost:8080/TM/Jet/index.html';

async function login(page) {
  await page.goto(BASE);
  // Admin JET is the identity provider; module apps redirect there when no session.
  // The login view exposes quick-login buttons; click the System Admin one.
  await page.waitForSelector('text=/System Admin|Login|Sign in/i', { timeout: 15000 });
  const quick = page.locator('button:has-text("System Admin")').first();
  if (await quick.count()) { await quick.click(); }
  await page.waitForLoadState('networkidle');
}

test('TM app boots and switcher shows App 207', async ({ page }) => {
  const errors = [];
  page.on('console', m => { if (m.type() === 'error') errors.push(m.text()); });
  await login(page);
  await page.goto(BASE + '#dashboard');
  await expect(page.locator('.brand-cube')).toHaveText('TM');
  await expect(page.locator('.side-logo .sb')).toContainText('APP 207');
  // no uncaught KO/JS errors during boot
  expect(errors.filter(e => /knockout|undefined is not|t is not/i.test(e))).toEqual([]);
});

test('create team → open detail → add task → drag to DONE', async ({ page }) => {
  await login(page);
  await page.goto(BASE + '#teams');
  await page.click('text=/New Team|فريق جديد/');
  await page.fill('input.input >> nth=0', 'E2E Strategic Team');
  await page.click('button:has-text("Create"), button:has-text("إنشاء")');
  await expect(page.locator('.toast--success, .team-card')).toBeVisible({ timeout: 10000 });

  await page.click('.team-card:has-text("E2E Strategic Team")');
  await page.click('.tm-tab:has-text("Tasks"), .tm-tab:has-text("المهام")');
  await page.click('text=/Add Task|إضافة مهمة/');
  await page.fill('.card input.input', 'Kickoff');
  await page.click('.card button:has-text("Save"), .card button:has-text("حفظ")');
  await expect(page.locator('.kanban-card:has-text("Kickoff")')).toBeVisible({ timeout: 10000 });

  // drag Kickoff → DONE. Playwright's dragTo does NOT fire native HTML5 DnD
  // events, so dispatch real DragEvents with a shared DataTransfer instead.
  await page.evaluate(() => {
    const card = [...document.querySelectorAll('.kanban-card')].find(c => c.textContent.includes('Kickoff'));
    const done = [...document.querySelectorAll('.kanban-col')].find(c =>
      c.querySelector('.kanban-col__hd') && c.querySelector('.kanban-col__hd').textContent.includes('DONE'));
    const dt = new DataTransfer();
    card.dispatchEvent(new DragEvent('dragstart', { dataTransfer: dt, bubbles: true }));
    done.dispatchEvent(new DragEvent('dragover', { dataTransfer: dt, bubbles: true, cancelable: true }));
    done.dispatchEvent(new DragEvent('drop', { dataTransfer: dt, bubbles: true, cancelable: true }));
  });
  await expect(page.locator('.kanban-col:has-text("DONE") .kanban-card:has-text("Kickoff")')).toBeVisible();
});

test('my tasks + preferences reachable', async ({ page }) => {
  await login(page);
  await page.goto(BASE + '#myWork');
  await expect(page.locator('.page-title')).toContainText(/My Tasks|مهامي/);
  await page.goto(BASE + '#preferences');
  await expect(page.locator('.page-title')).toContainText(/Reminder|تفضيلات/);
});
