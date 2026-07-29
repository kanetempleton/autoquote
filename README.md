# AutoQuote – Test Automation Framework

Insurance quote simulator built to practice professional test automation practices with Ruby.

Minimal Sinatra app + RSpec API tests + Cucumber/Capybara/Playwright UI tests using the Page Object Model.

---

## Running the app locally

```bash
bundle install
ruby app/app.rb
```

App will be available at: http://localhost:43595

---

## Running the tests locally

```bash
# API tests (RSpec)
bundle exec rspec -f d

# UI / acceptance tests (Cucumber)
bundle exec cucumber

# Or both
bundle exec rspec && bundle exec cucumber
```

---

## Running with Docker

### Build and start the app

```bash
docker compose up --build
```

Or run detached (in the background):

```bash
docker compose up -d --build
```

App will be available at: http://localhost:43595

### Stop the containers

```bash
docker compose down
```

### Useful Docker commands

```bash
docker compose ps          # see running services
docker compose logs -f     # follow logs
docker compose down        # stop and remove containers
```

### Running UI tests against the containerized app

```bash
# Terminal 1 – start the app
docker compose up -d

# Terminal 2 – point Cucumber at the container
APP_URL=http://localhost:43595 bundle exec cucumber

# When finished
docker compose down
```

---

## Project structure

```
app/                  # Sinatra application
features/             # Cucumber feature files + step definitions
page_objects/         # Page Object Model classes
spec/                 # RSpec API tests
config/               # Cucumber config
k8s/                  # Kubernetes manifests (later)
Dockerfile            # Builds the application image
docker-compose.yml    # Easy way to run the app in Docker
```

---

## Test framework overview

- **RSpec** – API / request specs for `POST /quotes` and `GET /quotes/:id`
- **Cucumber** – BDD-style acceptance tests in Gherkin
- **Capybara + Playwright** – browser automation for UI tests
- **Page Object Model** – keeps UI selectors and actions in dedicated classes
```
