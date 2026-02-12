# SwiftFeatureFlagKit

SwiftFeatureFlagKit is a small, concurrency-safe feature flag library for Swift.
It is designed for teams that want a predictable rollout mechanism without introducing a heavy dependency stack.

## What it does

- Evaluates flags from local definitions with deterministic rule priority.
- Supports targeted rollout by user, app version, attributes, and percentage.
- Persists fetched definitions through a pluggable store.
- Keeps the public surface area intentionally small.

## Requirements

- Swift 6.2+
- iOS 15+
- macOS 13+

## Installation

Add the package in `Package.swift`:

```swift
.package(url: "https://github.com/your-org/SwiftFeatureFlagKit.git", from: "1.0.0")
```

## Quick start

```swift
import SwiftFeatureFlagKit

let client = FeatureFlagClient()

await client.setDefinitions([
    FeatureFlagDefinition(
        key: "new_home",
        defaultValue: .bool(false),
        rules: [
            FeatureFlagRule(condition: .userIDIn(["vip_1"]), value: .bool(true), priority: 1),
            FeatureFlagRule(condition: .percentageRollout(20), value: .bool(true), priority: 10)
        ]
    )
])

let context = FeatureFlagContext(userID: "vip_1", appVersion: "2.4.0")
let isEnabled = await client.isEnabled("new_home", context: context)
```

## Demo

This repository includes two demos:

- `SwiftFeatureFlagKitDemo.xcodeproj`: iOS SwiftUI app demo (recommended for Xcode).
- `FeatureFlagDemo`: command-line demo target for quick terminal checks.

### Run in Xcode (recommended)

1. Open `/Users/cc/Desktop/github/SwiftFeatureFlagKit/SwiftFeatureFlagKitDemo.xcodeproj`.
2. Select scheme `FeatureFlagDemoApp`.
3. Select an iPhone Simulator and press Run.

### Run in Terminal

```bash
swift run FeatureFlagDemo
```

Expected output (example):

```text
[Local] new_home for vip_1 -> true
[Remote] chat_streaming for guest_42@2.5.1 -> true
[Remote] new_paywall for guest_42@2.5.1 -> false
```

Or open `Package.swift` in Xcode and run scheme `FeatureFlagDemo`.

## Public API

- `FeatureFlagClient`: Main actor-based entry point.
- `FeatureFlagDefinition`: Flag key with default and rules.
- `FeatureFlagRule`: Condition + output value + priority.
- `FeatureFlagProvider`: Protocol for remote fetch.
- `FeatureFlagStore`: Protocol for persistence.

## Rule conditions

- `always`
- `userIDIn(Set<String>)`
- `appVersionAtLeast(String)`
- `percentageRollout(Int)`
- `attributeEquals(key:value:)`

## Development

Run tests:

```bash
swift test
```

CI runs the same command on pull requests and pushes to `main`.

## Roadmap

- JSON decoding helpers for remote payloads.
- File-based store implementation.
- Experiment-level sticky bucketing options.
- Optional exposure callback hooks.

## License

MIT
