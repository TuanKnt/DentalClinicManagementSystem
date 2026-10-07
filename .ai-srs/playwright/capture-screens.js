const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const repoRoot = process.cwd();
const configPath = path.join(repoRoot, '.ai-srs', 'playwright', 'config.json');
const inventoryPath = path.join(repoRoot, 'docs', 'srs', 'screen-inventory.json');
const outDir = path.join(repoRoot, 'docs', 'srs', 'images');

const cfg = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const inventory = JSON.parse(fs.readFileSync(inventoryPath, 'utf8'));

const baseUrl = process.env[cfg.baseUrlEnv];
const username = process.env[cfg.usernameEnv];
const password = process.env[cfg.passwordEnv];
const loginPath = process.env[cfg.loginPathEnv] || cfg.defaults.loginPath;

if (!baseUrl) {
  console.error(`Missing ${cfg.baseUrlEnv}. Example: http://localhost:8080/myapp`);
  process.exit(1);
}

fs.mkdirSync(outDir, { recursive: true });

function slugify(s) {
  return String(s || 'screen')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

async function firstVisible(page, selectors) {
  for (const selector of selectors || []) {
    const loc = page.locator(selector).first();
    try {
      if (await loc.count() && await loc.isVisible()) return loc;
    } catch (_) {}
  }
  return null;
}

async function tryLogin(page) {
  if (!username || !password) return false;

  const loginUrl = new URL(loginPath, baseUrl).toString();
  await page.goto(loginUrl, { waitUntil: 'domcontentloaded' });

  const user = await firstVisible(page, cfg.defaults.usernameSelectors);
  const pass = await firstVisible(page, cfg.defaults.passwordSelectors);
  const submit = await firstVisible(page, cfg.defaults.submitSelectors);

  if (!user || !pass || !submit) {
    console.warn('Login form selectors not found. Update .ai-srs/playwright/config.json.');
    return false;
  }

  await user.fill(username);
  await pass.fill(password);
  await Promise.all([
    page.waitForLoadState('domcontentloaded').catch(() => {}),
    submit.click()
  ]);

  await page.waitForTimeout(cfg.screenshot.waitAfterNavigationMs || 800);
  return true;
}

function collectScreens(inv) {
  const result = [];
  for (const feature of inv.features || []) {
    for (const sub of feature.subfeatures || []) {
      for (const screen of sub.screens || []) {
        if (!screen.route) continue;
        if (screen.screenshot === false) continue;
        result.push({
          feature: feature.name,
          subfeature: sub.name,
          ...screen
        });
      }
    }
  }
  return result;
}

(async () => {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 1440, height: 1000 }
  });
  const page = await context.newPage();

  if (username && password) {
    try {
      await tryLogin(page);
    } catch (e) {
      console.warn('Login attempt failed:', e.message);
    }
  }

  const screens = collectScreens(inventory);
  const report = [];

  for (const screen of screens) {
    const route = screen.route.startsWith('http')
      ? screen.route
      : new URL(screen.route.replace(/^\//, ''), baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();

    const filename = screen.screenshotFile || `${slugify(screen.name)}.png`;
    const output = path.join(outDir, filename);

    try {
      await page.goto(route, { waitUntil: 'domcontentloaded', timeout: 30000 });
      await page.waitForTimeout(cfg.screenshot.waitAfterNavigationMs || 800);

      for (const selector of cfg.screenshot.hideSelectors || []) {
        try {
          await page.locator(selector).evaluateAll(nodes => nodes.forEach(n => n.style.visibility = 'hidden'));
        } catch (_) {}
      }

      await page.screenshot({
        path: output,
        fullPage: cfg.screenshot.fullPage !== false
      });

      console.log(`Captured ${screen.name}: ${output}`);
      report.push({ name: screen.name, route, file: filename, status: 'captured' });
    } catch (e) {
      console.warn(`Failed ${screen.name}: ${e.message}`);
      report.push({ name: screen.name, route, file: filename, status: 'failed', error: e.message });
    }
  }

  fs.writeFileSync(
    path.join(repoRoot, 'docs', 'srs', 'screenshot-report.json'),
    JSON.stringify(report, null, 2)
  );

  await browser.close();
})();
