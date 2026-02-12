//
//  DemoViewModel.swift
//  FeatureFlagDemoApp
//
//  创建于 2026
//  主要功能：
//  - 组织 Demo 规则配置与读取
//  - 输出页面展示所需状态
//
//

import Foundation
import SwiftFeatureFlagKit

@MainActor
final class DemoViewModel: ObservableObject {
    @Published var selectedUserID = "guest_42"
    @Published var selectedVersion = "2.5.1"
    @Published var selectedRegion = "CN"

    @Published var newHomeEnabled = false
    @Published var chatStreamingEnabled = false
    @Published var newPaywallEnabled = false
    @Published var alwaysOnEnabled = false
    @Published var cnOnlyEnabled = false
    @Published var newHomeReason = ""
    @Published var chatStreamingReason = ""
    @Published var newPaywallReason = ""
    @Published var alwaysOnReason = ""
    @Published var cnOnlyReason = ""

    private let store = InMemoryFeatureFlagStore()
    private let client: FeatureFlagClient

    init() {
        client = FeatureFlagClient(store: store)
    }

    func bootstrap() async {
        // 本地配置：用于演示规则优先级和百分比灰度。
        await client.setDefinitions([
            FeatureFlagDefinition(
                key: "new_home",
                defaultValue: .bool(false),
                rules: [
                    FeatureFlagRule(condition: .userIDIn(["vip_1"]), value: .bool(true), priority: 1),
                    FeatureFlagRule(condition: .percentageRollout(10), value: .bool(true), priority: 10)
                ]
            )
        ])

        // 模拟远程配置刷新。
        try? await client.refresh(from: DemoRemoteProvider())
        await evaluate()
    }

    func evaluate() async {
        let context = FeatureFlagContext(
            userID: selectedUserID,
            appVersion: selectedVersion,
            attributes: ["region": .string(selectedRegion)]
        )

        newHomeEnabled = await client.isEnabled("new_home", context: context)
        chatStreamingEnabled = await client.isEnabled("chat_streaming", context: context)
        newPaywallEnabled = await client.isEnabled("new_paywall", context: context)
        alwaysOnEnabled = await client.isEnabled("always_on", context: context)
        cnOnlyEnabled = await client.isEnabled("cn_only_feature", context: context)

        // 输出可读的命中原因，方便演示和代码评审时理解。
        newHomeReason = reasonForNewHome(userID: selectedUserID, enabled: newHomeEnabled)
        chatStreamingReason = reasonForChatStreaming(version: selectedVersion, enabled: chatStreamingEnabled)
        newPaywallReason = reasonForNewPaywall(userID: selectedUserID, enabled: newPaywallEnabled)
        alwaysOnReason = "命中规则：always（全量开启）"
        cnOnlyReason = reasonForCNOnly(region: selectedRegion, enabled: cnOnlyEnabled)
    }

    private func reasonForNewHome(userID: String, enabled: Bool) -> String {
        if userID == "vip_1" {
            return "命中规则：userIDIn([\"vip_1\"])（优先级 1）"
        }
        if enabled {
            return "命中规则：percentageRollout(10)"
        }
        return "未命中规则，回落到默认值 false"
    }

    private func reasonForChatStreaming(version: String, enabled: Bool) -> String {
        if enabled {
            return "命中规则：appVersionAtLeast(\"2.5.0\")，当前版本 \(version)"
        }
        return "未命中规则，回落到默认值 false（版本低于 2.5.0）"
    }

    private func reasonForNewPaywall(userID: String, enabled: Bool) -> String {
        if userID == "vip_1" || userID == "vip_2" {
            return "命中规则：userIDIn([\"vip_1\", \"vip_2\"])（优先级 1）"
        }
        if enabled {
            return "命中规则：percentageRollout(20)"
        }
        return "未命中规则，回落到默认值 false"
    }

    private func reasonForCNOnly(region: String, enabled: Bool) -> String {
        if enabled {
            return "命中规则：attributeEquals(region == \"CN\")，当前 region=\(region)"
        }
        return "未命中规则，回落到默认值 false（当前 region=\(region)）"
    }
}

private struct DemoRemoteProvider: FeatureFlagProvider {
    func fetchDefinitions() async throws -> [FeatureFlagDefinition] {
        [
            FeatureFlagDefinition(
                key: "chat_streaming",
                defaultValue: .bool(false),
                rules: [
                    FeatureFlagRule(condition: .appVersionAtLeast("2.5.0"), value: .bool(true), priority: 5)
                ]
            ),
            FeatureFlagDefinition(
                key: "new_paywall",
                defaultValue: .bool(false),
                rules: [
                    FeatureFlagRule(condition: .userIDIn(["vip_1", "vip_2"]), value: .bool(true), priority: 1),
                    FeatureFlagRule(condition: .percentageRollout(20), value: .bool(true), priority: 10)
                ]
            ),
            FeatureFlagDefinition(
                key: "always_on",
                defaultValue: .bool(false),
                rules: [
                    FeatureFlagRule(condition: .always, value: .bool(true), priority: 1)
                ]
            ),
            FeatureFlagDefinition(
                key: "cn_only_feature",
                defaultValue: .bool(false),
                rules: [
                    FeatureFlagRule(
                        condition: .attributeEquals(key: "region", value: .string("CN")),
                        value: .bool(true),
                        priority: 1
                    )
                ]
            )
        ]
    }
}
