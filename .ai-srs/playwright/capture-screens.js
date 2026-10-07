const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const repoRoot = process.cwd();
const configPath = path.join(repoRoot, '.ai-srs', 'playwright', 'config.json');
const inventoryPath = path.join(repoRoot, 'docs', 'srs', 'screen-inventory.json');
const outDir = path.join(repoRoot, 'docs', 'srs', 'images');

const cfg = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const inventory = JSON.parse(fs.readFileSync(inventoryPath, 'utf8'));

const baseUrl = process.env[cfg.baseUrlEnv] || 'http://localhost:8080/dcms';
const loginPath = process.env[cfg.loginPathEnv] || cfg.defaults.loginPath;

fs.mkdirSync(outDir, { recursive: true });

function slugify(s) {
  return String(s || 'screen')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

async function loginAs(page, username, password) {
  const logoutUrl = new URL('logout', baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();
  await page.goto(logoutUrl, { waitUntil: 'domcontentloaded' }).catch(() => {});

  const loginUrl = new URL(loginPath.replace(/^\//, ''), baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();
  await page.goto(loginUrl, { waitUntil: 'domcontentloaded' });

  const user = page.locator("input[name='username']").first();
  const pass = page.locator("input[name='password']").first();
  const submit = page.locator("button[type='submit']").first();

  await user.fill(username);
  await pass.fill(password);
  await Promise.all([
    page.waitForLoadState('domcontentloaded').catch(() => {}),
    submit.click()
  ]);

  await page.waitForTimeout(cfg.screenshot.waitAfterNavigationMs || 800);
}

async function logout(page) {
  const logoutUrl = new URL('logout', baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();
  await page.goto(logoutUrl, { waitUntil: 'domcontentloaded' }).catch(() => {});
  await page.context().clearCookies();
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
    viewport: { width: 1440, height: 950 }
  });
  const page = await context.newPage();

  const screens = collectScreens(inventory);
  const report = [];

  let currentRole = null;

  for (const screen of screens) {
    const filename = screen.screenshotFile || `${slugify(screen.name)}.png`;
    const output = path.join(outDir, filename);

    console.log(`Processing ${screen.name} -> ${filename}...`);

    try {
      // Determine required role
      if (filename === 'login.png' || filename === 'public-homepage.png' || filename === 'guest-booking.png') {
        if (currentRole !== 'anonymous') {
          await logout(page);
          currentRole = 'anonymous';
        }
      } else if (filename === 'admin-dashboard.png') {
        if (currentRole !== 'admin') {
          await loginAs(page, 'admin', '123456');
          currentRole = 'admin';
        }
      } else if (filename === 'access-denied.png') {
        // Log in as receptionist and try accessing admin dashboard to trigger 403 Access Denied
        await loginAs(page, 'letan01', '123456');
        currentRole = 'access-denied';
      } else if (filename.startsWith('dentist-') || filename === 'clinical-examination.png') {
        if (currentRole !== 'dentist') {
          await loginAs(page, 'bacsi_hung', '123456');
          currentRole = 'dentist';
        }
      } else {
        // Receptionist role for patient and appointment screens
        if (currentRole !== 'receptionist') {
          await loginAs(page, 'letan01', '123456');
          currentRole = 'receptionist';
        }
      }

      let targetUrl;
      if (filename === 'access-denied.png') {
        targetUrl = new URL('admin/dashboard', baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();
      } else if (screen.route.startsWith('http')) {
        targetUrl = screen.route;
      } else {
        const cleanRoute = screen.route.replace(/^\//, '');
        targetUrl = new URL(cleanRoute, baseUrl.endsWith('/') ? baseUrl : baseUrl + '/').toString();
      }

      await page.goto(targetUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });
      await page.waitForTimeout(cfg.screenshot.waitAfterNavigationMs || 800);

      if (filename === 'guest-booking.png') {
        // Switch to booking tab or scroll to booking form
        try {
          const bookingTabBtn = page.locator("button.tab-btn:has-text('Đặt lịch'), button[data-tab='booking'], a[href='#booking']").first();
          if (await bookingTabBtn.count() && await bookingTabBtn.isVisible()) {
            await bookingTabBtn.click();
            await page.waitForTimeout(600);
          }
        } catch (_) {}
      }

      for (const selector of cfg.screenshot.hideSelectors || []) {
        try {
          await page.locator(selector).evaluateAll(nodes => nodes.forEach(n => n.style.visibility = 'hidden'));
        } catch (_) {}
      }

      await page.screenshot({
        path: output,
        fullPage: cfg.screenshot.fullPage !== false
      });

      console.log(`  [SUCCESS] Saved: ${output}`);
      report.push({ name: screen.name, route: screen.route, file: filename, status: 'captured' });
    } catch (e) {
      console.warn(`  [FAIL] ${screen.name}: ${e.message}`);
      report.push({ name: screen.name, route: screen.route, file: filename, status: 'failed', error: e.message });
    }
  }

  fs.writeFileSync(
    path.join(repoRoot, 'docs', 'srs', 'screenshot-report.json'),
    JSON.stringify(report, null, 2)
  );

  await browser.close();
  console.log(`\nScreenshot capture finished. Summary saved to docs/srs/screenshot-report.json`);
})();
