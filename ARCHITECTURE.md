# ARCHITECTURE.md — EnduroTrack

> **Purpose:** This document is a living reference for Clean Architecture, SOLID principles,
> and VIPER as applied to this project. Update it whenever a feature is added or an
> architectural decision changes.

---

## Table of Contents

1. [Clean Architecture](#1-clean-architecture)
2. [SOLID Principles](#2-solid-principles)
3. [VIPER Architecture](#3-viper-architecture)
4. [How It All Fits Together in EnduroTrack](#4-how-it-all-fits-together-in-endurotrack)
5. [Project Structure](#5-project-structure)
6. [Dependency Rules](#6-dependency-rules)
7. [Data Flow Example](#7-data-flow-example)
8. [Feature List](#8-feature-list)
9. [Xcode Setup (First Time)](#9-xcode-setup-first-time)

---

## 1. Clean Architecture

Clean Architecture, introduced by Robert C. Martin ("Uncle Bob"), organises code into
**concentric layers**. The core rule is the **Dependency Rule**:

> *Source code dependencies must point **inward** — toward higher-level, more abstract layers.*

```
┌──────────────────────────────────────────────────────┐
│                  Outer (Frameworks)                   │
│   ┌────────────────────────────────────────────────┐ │
│   │          Interface Adapters (VIPER)            │ │
│   │   ┌──────────────────────────────────────────┐│ │
│   │   │         Application / Use Cases          ││ │
│   │   │   ┌──────────────────────────────────┐   ││ │
│   │   │   │     Domain (Entities)            │   ││ │
│   │   │   │  Pure Swift. No frameworks.      │   ││ │
│   │   │   └──────────────────────────────────┘   ││ │
│   │   └──────────────────────────────────────────┘│ │
│   └────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

### Layers in EnduroTrack

| Layer | Package / Folder | Allowed dependencies |
|---|---|---|
| **Domain** | `Domain/` (Swift Package) | None (pure Swift + Foundation) |
| **Use Cases** | Also in `Domain/` as protocols | Domain entities only |
| **Data** | `EnduroTrack/Data/` | Domain protocols |
| **Presentation** | `EnduroTrack/Features/` | Domain entities, DesignSystem |
| **UI Framework** | `DesignSystem/` (Swift Package) | SwiftUI only |

### Why This Matters

- You can swap the database (CoreData → CloudKit → API) without touching a single View or Presenter.
- You can test all business logic (Interactors, Use Cases) without a simulator.
- The Domain layer never breaks regardless of iOS version changes.

---

## 2. SOLID Principles

### S — Single Responsibility Principle

> *A class should have only one reason to change.*

In EnduroTrack:
- `WorkoutPresenter` only transforms data for display — it does not fetch data.
- `WorkoutInteractor` only handles business logic — it does not know about UI state.
- `WorkoutRepository` only persists data — it does not apply business rules.

❌ **Bad:** A ViewController that fetches data, formats it, and navigates.
✅ **Good:** Separate Presenter, Interactor, and Router.

---

### O — Open/Closed Principle

> *A class should be open for extension but closed for modification.*

In EnduroTrack:
- Add a new data source by creating a new type conforming to `WorkoutRepositoryProtocol`.
  You do not modify `WorkoutService`, `WorkoutPresenter`, or any View.
- Add a new WorkoutType enum case and the `displayName` switch expands naturally.

---

### L — Liskov Substitution Principle

> *Objects of a supertype should be replaceable with objects of a subtype without altering program correctness.*

In EnduroTrack:
- Any type conforming to `WorkoutRepositoryProtocol` can replace `WorkoutRepository`.
- Tests use mock implementations (e.g. `MockWorkoutRepository`) that are fully interchangeable.

---

### I — Interface Segregation Principle

> *Clients should not be forced to depend on methods they do not use.*

In EnduroTrack:
- Use cases are split into small, focused protocols:
  - `FetchWorkoutsUseCaseProtocol` — fetch only
  - `CreateWorkoutUseCaseProtocol` — create only
  - `UpdateWorkoutUseCaseProtocol` — update only
  - `DeleteWorkoutUseCaseProtocol` — delete only
- The Home feature only depends on `FetchWorkoutsUseCaseProtocol`, not the full CRUD.

---

### D — Dependency Inversion Principle

> *High-level modules should not depend on low-level modules. Both should depend on abstractions.*

In EnduroTrack:
- `HomeInteractor` depends on `FetchWorkoutsUseCaseProtocol` (abstract), not `WorkoutService` (concrete).
- `WorkoutService` depends on `WorkoutRepositoryProtocol` (abstract), not `WorkoutRepository` (concrete).
- Only the **Builder** and **App entry point** know about concrete types.

```
HomeInteractor ──depends on──► FetchWorkoutsUseCaseProtocol ◄──implements── WorkoutService
                                                                                    │
                                                              ──depends on──► WorkoutRepositoryProtocol ◄──implements── WorkoutRepository
```

---

## 3. VIPER Architecture

VIPER is an architectural pattern for iOS that implements Clean Architecture at the
feature/screen level. Each letter represents a layer:

| Letter | Layer | Responsibility |
|---|---|---|
| **V** | View | Renders UI. Forwards user events. No logic. |
| **I** | Interactor | Business logic. Calls Use Cases. Returns Domain entities. |
| **P** | Presenter | Mediates View ↔ Interactor. Transforms data into view state. |
| **E** | Entity | Domain models (from the Domain package). |
| **R** | Router | Navigation/coordination. Builds next screens. |

Plus a **Builder** (sometimes called Wireframe): assembles the module and injects dependencies.

### Communication Flow

```
User Action
    │
    ▼
┌──────────┐  calls  ┌───────────┐  calls  ┌────────────┐
│   View   │ ──────► │ Presenter │ ──────► │ Interactor │
└──────────┘         └───────────┘         └────────────┘
     ▲                     │  │                   │
     │  updates state      │  │ navigates         │ uses
     └─────────────────────┘  │                   ▼
                               │             ┌──────────┐
                               └──────────► │  Router  │
                                            └──────────┘
                                                 │
                                                 ▼
                                         builds next module
                                         via Builder
```

### SwiftUI Adaptation

Classic VIPER used `UIViewController` and weak delegate references between View and Presenter.
In SwiftUI:

- **Presenter is an `ObservableObject`** with `@Published var state`.
- **View uses `@StateObject`** to own and observe the Presenter.
- The Presenter calls the Router for navigation (Router owns `NavigationPath`).
- This keeps all layers testable and respects VIPER's separation of concerns.

### What goes where?

| Task | Layer |
|---|---|
| Show/hide a button | View |
| Format a date for display | Presenter |
| Validate business rules | Interactor |
| Decide which screen to go to next | Router |
| Fetch data from a database | Repository (via Use Case) |
| Define what a Workout *is* | Domain entity |

---

## 4. How It All Fits Together in EnduroTrack

```
EnduroTrackApp (Composition Root)
  │
  ├── Creates: WorkoutRepository, RunSessionRepository, TimerSessionRepository
  ├── Creates: WorkoutService, RunningService, TimerService
  │
  └── ContentView (Tab Bar)
        │
        ├── HomeBuilder.build(fetchWorkoutsUseCase: workoutService)
        │     ├── HomeRouter
        │     ├── HomeInteractor(fetchWorkoutsUseCase:)
        │     ├── HomePresenter(interactor: router:)
        │     └── HomeView(presenter:)
        │
        ├── WorkoutBuilder.build(...)
        ├── RunningBuilder.build(...)
        └── TimerBuilder.build(...)
```

---

## 5. Project Structure

```
EnduroTrack/                        ← Git repository root
│
├── Domain/                         ← Swift Package (no UI, no frameworks)
│   └── Sources/Domain/
│       ├── Entities/               ← Workout, Exercise, RunSession, TimerSession
│       ├── Enums/                  ← WorkoutType, WorkoutStatus
│       ├── UseCases/               ← Use Case protocols (Fetch/Create/Update/Delete)
│       └── RepositoryProtocols/    ← Repository interfaces
│
├── DesignSystem/                   ← Swift Package (SwiftUI only)
│   └── Sources/DesignSystem/
│       ├── Colors/                 ← AppColors (semantic color tokens)
│       ├── Fonts/                  ← AppFonts (typography system)
│       └── Components/             ← PrimaryButton, Card, StatBadge
│
├── EnduroTrack/                    ← Xcode Project
│   └── EnduroTrack/                ← App Target
│       ├── App/
│       │   ├── EnduroTrackApp.swift    ← @main entry point + Composition Root
│       │   └── ContentView.swift      ← Root TabView
│       │
│       ├── Data/
│       │   ├── Repositories/           ← Concrete repository implementations
│       │   └── Services/               ← Use case implementations
│       │
│       ├── Features/
│       │   ├── Home/                   ← VIPER module
│       │   │   ├── HomeContracts.swift
│       │   │   ├── HomeBuilder.swift
│       │   │   ├── View/HomeView.swift
│       │   │   ├── Presenter/HomePresenter.swift
│       │   │   ├── Interactor/HomeInteractor.swift
│       │   │   └── Router/HomeRouter.swift
│       │   ├── Workout/               ← VIPER module
│       │   ├── Running/               ← VIPER module
│       │   └── Timer/                 ← VIPER module
│       │
│       ├── SharedModels/
│       │   ├── SharedEnums.swift      ← AppTab, etc.
│       │   └── SharedValueObjects.swift
│       │
│       └── Config/
│           └── Info.plist
│
├── agent.md                        ← AI agent instructions
├── ARCHITECTURE.md                 ← This file
└── README.md
```

---

## 6. Dependency Rules

```
View         ─imports─► DesignSystem, Domain
Presenter    ─imports─► Foundation, Domain
Interactor   ─imports─► Foundation, Domain
Router       ─imports─► SwiftUI, Domain
Builder      ─imports─► SwiftUI, Domain
Service      ─imports─► Foundation, Domain
Repository   ─imports─► Foundation, Domain
Domain       ─imports─► Foundation only
DesignSystem ─imports─► SwiftUI only
```

**Never:**
- Import SwiftUI or UIKit in Presenter/Interactor/Domain
- Import concrete repository types in features (use protocols)
- Put navigation logic in the View
- Put business logic in the Presenter
- Put display formatting in the Interactor

---

## 7. Data Flow Example

**Scenario:** User opens the Home tab. The app fetches and displays workouts.

```
1. HomeView.task { await presenter.viewDidAppear() }
        │
2. HomePresenter.viewDidAppear()
        │ state = .loading
        │ calls interactor.fetchRecentWorkouts()
        │
3. HomeInteractor.fetchRecentWorkouts()
        │ calls fetchWorkoutsUseCase.execute()
        │
4. WorkoutService.execute()  (implements FetchWorkoutsUseCaseProtocol)
        │ calls repository.fetchAll()
        │
5. WorkoutRepository.fetchAll()
        │ returns [Workout]
        │
4. WorkoutService returns [Workout]
        │
3. HomeInteractor returns [Workout]
        │
2. HomePresenter: state = .loaded(workouts: [Workout])
        │
1. HomeView re-renders because @Published state changed
        └─► Displays workout cards
```

---

## 8. Feature List

| Feature | Status | VIPER Module |
|---|---|---|
| Home | 🟡 Skeleton | `Features/Home/` |
| Workout | 🟡 Skeleton | `Features/Workout/` |
| Running | 🟡 Skeleton | `Features/Running/` |
| Timer | 🟡 Skeleton | `Features/Timer/` |

> **Status key:** 🟡 Skeleton · 🔵 In Progress · ✅ Complete

---

## 9. Xcode Setup (First Time)

The file structure is created on disk. To fully wire it up in Xcode:

### Add Swift Package Dependencies

1. Open `EnduroTrack.xcodeproj` in Xcode.
2. **File → Add Package Dependencies → Add Local…**
3. Select the `Domain/` folder → Add to the `EnduroTrack` target.
4. Repeat for the `DesignSystem/` folder.

### Add New Source Files to the Target

1. In Xcode's Project Navigator, right-click the `EnduroTrack` folder.
2. Choose **"Add Files to EnduroTrack…"**
3. Select the newly created folders: `App/`, `Data/`, `Features/`, `SharedModels/`, `Config/`
4. Make sure **"Add to target: EnduroTrack"** is checked.

### Replace the Old Entry Point

1. In `EnduroTrackApp.swift` (the root one), remove the `@main` attribute (or delete the file from the target).
2. The new entry point is `App/EnduroTrackApp.swift`.

---

*This document is maintained by AI agents and developers. Update it whenever you add a feature or change an architectural decision.*
