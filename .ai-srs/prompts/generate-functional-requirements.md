# Generate Section II — Functional Requirements

Generate `docs/srs/02-functional-requirements.md` from:
- repository source code
- `docs/srs/screen-inventory.json`
- captured screenshots in `docs/srs/images/`

Use this exact high-level structure:

# II. Functional Requirements

## 1. {Feature Name}

### 1.1 {SubFeature Name}

#### 1.1.1 {Screen/Function Name}

##### UI Layout

Embed the real screenshot:

```markdown
![{Screen Name}](./images/{screen-file}.png)
```

Do not create an ASCII mockup if a real screenshot exists.

If unavailable:

> Screenshot unavailable — the screen could not be rendered in the available environment.

##### Description

Briefly describe:
- purpose
- actor/role
- entry point
- main actions
- expected result
- mapped use case(s)
- permission restrictions

##### Field / Component Specification

Use:

| **Field Name** | **Description** |
|---|---|
| Field | Control type; data type; required/optional; min/max; default; allowed values; validation; read-only/editable; visibility; action/API if relevant. |
| ***Group Name*** | |
| Field | ... |

Include:
- inputs
- selects
- textareas
- buttons
- links
- table columns
- filters
- hidden functionally relevant fields
- pagination
- modal/dialog controls

##### Behavioral Rules

Document only behavior supported by source:
- validation
- enable/disable
- conditional visibility
- confirmation
- submit behavior
- redirect/forward
- sorting/filtering
- pagination
- errors
- state/status transitions
- session/role restrictions

##### Code Traceability

| Layer | Source |
|---|---|
| Route | `/...` |
| Servlet | `src/...` |
| JSP | `WebContent/...` |
| Service | `...` |
| DAO | `...` |
| Model | `...` |
| Validation | `...` |
| Permission | `...` |

## Screenshot naming

Use lowercase kebab-case:
- `login.png`
- `customer-list.png`
- `customer-create.png`
- `customer-edit.png`

Prefer one screenshot per logical screen state.

If a dialog/modal contains important functionality, capture an additional image:
- `customer-delete-confirmation.png`

## Conflict rules

If source and rendered UI differ, document the conflict.

Example:

> Conflict detected: the JSP permits 100 characters, while server-side validation permits 50. The effective accepted maximum is 50 characters.

## No hallucination

When unknown, write:

`Not determinable from source code.`

Do not invent:
- business rationale
- permissions
- validations
- fields
- workflows
