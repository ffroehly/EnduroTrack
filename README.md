# EnduroTrack
Schedule, track, and improve your fitness sessions to be a better self.

---

## Architecture

EnduroTrack is built with **Clean Architecture + VIPER + SwiftUI**.

- **Domain** (Swift Package) — pure business logic, entities, use case protocols.
- **DesignSystem** (Swift Package) — colors, typography, reusable SwiftUI components.
- **Data** — concrete repositories and services.
- **Features** — VIPER modules: Home, Workout, Running, Timer.

For a complete guide, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Getting Started

1. Clone the repository.
2. Open `EnduroTrack/EnduroTrack.xcodeproj`.
3. Add the local Swift packages (`Domain/`, `DesignSystem/`) via **File → Add Package Dependencies → Add Local…**
4. Add the `App/`, `Data/`, `Features/`, `SharedModels/`, and `Config/` folders to the `EnduroTrack` target.
5. Build and run on an iOS 17+ simulator.

See [ARCHITECTURE.md § Xcode Setup](ARCHITECTURE.md#9-xcode-setup-first-time) for detailed steps.

## AI Agent Instructions

See [agent.md](agent.md) for conventions and commands used when working with AI agents.

