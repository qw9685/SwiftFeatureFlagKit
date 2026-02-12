//
//  FeatureFlagClient.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 提供开关读取与刷新入口
//  - 协调规则引擎与存储层
//
//

/// 特性开关客户端，负责加载配置、刷新远程配置和读取开关值。
public actor FeatureFlagClient {
    private let store: FeatureFlagStore
    private let evaluator = FeatureFlagEvaluator()
    private var definitionsByKey: [String: FeatureFlagDefinition] = [:]

    /// - Parameter store: 配置持久化实现，默认使用内存存储。
    public init(store: FeatureFlagStore = InMemoryFeatureFlagStore()) {
        self.store = store
    }

    /// 从持久化存储加载配置到内存索引。
    public func loadFromStore() async {
        let cachedDefinitions = await store.loadDefinitions()
        definitionsByKey = Dictionary(uniqueKeysWithValues: cachedDefinitions.map { ($0.key, $0) })
    }

    /// 从远程提供方拉取配置并覆盖本地配置，同时写入存储。
    /// - Parameter provider: 远程配置提供方。
    public func refresh(from provider: FeatureFlagProvider) async throws {
        let latestDefinitions = try await provider.fetchDefinitions()
        definitionsByKey = Dictionary(uniqueKeysWithValues: latestDefinitions.map { ($0.key, $0) })
        await store.saveDefinitions(latestDefinitions)
    }

    /// 直接设置全量配置，并同步写入存储。
    /// - Parameter definitions: 开关定义集合。
    public func setDefinitions(_ definitions: [FeatureFlagDefinition]) async {
        definitionsByKey = Dictionary(uniqueKeysWithValues: definitions.map { ($0.key, $0) })
        await store.saveDefinitions(definitions)
    }

    /// 获取某个开关的值。
    /// - Parameters:
    ///   - key: 开关键。
    ///   - context: 评估上下文。
    /// - Returns: 若开关不存在返回 `nil`，否则返回评估后的值。
    public func value(for key: String, context: FeatureFlagContext = .init()) -> FeatureFlagValue? {
        guard let definition = definitionsByKey[key] else { return nil }
        return evaluator.evaluate(definition: definition, context: context)
    }

    /// 快速读取布尔开关。
    /// - Parameters:
    ///   - key: 开关键。
    ///   - context: 评估上下文。
    /// - Returns: 开关不存在或值非布尔时返回 `false`。
    public func isEnabled(_ key: String, context: FeatureFlagContext = .init()) -> Bool {
        value(for: key, context: context)?.boolValue ?? false
    }
}
