//
//  InMemoryFeatureFlagStore.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 提供内存态配置存储
//  - 用于测试和本地开发
//
//

public actor InMemoryFeatureFlagStore: FeatureFlagStore {
    private var definitions: [FeatureFlagDefinition]

    public init(definitions: [FeatureFlagDefinition] = []) {
        self.definitions = definitions
    }

    public func loadDefinitions() async -> [FeatureFlagDefinition] {
        definitions
    }

    public func saveDefinitions(_ definitions: [FeatureFlagDefinition]) async {
        self.definitions = definitions
    }
}
