# Servlet/JSP SRS Agent + Real Screenshot Capture

This package is designed to be copied into the root of a legacy Java Servlet/JSP repository.

It helps an AI coding agent:
1. reverse-engineer screens/functions from source code;
2. create a screen inventory;
3. launch Playwright against the running application;
4. capture real UI screenshots;
5. generate Section II — Functional Requirements.

## Included files

- `AGENTS.md`
- `.ai-srs/prompts/generate-functional-requirements.md`
- `.ai-srs/schemas/screen-inventory.schema.json`
- `.ai-srs/playwright/config.json`
- `.ai-srs/playwright/capture-screens.js`
- `package.json`
- `docs/srs/screen-inventory.json`
- `docs/srs/images/`

## 1. Ask the AI agent to scan the repo

Use:

```text
Read AGENTS.md.

Analyze the entire Servlet/JSP repository.
Build docs/srs/screen-inventory.json first.

For each user-facing screen, identify:
- route
- servlet
- JSP
- fields
- actions
- validation
- permission/session conditions
- DAO/service trace
- screenshotFile

Do not invent requirements.
```

## 2. Install Playwright

```bash
npm install
npx playwright install chromium
```

## 3. Run your Java web application

Example:

```text
http://localhost:8080/myapp
```

The package does not assume Tomcat, Jetty, GlassFish, etc.
Run the app using the project's normal method.

## 4. Configure runtime values

Linux/macOS:

```bash
export SRS_BASE_URL="http://localhost:8080/myapp"
export SRS_USERNAME="admin"
export SRS_PASSWORD="your-password"
export SRS_LOGIN_PATH="/login"
```

Windows PowerShell:

```powershell
$env:SRS_BASE_URL="http://localhost:8080/myapp"
$env:SRS_USERNAME="admin"
$env:SRS_PASSWORD="your-password"
$env:SRS_LOGIN_PATH="/login"
```

Credentials are optional for public applications.

Do not commit real credentials.

## 5. Capture screenshots

```bash
npm run srs:screenshots
```

Outputs:

```text
docs/srs/images/*.png
docs/srs/screenshot-report.json
```

## 6. Generate the SRS

Ask the agent:

```text
Read AGENTS.md and
.ai-srs/prompts/generate-functional-requirements.md.

Use:
- docs/srs/screen-inventory.json
- docs/srs/images/
- repository source code

Generate:
docs/srs/02-functional-requirements.md
docs/srs/traceability.md

The UI Layout for each screen must use the real captured screenshot.
```

## Notes

### Login page differs

Edit:

`.ai-srs/playwright/config.json`

to add the actual username/password/submit selectors.

### Screens require parameters

For pages such as:

```text
/customer/edit?id=123
```

put the fully usable route into the inventory:

```json
{
  "name": "Edit Customer",
  "route": "/customer/edit?id=123",
  "screenshotFile": "customer-edit.png"
}
```

The AI agent should select safe existing test/sample records where possible.

### Destructive actions

Do not automatically execute destructive actions merely to capture a screenshot.

For delete/approve/reject flows, capture the screen before the destructive confirmation unless a disposable test environment is explicitly available.
