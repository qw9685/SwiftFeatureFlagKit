# SwiftFeatureFlagKit

Monorepo layout:

- `SDK/SwiftFeatureFlagKit`: Swift Package for the feature-flag library.
- `Examples/FeatureFlagDemoApp`: standalone iOS demo app.

## Open Demo in Xcode

1. Open `Examples/FeatureFlagDemoApp/SwiftFeatureFlagKitDemo.xcodeproj`.
2. Select scheme `FeatureFlagDemoApp`.
3. Select an iPhone Simulator and Run.

## Use the SDK package (local path)

```swift
.package(path: "SDK/SwiftFeatureFlagKit")
```

## Run SDK tests

```bash
cd SDK/SwiftFeatureFlagKit
swift test
```
