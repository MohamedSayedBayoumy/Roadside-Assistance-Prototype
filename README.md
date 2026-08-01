# ------------------- Required -------------------
- a **Secret/Private Token** is required to download the SDK binaries during the build process. For security reasons, this token is not included in the repository.


# ------------------- Architecture -------------------

**1. Maintainability & Separation of Concerns**
The project is architected using **Clean Architecture**, cleanly dividing the system into distinct layers (Domain, Data, and Presentation). This strict **Separation of Concerns** ensures that business logic is completely isolated from UI rendering and data fetching. As a result, the codebase is highly maintainable; updates in the UI or changes in the API do not ripple through or break the core business rules.

**2. Single Source of Truth (SSOT)**
By implementing the Repository Pattern, the architecture enforces a **Single Source of Truth (SSOT)**. The presentation and domain layers never interact with raw data sources directly. The repository orchestrates data flow (whether from remote APIs or local caching), ensuring the application state remains consistent, reliable, and free from out-of-sync data bugs.

**3. Extensibility via Clean Interfaces**
Following the Dependency Inversion Principle, the core system relies entirely on **Clean Interfaces (Contracts)** rather than **Concrete Implementations**. The Domain layer dictates the contracts, and the Data layer provides the implementation. This makes the system extremely **Extensible**—swapping a third-party package (like Mapbox to Google Maps) or changing the HTTP client requires only writing a new concrete class, leaving the core business logic completely untouched.

**4. High Testability**
Because the system is decoupled and built on abstract contracts, its **Testability** is exceptionally high. We can easily inject Mock implementations of our repositories and services. This allows us to write fast, isolated, and comprehensive Unit Tests for our Use Cases and Controllers without relying on network calls or external dependencies, ensuring our business rules are robust and bug-free.

# ------------------- Technical Decisions Of Track Feature -------------------

## 1. Technical Decisions

- **State Management (GetX):**
  Chosen for its reactivity (`RxBool`, `Worker`, `ever`) and clean separation of concerns. It allowed me to completely decouple the map's complex state (camera movements, animation frames, marker states) from the UI layer.
- **Mapbox & Geolocator Integration:**
  Opted for Mapbox over Google Maps for advanced camera manipulations (`easeTo`, `flyTo`) and smooth polyline animations. `Geolocator` was used to calculate accurate distances between route segments to dynamically adjust the car's animation speed.

- **Custom Frame-by-Frame Animation (`_animateCarBetween`):**
  Instead of teleporting the driver marker between coordinates, I implemented a custom `Timer.periodic` running at ~16ms (60 FPS) to interpolate coordinates. This ensures a buttery-smooth car movement along the polyline.
- **Debouncing Camera Movements:**
  Implemented a `Timer`-based debounce (800ms) inside `onCameraMoved` to prevent spamming the Reverse Geocoding API while the user is actively dragging the map.

## 2. Trade-offs Made

- **Timer vs. `AnimationController`:**
  I used `Timer.periodic` for the car movement simulation instead of Flutter's native `AnimationController`. _Trade-off:_ While `AnimationController` hooks directly into the screen's vsync (better performance), it requires a `TickerProvider` which tightly couples the Controller to the UI widget. Using a Timer kept the business logic completely isolated in the GetX Controller, sacrificing a tiny bit of vsync synchronization for a cleaner architecture.
- **In-Memory Route Tracking vs. Background Execution:**
  The current simulation and routing logic runs in the main thread. _Trade-off:_ It provides immediate UI feedback and easier state management, but if the app is minimized for a long time, the OS might kill the process, losing the active trip state.

## 3. Future Improvements (With More Time)

- **Isolate-based Location Processing:**
  I would offload the heavy calculations (like `PolylinePoints.decodePolyline`, bearing calculations, and coordinate interpolations) to a separate `Isolate` to ensure the main UI thread never drops a frame, especially on longer routes with thousands of coordinates.
- **Real-time Backend Synchronization:**
  Replace the simulated car movement (`_runSimulationLoop`) with a WebSocket connection to receive real-time driver coordinates and interpolate between the live server updates rather than a static pre-fetched route.
- **Background Location Service:**
  Implement a Foreground Service (for Android) to maintain the trip state and continue fetching user location/drawing polylines even when the app is running in the background.

# ------------------- Scaling for Thousands of Concurrent Live-Tracked -------------------

- **Spatial Filtering & WebSockets:** Move to WebSockets for low-latency streaming, ensuring the backend only pushes coordinate updates for jobs currently visible within the Flutter map's bounding box.
- **Client-Side Throttling:** Use RxDart to batch and throttle incoming socket streams, preventing main-thread jank from rapid location ticks and maintaining a smooth 60fps.

- **Targeted Rebuilds & Clustering:** Utilize Mapbox's native clustering for dense areas and isolate UI state (using targeted `Obx` or `StreamBuilder`s) to rebuild _only_ the specific moving markers, not the entire map widget tree.

- **Lifecycle Management:** Enforce strict `AppLifecycleState` hooks to close active streams when the app is backgrounded, falling back to silent push notifications to sync critical states without draining device battery or memory.
