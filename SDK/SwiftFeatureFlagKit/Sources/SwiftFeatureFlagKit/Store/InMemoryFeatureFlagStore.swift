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

/// 内存态存储实现，适用于测试和本地开发调试。
public actor InMemoryFeatureFlagStore: FeatureFlagStore {
    private var definitions: [FeatureFlagDefinition]

    /// - Parameter definitions: 初始化时注入的开关定义集合。
    public init(definitions: [FeatureFlagDefinition] = []) {
        self.definitions = definitions
    }

    /// 读取当前内存中的开关定义。
    public func loadDefinitions() async -> [FeatureFlagDefinition] {
        definitions
    }

    /// 覆盖保存开关定义到内存。
    public func saveDefinitions(_ definitions: [FeatureFlagDefinition]) async {
        self.definitions = definitions
    }
}
