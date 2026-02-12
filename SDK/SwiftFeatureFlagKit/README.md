# SwiftFeatureFlagKit

SwiftFeatureFlagKit is a small, concurrency-safe feature flag library for Swift.
It is designed for teams that want predictable rollout behavior without a heavy dependency stack.

## What it does

- Evaluates flags from local definitions with deterministic rule priority.
- Supports targeting by user, app version, attributes, and percentage rollout.
- Persists fetched definitions through a pluggable store.
- Keeps a small and explicit public API.

## Requirements

- Swift 6.2+
- iOS 15+
- macOS 13+

## Installation

Add the package in `Package.swift`:

```swift
.package(path: "SDK/SwiftFeatureFlagKit")
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

## External Example Project



## Public API

- `FeatureFlagClient`: main actor-based entry point.
- `FeatureFlagDefinition`: flag key with default and rules.
- `FeatureFlagRule`: condition + output value + priority.
- `FeatureFlagProvider`: protocol for remote fetch.
- `FeatureFlagStore`: protocol for persistence.

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

## License

MIT
