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

public actor FeatureFlagClient {
    private let store: FeatureFlagStore
    private let evaluator = FeatureFlagEvaluator()
    private var definitionsByKey: [String: FeatureFlagDefinition] = [:]

    public init(store: FeatureFlagStore = InMemoryFeatureFlagStore()) {
        self.store = store
    }

    public func loadFromStore() async {
        let cachedDefinitions = await store.loadDefinitions()
        definitionsByKey = Dictionary(uniqueKeysWithValues: cachedDefinitions.map { ($0.key, $0) })
    }

    public func refresh(from provider: FeatureFlagProvider) async throws {
        let latestDefinitions = try await provider.fetchDefinitions()
        definitionsByKey = Dictionary(uniqueKeysWithValues: latestDefinitions.map { ($0.key, $0) })
        await store.saveDefinitions(latestDefinitions)
    }

    public func setDefinitions(_ definitions: [FeatureFlagDefinition]) async {
        definitionsByKey = Dictionary(uniqueKeysWithValues: definitions.map { ($0.key, $0) })
        await store.saveDefinitions(definitions)
    }

    public func value(for key: String, context: FeatureFlagContext = .init()) -> FeatureFlagValue? {
        guard let definition = definitionsByKey[key] else { return nil }
        return evaluator.evaluate(definition: definition, context: context)
    }

    public func isEnabled(_ key: String, context: FeatureFlagContext = .init()) -> Bool {
        value(for: key, context: context)?.boolValue ?? false
    }
}
