# EnduroTrack

Schedule, track, and improve your fitness sessions to be a better self.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Getting Started](#2-getting-started)
3. [Project Structure](#3-project-structure)
4. [Clean Architecture](#4-clean-architecture)
5. [SOLID Principles](#5-solid-principles)
6. [The Composable Architecture (TCA)](#6-the-composable-architecture-tca)
7. [How Everything Fits Together](#7-how-everything-fits-together)
8. [How to Add a New Feature](#8-how-to-add-a-new-feature)
9. [Architecture Change Log](#9-architecture-change-log)

---

## 1. Project Overview

EnduroTrack is a SwiftUI iOS application that lets athletes plan workouts,
track running sessions, and review their training history.

**Tech Stack**

| Layer | Technology |
|---|---|
| UI | SwiftUI (async/await, no RxSwift) |
| State Management | [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) |
| Business Logic | Domain Swift Package (pure Swift, zero dependencies) |
| UI Components | DesignSystem Swift Package (SwiftUI only) |
| Data | Repository pattern, async/await |

---

## 2. Getting Started

### Prerequisites

- Xcode 16 or later
- iOS 17+ simulator or device

### Setup Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/ffroehly/EnduroTrack.git
   cd EnduroTrack/EnduroTrack
   open EnduroTrack.xcodeproj
   ```

2. **Resolve Swift Packages**

   In Xcode: **File → Packages → Resolve Package Versions**

   This downloads:
   - **TCA** (`swift-composable-architecture`) – remote package from GitHub
   - **Domain** (`./Domain`) – local package with business logic
   - **DesignSystem** (`./DesignSystem`) – local package with UI components

3. **Build and run**

   Select the `EnduroTrack` scheme and press ⌘R.

> **Note:** The skeleton files import `ComposableArchitecture`, `Domain`, and
> `DesignSystem`. These imports will show errors until package resolution
> completes. Always resolve packages before building.

---

## 3. Project Structure

```
EnduroTrack/                         ← Git repository root
└── EnduroTrack/                     ← Xcode project directory
    ├── EnduroTrack.xcodeproj/
    │
    ├── EnduroTrack/                 ← App target (auto-synced by Xcode)
    │   ├── App/
    │   │   ├── EnduroTrackApp.swift ← @main entry point
    │   │   ├── AppReducer.swift     ← Root TCA reducer (composes all features)
    │   │   └── ContentView.swift    ← Root TabView
    │   │
    │   ├── Features/                ← One folder per screen / feature
    │   │   ├── Home/
    │   │   │   ├── HomeReducer.swift
    │   │   │   └── HomeView.swift
    │   │   ├── Workout/
    │   │   │   ├── WorkoutReducer.swift
    │   │   │   └── WorkoutView.swift
    │   │   ├── Running/
    │   │   │   ├── RunningReducer.swift
    │   │   │   └── RunningView.swift
    │   │   └── Timer/
    │   │       ├── TimerReducer.swift
    │   │       └── TimerView.swift
    │   │
    │   ├── Data/                    ← Concrete repository implementations
    │   │   ├── Repositories/
    │   │   │   ├── WorkoutRepository.swift
    │   │   │   └── RunningRepository.swift
    │   │   └── Services/            ← Network clients, CoreData stacks …
    │   │
    │   ├── SharedModels/            ← Enums / types shared across features
    │   │   └── SharedEnums.swift
    │   │
    │   └── Config/                  ← Reserved for future app config files
    │
    ├── Domain/                      ← Local Swift Package (pure business logic)
    │   └── Sources/Domain/
    │       ├── Entities/            ← Workout.swift, Run.swift
    │       ├── ValueObjects/        ← Duration.swift, Distance.swift
    │       └── UseCases/            ← Protocols + concrete use-case types
    │
    └── DesignSystem/                ← Local Swift Package (reusable UI)
        └── Sources/DesignSystem/
            ├── Colors/              ← ETColor palette
            ├── Typography/          ← ETFont scale
            └── Components/          ← PrimaryButton, WorkoutCard …
```

---

## 4. Clean Architecture

### What is Clean Architecture?

Clean Architecture (Robert C. Martin / "Uncle Bob") organises code into
**concentric layers**. Each layer has one responsibility, and
**dependencies always point inward** – outer layers may reference inner ones,
never the reverse.

```
┌─────────────────────────────────────────┐
│            Frameworks & UI               │  SwiftUI views
│  ┌───────────────────────────────────┐  │
│  │       Interface Adapters          │  │  TCA Reducers, Repositories
│  │  ┌─────────────────────────────┐  │  │
│  │  │      Application Logic      │  │  │  Use Cases
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │       Entities         │  │  │  │  Domain objects, value objects
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### How EnduroTrack Maps to Layers

| Architectural Concept | Location in This Project |
|---|---|
| **Entities** | `Domain/Sources/Domain/Entities/` |
| **Value Objects** | `Domain/Sources/Domain/ValueObjects/` |
| **Use Cases + Repository Protocols** | `Domain/Sources/Domain/UseCases/` |
| **Concrete Repositories (Data layer)** | `EnduroTrack/Data/Repositories/` |
| **Interface Adapters (TCA Reducers)** | `EnduroTrack/Features/*/…Reducer.swift` |
| **UI (Frameworks layer)** | `EnduroTrack/Features/*/…View.swift` |
| **Reusable UI Primitives** | `DesignSystem/Sources/DesignSystem/` |

### The Dependency Rule (Critical)

```
✅ WorkoutReducer  →  imports Domain        (outer depends on inner)
✅ WorkoutRepository  →  imports Domain     (outer depends on inner)
✅ WorkoutView  →  imports DesignSystem     (outer depends on primitives)

❌ Domain  →  imports ComposableArchitecture  (FORBIDDEN)
❌ Domain  →  imports SwiftUI                 (FORBIDDEN)
❌ DesignSystem  →  imports Domain            (FORBIDDEN)
```

If you need to show a `Workout` in a DesignSystem card, extract plain
`String`/`Double` values in the Feature layer and pass only those to the
component. This keeps DesignSystem free of any Domain knowledge.

---

## 5. SOLID Principles

### S — Single Responsibility Principle

> *A module should have one, and only one, reason to change.*

| Example |
|---|
| `Workout` describes **what** a workout is. It does not save or display itself. |
| `WorkoutRepository` knows only how to **persist** workouts. |
| `WorkoutReducer` manages **state** for the Workout screen only. |
| `PrimaryButton` renders a button. It knows nothing about workouts. |

Each type changes for exactly one reason. If a database schema changes,
only `WorkoutRepository` is updated. If the button style changes, only
`PrimaryButton` is updated.

---

### O — Open / Closed Principle

> *Open for extension, closed for modification.*

To support a new training type, **add** a new `DifficultyLevel` case or a
new entity — do **not** edit the existing `Workout` struct.

To add a new feature screen, **create** new files in `Features/<NewFeature>/`
without touching existing feature code.

---

### L — Liskov Substitution Principle

> *Subtypes must be substitutable for their base type.*

`WorkoutRepository` and `MockWorkoutRepository` both conform to
`WorkoutRepositoryProtocol`. The use-case layer can accept either:

```swift
// Production
let useCase = FetchWorkoutsUseCase(repository: WorkoutRepository())

// Test
let useCase = FetchWorkoutsUseCase(repository: MockWorkoutRepository())
```

The use case is unchanged – it does not know or care which concrete type it
receives.

---

### I — Interface Segregation Principle

> *Clients should not depend on interfaces they do not use.*

We define **narrow, focused protocols** in the Domain layer:

- `WorkoutRepositoryProtocol` — fetch / save / delete for workouts only.
- `RunningRepositoryProtocol` — fetch / save / delete for runs only.

There is no single "AppRepositoryProtocol" that every feature must import.
If a new feature only reads data, its protocol only exposes a `fetchAll` method.

---

### D — Dependency Inversion Principle

> *High-level modules must not depend on low-level modules.
> Both should depend on abstractions.*

`FetchWorkoutsUseCase` (high-level) depends on `WorkoutRepositoryProtocol`
(abstraction), **not** on `WorkoutRepository` (concrete class).

In TCA, dependency injection is handled with `@Dependency`:

```swift
// 1. Define the dependency key (Data layer or separate DI file)
private enum WorkoutRepositoryKey: DependencyKey {
    static let liveValue: any WorkoutRepositoryProtocol = WorkoutRepository()
    static let testValue: any WorkoutRepositoryProtocol = MockWorkoutRepository()
}

extension DependencyValues {
    var workoutRepository: any WorkoutRepositoryProtocol {
        get { self[WorkoutRepositoryKey.self] }
        set { self[WorkoutRepositoryKey.self] = newValue }
    }
}

// 2. Consume it in the reducer – no concrete type in sight
@Reducer struct WorkoutReducer {
    @Dependency(\.workoutRepository) var repository
    …
}
```

---

## 6. The Composable Architecture (TCA)

TCA is a library by [Point-Free](https://www.pointfree.co) for building
predictable, testable, and composable iOS applications.

### Core Concepts

| Concept | Role |
|---|---|
| `State` | A struct describing everything the feature needs to render |
| `Action` | An enum listing every possible event (tap, data loaded, …) |
| `Reducer` | Pure function: receives `(inout State, Action)` → returns `Effect` |
| `Effect` | An async side-effect (network call, timer, location update, …) |
| `Store` | Holds state; dispatches actions; runs the reducer |
| `@Dependency` | Injects services (repositories, clocks, …) into reducers |

### Anatomy of a Feature (EnduroTrack pattern)

```swift
// ─── WorkoutReducer.swift ───────────────────────────────────────────────────
import ComposableArchitecture
import Domain

@Reducer
struct WorkoutReducer {

    @ObservableState
    struct State: Equatable {
        var workouts: [Workout] = []
        var isLoading = false
    }

    enum Action {
        case onAppear
        case workoutsLoaded([Workout])
    }

    @Dependency(\.workoutRepository) var repository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let items = try await FetchWorkoutsUseCase(
                        repository: repository
                    ).execute()
                    await send(.workoutsLoaded(items))
                }

            case let .workoutsLoaded(items):
                state.isLoading = false
                state.workouts = items
                return .none
            }
        }
    }
}

// ─── WorkoutView.swift ──────────────────────────────────────────────────────
import SwiftUI
import ComposableArchitecture
import DesignSystem

struct WorkoutView: View {
    @Bindable var store: StoreOf<WorkoutReducer>

    var body: some View {
        List(store.workouts) { workout in
            WorkoutCard(
                name: workout.name,
                duration: workout.duration.formatted,
                difficulty: workout.difficulty.rawValue
            )
        }
        .onAppear { store.send(.onAppear) }
    }
}
```

### Composing Features with AppReducer

`AppReducer` in `App/AppReducer.swift` uses `Scope` to wire all features
into one root store. Each feature only owns its slice of state.

```swift
@Reducer
struct AppReducer {
    @ObservableState
    struct State: Equatable {
        var home    = HomeReducer.State()
        var workout = WorkoutReducer.State()
        var running = RunningReducer.State()
        var timer   = TimerReducer.State()
    }

    enum Action {
        case home(HomeReducer.Action)
        case workout(WorkoutReducer.Action)
        case running(RunningReducer.Action)
        case timer(TimerReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home,    action: \.home)    { HomeReducer()    }
        Scope(state: \.workout, action: \.workout) { WorkoutReducer() }
        Scope(state: \.running, action: \.running) { RunningReducer() }
        Scope(state: \.timer,   action: \.timer)   { TimerReducer()   }
    }
}
```

---

## 7. How Everything Fits Together

```
User taps "Start" in WorkoutView
          │
          ▼
store.send(.startWorkoutTapped)
          │
          ▼
WorkoutReducer.body          ← pure Swift, no UI
          │  returns Effect.run { … }
          ▼
SaveWorkoutUseCase.execute(workout)
          │  validates name is not empty (Domain rule)
          ▼
WorkoutRepository.save(workout)    ← Data layer (API / CoreData)
          │
          ▼
State updated → WorkoutView re-renders automatically
```

Data flows **downward** (state → view) and events flow **upward**
(action → reducer → effect → state update).

Business rules live entirely in the **Domain** layer; they never touch SwiftUI
or any networking library.

---

## 8. How to Add a New Feature

Follow this checklist every time you add a new screen or capability:

- [ ] **Create a folder** `EnduroTrack/Features/<FeatureName>/`
- [ ] **Add `<FeatureName>Reducer.swift`** using `@Reducer`, `@ObservableState`, `enum Action`
- [ ] **Add `<FeatureName>View.swift`** using `@Bindable var store: StoreOf<…>`
- [ ] **Add a Domain entity** in `Domain/Sources/Domain/Entities/` (if new data type)
- [ ] **Add a repository protocol** in `Domain/Sources/Domain/UseCases/`
- [ ] **Add a concrete repository** in `EnduroTrack/Data/Repositories/`
- [ ] **Register the `@Dependency`** key in the Data layer
- [ ] **Scope the feature** in `AppReducer` and add a tab in `ContentView`
- [ ] **Add DesignSystem components** for any new reusable UI pieces
- [ ] **Write tests** for the use case (mock the repository protocol)
- [ ] **Update this README** — add a row to the Architecture Change Log below

---

## 9. Architecture Change Log

> Keep this table up-to-date every time the architecture changes.
> AI agents should update it automatically when scaffolding new features.

| Date | Change | Author |
|---|---|---|
| 2026-03-02 | Initial project scaffold – Clean Architecture + TCA skeleton, Domain & DesignSystem local packages, TCA remote package | Agent |
| 2026-03-02 | Added `AGENTS.md` (AI coding-assistant configuration); added `Package.resolved` to pin SPM dependencies; removed placeholder `AgentConfig.swift` | Agent |
