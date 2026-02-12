//
//  FeatureFlagClientTests.swift
//  SwiftFeatureFlagKitTests
//
//  创建于 2026
//  主要功能：
//  - 验证规则引擎命中逻辑
//  - 验证存储与远程刷新行为
//
//

import Testing
@testable import SwiftFeatureFlagKit

@Test
func usesDefaultValueWhenNoRuleMatches() async {
    let client = FeatureFlagClient()
    await client.setDefinitions([
        FeatureFlagDefinition(key: "new_home", defaultValue: .bool(false))
    ])

    #expect(await client.isEnabled("new_home") == false)
}

@Test
func evaluatesUserRuleWithHigherPriority() async {
    let client = FeatureFlagClient()
    await client.setDefinitions([
        FeatureFlagDefinition(
            key: "new_home",
            defaultValue: .bool(false),
            rules: [
                FeatureFlagRule(condition: .userIDIn(["vip_1"]), value: .bool(true), priority: 1)
            ]
        )
    ])

    let enabled = await client.isEnabled("new_home", context: .init(userID: "vip_1"))
    #expect(enabled)
}

@Test
func supportsVersionComparisonRule() async {
    let client = FeatureFlagClient()
    await client.setDefinitions([
        FeatureFlagDefinition(
            key: "pro_editor",
            defaultValue: .bool(false),
            rules: [
                FeatureFlagRule(condition: .appVersionAtLeast("2.4.0"), value: .bool(true), priority: 5)
            ]
        )
    ])

    #expect(await client.isEnabled("pro_editor", context: .init(appVersion: "2.4.1")))
    #expect(await client.isEnabled("pro_editor", context: .init(appVersion: "2.3.9")) == false)
}

@Test
func rolloutRuleHandlesZeroAndHundredPercent() async {
    let client = FeatureFlagClient()

    await client.setDefinitions([
        FeatureFlagDefinition(
            key: "exp_a",
            defaultValue: .bool(false),
            rules: [
                FeatureFlagRule(condition: .percentageRollout(0), value: .bool(true), priority: 1)
            ]
        )
    ])
    #expect(await client.isEnabled("exp_a", context: .init(userID: "u1")) == false)

    await client.setDefinitions([
        FeatureFlagDefinition(
            key: "exp_b",
            defaultValue: .bool(false),
            rules: [
                FeatureFlagRule(condition: .percentageRollout(100), value: .bool(true), priority: 1)
            ]
        )
    ])
    #expect(await client.isEnabled("exp_b", context: .init(userID: "u1")))
}

@Test
func refreshPersistsAndLoadsFromStore() async throws {
    let store = InMemoryFeatureFlagStore()
    let writer = FeatureFlagClient(store: store)

    try await writer.refresh(from: MockFeatureFlagProvider(definitions: [
        FeatureFlagDefinition(key: "server_flag", defaultValue: .bool(true))
    ]))

    let reader = FeatureFlagClient(store: store)
    await reader.loadFromStore()

    #expect(await reader.isEnabled("server_flag"))
}
