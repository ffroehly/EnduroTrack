# agent.md — AI Agent Instructions for EnduroTrack

This file provides context, conventions, and commands for AI agents (GitHub Copilot, etc.)
working on the EnduroTrack project.

---

## Project Purpose

EnduroTrack is an iOS fitness app for scheduling, tracking, and improving workout sessions.
It is designed as a **teaching project** for Clean Architecture, SOLID principles, and VIPER.

---

## Architecture Overview

See `ARCHITECTURE.md` for the full guide. In brief:

- **Domain** (Swift Package) — Entities, Enums, Use Case Protocols, Repository Protocols. Zero framework dependencies.
- **DesignSystem** (Swift Package) — SwiftUI-only. Colors, typography, reusable components.
- **Data** (app folder) — Concrete repositories and services. Implements Domain protocols.
- **Features** (app folder) — VIPER modules: Home, Workout, Running, Timer.
- **SharedModels** (app folder) — App-level shared enums and value objects.
- `EnduroTrackApp.swift` — Entry point + Composition Root (root of the Xcode target).
- `ContentView.swift` — Root TabView (root of the Xcode target).

---

## Adding a New Feature

When asked to add a new feature (e.g. "Nutrition"), follow this checklist:

1. **Domain** — Add entity file(s) in `Domain/Sources/Domain/Entities/`.
2. **Domain** — Add use case protocol file(s) in `Domain/Sources/Domain/UseCases/`.
3. **Domain** — Add repository protocol in `Domain/Sources/Domain/RepositoryProtocols/`.
4. **Data** — Add concrete repository in `EnduroTrack/Data/Repositories/`.
5. **Data** — Add service (use case implementation) in `EnduroTrack/Data/Services/`.
6. **Feature** — Create folder `EnduroTrack/Features/<FeatureName>/` with subfolders:
   - `View/` — SwiftUI view (`<Feature>View.swift`)
   - `Presenter/` — ObservableObject presenter (`<Feature>Presenter.swift`)
   - `Interactor/` — Interactor (`<Feature>Interactor.swift`)
   - `Router/` — Router (`<Feature>Router.swift`)
   - `<Feature>Contracts.swift` — All protocols for the module
   - `<Feature>Builder.swift` — Factory to assemble the module
7. **SharedModels** — Add any cross-feature shared types if needed.
8. **ContentView.swift** — Add new tab or navigation entry point.
9. **ARCHITECTURE.md** — Update the Feature List section.
10. **Tests** — Add unit tests for Interactor and Presenter.

---

## VIPER File Template

When creating a new VIPER module, use this structure:

```swift
// <Feature>Contracts.swift — All protocols

protocol <Feature>ViewProtocol: AnyObject { }
protocol <Feature>PresenterProtocol: AnyObject { }
protocol <Feature>InteractorProtocol: AnyObject { }
protocol <Feature>RouterProtocol: AnyObject { }

enum <Feature>ViewState: Equatable { }
```

```swift
// <Feature>Presenter.swift
@MainActor
final class <Feature>Presenter: ObservableObject, <Feature>PresenterProtocol {
    @Published private(set) var state: <Feature>ViewState = ...
    private let interactor: <Feature>InteractorProtocol
    private let router: <Feature>RouterProtocol
}
```

```swift
// <Feature>View.swift — SwiftUI View
struct <Feature>View: View {
    @StateObject private var presenter: <Feature>Presenter
}
```

---

## Key Conventions

| Convention | Rule |
|---|---|
| Async/await | Use `async throws` for all data operations. No Combine, no RxSwift. |
| State management | Presenter is `ObservableObject`. View uses `@StateObject`. |
| Navigation | Router owns `NavigationPath` / sheet state. |
| Dependency injection | Always inject protocols, never concrete types (except in Builders). |
| No business logic in View | Views only render state and forward user events. |
| No UI in Presenter | Presenter only imports `Foundation` and `Domain`. |
| No Domain logic in Data | Data layer only persists/fetches; business rules live in Domain. |

---

## Running Tests

```bash
# Domain package tests (pure Swift, no simulator needed)
swift test --package-path Domain

# DesignSystem package tests
swift test --package-path DesignSystem

# App tests (requires Xcode / xcodebuild)
xcodebuild test -scheme EnduroTrack -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## File Naming

| Layer | File name pattern |
|---|---|
| Entity | `<EntityName>.swift` |
| Use Case Protocol | `<Action><Entity>UseCaseProtocol.swift` (or grouped in `<Entity>UseCaseProtocols.swift`) |
| Repository Protocol | `<Entity>RepositoryProtocol.swift` |
| Repository Implementation | `<Entity>Repository.swift` |
| Service | `<Feature>Service.swift` |
| VIPER Contracts | `<Feature>Contracts.swift` |
| VIPER View | `<Feature>View.swift` |
| VIPER Presenter | `<Feature>Presenter.swift` |
| VIPER Interactor | `<Feature>Interactor.swift` |
| VIPER Router | `<Feature>Router.swift` |
| VIPER Builder | `<Feature>Builder.swift` |

---

## When Updating This File

Update `agent.md` whenever:
- A new feature is added
- A new convention is established
- The dependency graph changes
- New agent commands or shortcuts are needed
