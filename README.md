# SwiftFeatureFlagKit

该仓库采用 Monorepo 结构：

- `SDK/SwiftFeatureFlagKit`：特性开关 SDK（Swift Package）
- `Examples/FeatureFlagDemoApp`：独立 iOS 示例工程

## 在 Xcode 中打开示例

1. 打开 `Examples/FeatureFlagDemoApp/SwiftFeatureFlagKitDemo.xcodeproj`。
2. 选择 Scheme：`FeatureFlagDemoApp`。
3. 选择一个 iPhone 模拟器并运行。

## 使用本地 SDK 包

在 `Package.swift` 中添加：

```swift
.package(path: "SDK/SwiftFeatureFlagKit")
```

## 运行 SDK 测试

```bash
cd SDK/SwiftFeatureFlagKit
swift test
```
