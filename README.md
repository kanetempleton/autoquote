# AutoQuote – Test Automation Framework

A minimal insurance quote service built with Sinatra, paired with a professional test automation framework (RSpec + Cucumber + Capybara + Playwright, Page Objects, Docker, GitHub Actions, and basic Kubernetes).

This project demonstrates the skills expected for a Test Automation Developer role: framework design, API + UI testing, CI, containerization, and basic orchestration.

## Project Structure

```
autoquote/
├── app/                  # Sinatra application
├── features/             # Cucumber (BDD) UI / acceptance tests
│   └── support/          # env.rb, hooks.rb
├── spec/                 # RSpec API tests
├── page_objects/         # Page Object Model
├── config/               # Cucumber profiles, etc.
├── k8s/                  # Kubernetes manifests
│   ├── deployment.yaml
│   └── service.yaml
├── .github/workflows/    # CI pipeline
├── BACKLOG.md            # Product backlog & user stories
├── ITERATIONS.md         # Sprint / iteration tracking
├── RETROSPECTIVE.md      # Iteration retrospective notes
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Prerequisites

- Ruby 3.1+
- Bundler
- Node.js + npm (for Playwright browsers)
- Docker
- kind for the Kubernetes section

```bash
bundle install
npm install
npx playwright install chromium
```

## Running the Application Locally

```bash
ruby app/app.rb
# or
./run.sh
```

App is available at http://localhost:43595

## Running the Tests

```bash
# RSpec (API tests)
bundle exec rspec -f d

# Cucumber (UI / acceptance tests)
bundle exec cucumber

# Both
./run_tests.sh
```

## Docker

```bash
docker build -t autoquote:latest .
docker run -p 43595:43595 autoquote:latest
```

Or with Compose:

```bash
docker compose up --build
```

## Continuous Integration (GitHub Actions)

Every push to `main` and every pull request triggers the CI workflow in `.github/workflows/`.

The pipeline:
- Sets up Ruby and installs dependencies
- Starts the application
- Runs the full RSpec + Cucumber suite
- Fails the PR if any tests fail
- Uploads test reports / artifacts on failure

View the latest runs here:  
https://github.com/kanetempleton/autoquote/actions

## Kubernetes (kind)

Basic Deployment + Service manifests live in `k8s/`.

### 1. Create a kind cluster with NodePort mapping (required on macOS / Docker Desktop)

```bash
cat <<EOF | kind create cluster --name autoquote --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 30080
    protocol: TCP
EOF
```

### 2. Build and load the image into kind

```bash
docker build -t autoquote:latest .
kind load docker-image autoquote:latest --name autoquote
```

### 3. Apply the manifests

```bash
kubectl apply -f k8s/
```

### 4. Verify

```bash
kubectl get pods
kubectl get svc
curl http://localhost:30080/
```

### 5. Clean up

```bash
kind delete cluster --name autoquote
```

**Notes**
- The app listens on port `43595` inside the container.
- The Service uses `NodePort 30080` → `targetPort 43595`.
- On macOS with Docker Desktop, the `extraPortMappings` in the kind config are required for NodePort to be reachable on localhost.

## Framework Design Highlights

- **RSpec** for fast independent API tests
- **Cucumber + Gherkin** for readable acceptance / UI tests
- **Capybara + Playwright** for modern browser automation
- **Page Object Model** for maintainable UI interactions with Cucumber
- Tests are independent and use proper waits (no hard sleeps)
- GitHub Flow with protected `main` and pull requests
- CI via GitHub Actions
- **Docker** for containerized application
- **Kubernetes** for basic deployment + service

## Test Framework Structure

- `spec/` – RSpec API tests (fast, focused, independent)
- `features/` – Cucumber feature files written in Gherkin
- `features/support/` – environment setup (`env.rb`) and hooks
- `page_objects/` – Page Object classes that encapsulate UI interactions
- `config/cucumber.yml` – Cucumber profiles (default, ci, etc.)

API tests done via RSpec.
UI/end-to-end flows done via Cucumber and go through Page Objects.

## Agile Process

This project was run as a lightweight Agile exercise to simulate how a real team might work.

- **Product backlog** – User stories with acceptance criteria in [`BACKLOG.md`](BACKLOG.md)
- **Iterations** – Work was delivered in short iterations. See [`ITERATIONS.md`](ITERATIONS.md) for goals, completed stories, and the Definition of Done for each iteration
- **GitHub Flow** – All changes happened on short-lived feature branches and were merged to `main` via Pull Requests. `main` is protected and requires status checks.
- **Continuous Integration** – Every PR runs the full test suite automatically.
- **Retrospective** – Notes on what went well, what was difficult, and improvements for the next iteration are in [`RETROSPECTIVE.md`](RETROSPECTIVE.md).

**Iteration 1** delivered the core quote service, the test framework, Docker, CI, and basic Kubernetes.  
**Iteration 2** (planned / in progress) adds an optional discount-code feature and the tests that protect it.

