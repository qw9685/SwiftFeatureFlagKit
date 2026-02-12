//
//  FeatureFlagStore.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 定义配置持久化协议
//  - 提供读写解耦能力
//
//

public protocol FeatureFlagStore: Sendable {
    func loadDefinitions() async -> [FeatureFlagDefinition]
    func saveDefinitions(_ definitions: [FeatureFlagDefinition]) async
}
