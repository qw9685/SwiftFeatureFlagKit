//
//  main.swift
//  FeatureFlagDemo
//
//  创建于 2026
//  主要功能：
//  - 提供可执行 Demo 入口
//  - 演示本地规则与远程刷新
//
//

import Foundation
import SwiftFeatureFlagKit

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

@main
struct FeatureFlagDemoApp {
    static func main() async {
        let store = InMemoryFeatureFlagStore()
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

        let localContext = FeatureFlagContext(userID: "vip_1", appVersion: "2.4.0")
        let localEnabled = await client.isEnabled("new_home", context: localContext)
        print("[Local] new_home for vip_1 -> \(localEnabled)")

        do {
            try await client.refresh(from: DemoRemoteProvider())

            let remoteContext = FeatureFlagContext(userID: "guest_42", appVersion: "2.5.1")
            let streamingEnabled = await client.isEnabled("chat_streaming", context: remoteContext)
            let paywallEnabled = await client.isEnabled("new_paywall", context: remoteContext)

            print("[Remote] chat_streaming for guest_42@2.5.1 -> \(streamingEnabled)")
            print("[Remote] new_paywall for guest_42@2.5.1 -> \(paywallEnabled)")
        } catch {
            print("Remote refresh failed: \(error)")
        }
    }
}
