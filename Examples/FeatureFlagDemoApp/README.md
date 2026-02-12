# FeatureFlagDemoApp

`SwiftFeatureFlagKit` 的独立 iOS 示例应用。

## 示例展示内容

- `new_home`：用户定向 + 百分比灰度。
- `chat_streaming`：版本定向。
- `new_paywall`：VIP 用户定向 + 百分比灰度。
- `always_on`：`always` 全量命中。
- `cn_only_feature`：`attributeEquals(region == "CN")` 属性定向。

## 在 Xcode 中运行

1. 打开 `Examples/FeatureFlagDemoApp/SwiftFeatureFlagKitDemo.xcodeproj`。
2. 选择 Scheme：`FeatureFlagDemoApp`。
3. 选择一个 iPhone 模拟器。
4. 点击运行。

应用内操作：

1. 选择用户、版本和地区。
2. 点击“重新计算”。
3. 查看每个开关的 ON/OFF 和命中原因。

## 重新生成工程

在仓库根目录执行：

```bash
xcodegen generate --spec Examples/FeatureFlagDemoApp/project.yml
```
