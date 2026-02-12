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
    @Published var localNewHomeEnabled = false
    @Published var remoteStreamingEnabled = false
    @Published var remotePaywallEnabled = false

    private let store = InMemoryFeatureFlagStore()

    func loadDemoData() async {
        let client = FeatureFlagClient(store: store)

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

        localNewHomeEnabled = await client.isEnabled("new_home", context: .init(userID: "vip_1"))

        do {
            try await client.refresh(from: DemoRemoteProvider())
            let context = FeatureFlagContext(userID: "guest_42", appVersion: "2.5.1")

            remoteStreamingEnabled = await client.isEnabled("chat_streaming", context: context)
            remotePaywallEnabled = await client.isEnabled("new_paywall", context: context)
        } catch {
            remoteStreamingEnabled = false
            remotePaywallEnabled = false
        }
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
            )
        ]
    }
}
