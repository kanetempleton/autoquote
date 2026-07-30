# Product Backlog – AutoQuote

## Iteration 1 – Foundation (Done)

### US-01
* As a user, I want to submit my age, vehicle year, and ZIP code so that I can receive an insurance quote.

**Acceptance Criteria**
- [x] POST `/quotes` accepts JSON with `age`, `vehicle_year`, and `zip`
- [x] Response includes a unique `quote_id` and a calculated `premium`
- [x] Missing or invalid fields return an appropriate error status
- [x] Quote is stored and can be retrieved by ID

**Status:** Done

---

### US-02
* As a user, I want to see a clear quote result (premium + quote ID) after submitting the form.

**Acceptance Criteria**
- [x] Form at `/` collects age, vehicle year, and ZIP
- [x] Submitting the form displays the quote ID and premium
- [x] Result is visible in the browser without needing an API client

**Status:** Done

---

### US-03
* As a QA engineer, I want reliable API tests for creating and retrieving quotes so that the backend is verified independently.

**Acceptance Criteria**
- [x] Happy-path tests for create and retrieve
- [x] Validation / error-path tests (missing fields, not found, etc.)
- [x] Each test creates its own data (independent)
- [x] Tests pass consistently in CI

**Status:** Done

---

### US-04
* As a QA engineer, I want end-to-end UI tests using Page Objects so that the form flow is covered and maintainable.

**Acceptance Criteria**
- [x] Happy-path scenario: fill form --> see quote
- [x] At least one negative / validation scenario
- [x] Page Object Model is used
- [x] No hard-coded sleeps; proper waits only
- [x] Tests are independent and pass in CI

**Status:** Done

---

### US-05
* As a team, we want the full test suite to run automatically on every pull request so that broken code cannot be merged.

**Acceptance Criteria**
- [x] GitHub Actions workflow runs on pull requests and pushes to `main`
- [x] Workflow runs the full RSpec + Cucumber suite
- [x] Failed tests fail the PR check
- [x] Branch protection requires the status check

**Status:** Done

---

## Iteration 2 – Discount Codes (Planned)

### US-06
* As a user, I want to optionally supply a discount code when requesting a quote so that I can receive a reduced premium when I have a valid code.

**Acceptance Criteria**
- [ ] `discount_code` is an optional field on POST `/quotes`
- [ ] Valid code `SAVE10` reduces the calculated premium by 10%
- [ ] Invalid or unknown codes are ignored (full price is charged) — no error
- [ ] Response makes it clear whether a discount was applied
- [ ] The HTML form has an optional “Discount code” field
- [ ] Existing behaviour and tests remain green (backward compatible)

**Status:** To Do

---

### US-07
* As a QA engineer, I want automated API and UI tests for the discount code feature so that the new behaviour is protected from regressions.

**Acceptance Criteria**
- [ ] RSpec examples cover valid code, invalid code, and missing code
- [ ] Cucumber scenario exercises the discount field on the form and asserts the reduced premium
- [ ] Tests remain independent and use proper waits
- [ ] CI stays green

**Status:** To Do
