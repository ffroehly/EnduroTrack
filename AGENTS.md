# AI Agent Instructions — EnduroTrack

This file configures AI coding assistants (GitHub Copilot, Claude, etc.) working in this repository.

---

## Project at a Glance

**EnduroTrack** is a SwiftUI iOS app (iOS 17+, Swift 6, Xcode 16+).  
State management: [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture).  
Architecture: Clean Architecture (Domain → Use Cases → Reducers → Views).

---

## Architecture Rules

### Layer Dependency Direction

Outer layers depend on inner layers — **never the reverse**.

```
Views → Reducers → Use Cases → Domain Entities
```

| ✅ Allowed | ❌ Forbidden |
|---|---|
| Reducer imports Domain | Domain imports ComposableArchitecture |
| View imports DesignSystem | DesignSystem imports Domain |
| Repository imports Domain | Domain imports SwiftUI |

### File Naming Conventions

| File type | Convention | Example |
|---|---|---|
| TCA Reducer | `<Feature>Reducer.swift` | `WorkoutReducer.swift` |
| SwiftUI View | `<Feature>View.swift` | `WorkoutView.swift` |
| Domain Entity | singular noun | `Workout.swift` |
| Repository | `<Entity>Repository.swift` | `WorkoutRepository.swift` |

### Package Structure

| Package | Location | Contents |
|---|---|---|
| `Domain` | `EnduroTrack/Domain/` | Entities, value objects, use-case protocols — **zero dependencies** |
| `DesignSystem` | `EnduroTrack/DesignSystem/` | Reusable SwiftUI components, colours, typography — SwiftUI only |
| Main app target | `EnduroTrack/EnduroTrack/` | Features (Reducers + Views), Data (Repositories), App entry point |

---

## Adding a New Feature — Checklist

When asked to scaffold a new feature, follow this order:

1. Create `EnduroTrack/EnduroTrack/Features/<FeatureName>/`
2. Add `<FeatureName>Reducer.swift` — `@Reducer`, `@ObservableState`, `enum Action`
3. Add `<FeatureName>View.swift` — `@Bindable var store: StoreOf<…>`
4. Add a Domain entity in `Domain/Sources/Domain/Entities/` (if new data type needed)
5. Add a repository protocol in `Domain/Sources/Domain/UseCases/`
6. Add a concrete repository in `EnduroTrack/EnduroTrack/Data/Repositories/`
7. Register the `@Dependency` key
8. Scope the feature in `AppReducer` and add a tab in `ContentView`
9. Add DesignSystem components for any new reusable UI pieces
10. Write unit tests for the use case using a mock repository

---

## Code Style

- **Swift 6 strict concurrency** — use `@MainActor`, `Sendable`, `async/await`; no DispatchQueue or RxSwift.
- **TCA patterns** — reducers are pure; all side-effects go through `Effect.run { … }`.
- **No force-unwraps** — use `guard let`, `if let`, or `?? defaultValue`.
- **Localization** — wrap all user-facing strings in `String(localized:)`.
- Comments in **French or English** are both acceptable (mixed team).

---

## Swift Package Manager

Dependencies are declared in `EnduroTrack.xcodeproj` and pinned in:

```
EnduroTrack.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

To add a new remote dependency:
1. In Xcode: **File → Add Package Dependencies…**
2. Commit the updated `Package.resolved`.

Current dependencies:

| Package | URL | Version |
|---|---|---|
| `swift-composable-architecture` | https://github.com/pointfreeco/swift-composable-architecture | `>= 1.0.0, < 2.0.0` (pinned: 1.24.1) |
| `Domain` (local) | `./Domain` | — |
| `DesignSystem` (local) | `./DesignSystem` | — |

---

## Testing

- Unit tests live in `EnduroTrack/EnduroTrackTests/`
- Domain package tests live in `Domain/Tests/DomainTests/`
- For TCA reducers, use `TestStore` from `ComposableArchitecture`
- Mock repositories by implementing the corresponding protocol from `Domain`

---

## What NOT to Do

- Do **not** add business logic to Views.
- Do **not** import `SwiftUI` or `ComposableArchitecture` inside `Domain` or `DesignSystem`.
- Do **not** create a new package without updating this file and the README.
- Do **not** commit secrets, API keys, or credentials.
