# SwiftFeatureFlagKit

`SwiftFeatureFlagKit` 是一个轻量、并发安全的 Swift 特性开关库，
用于在不发版的情况下按规则控制功能开启与关闭。

## 解决的问题

- 支持灰度发布，降低全量上线风险。
- 支持快速回滚，避免等待应用商店审核。
- 规则优先级明确，行为可预测、可测试。
- 通过协议解耦远程配置与本地存储，便于扩展。

## 能力概览

- 按用户定向：`userIDIn(Set<String>)`
- 按版本定向：`appVersionAtLeast(String)`
- 按百分比灰度：`percentageRollout(Int)`
- 按自定义属性定向：`attributeEquals(key:value:)`
- 全量规则：`always`

## 环境要求

- Swift 6.2+
- iOS 15+
- macOS 13+

## 安装

在 `Package.swift` 中添加：

```swift
.package(path: "SDK/SwiftFeatureFlagKit")
```

## 快速开始

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
let enabled = await client.isEnabled("new_home", context: context)
```

## 核心 API

- `FeatureFlagClient`：开关读取、刷新、写入入口。
- `FeatureFlagDefinition`：开关定义（key + 默认值 + 规则）。
- `FeatureFlagRule`：规则定义（条件 + 值 + 优先级）。
- `FeatureFlagProvider`：远程配置协议。
- `FeatureFlagStore`：本地存储协议。

## 开发

```bash
swift test
```

CI 也使用相同命令执行测试。

## 许可证

MIT
