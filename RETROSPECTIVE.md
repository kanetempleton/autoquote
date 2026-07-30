# Retrospective – AutoQuote (Iteration 1)

**Date:** July 29, 2026  
**Participants:** Kane Templeton

## What went well

- GitHub Copilot made creating the initial application to use for testing very painless
- GitHub Flow + protected main kept the history clean and made every change reviewable and ensured main branch always has an acceptable product
- RSpec and Cucumber tests were easy to write once the app was built clearly due to its simplicity
- Page Object Model and Playwright made the UI tests readable and relatively stable
- Docker and Kubernetes manifests were straightforward once port mapping for kind on macOS was understood


## What was difficult

- Kind + Docker Desktop networking (NodePort not reachable on localhost without extraPortMappings) ate up some time
- Keeping the main app minimal while still having enough functionality for meaningful tests
- Solo “code review” and self-approving PRs doesn't realisitically capture the purpose of these things, but I had to do something to simulate a team environment
- Playwright browser install and Ruby driver config gave me a few hiccups but was resolved fairly easily
- Markdown formatting for a professional-looking README took some time, but was necessary for a polished project

## What could be improved

- Write a short Definition of Done for each iteration
- Add a way to track and isolate flaky tests
- Make acceptance criteria more explicit (Given/When/Then or checklist) before starting implementation (the BACKLOG at the beginning of the project did not have this)
- Track metrics (such as pipeline duration, number of quarantined tests) from the beginning of an iteration

## Action items for Iteration 2

- [ ] Keep the new feature simple
- [ ] Write RSpec and Cucumber tests for the new feature
- [ ] Update the backlog status as soon as each story is finished
- [ ] Update retrospective once iteration 2 is complete
