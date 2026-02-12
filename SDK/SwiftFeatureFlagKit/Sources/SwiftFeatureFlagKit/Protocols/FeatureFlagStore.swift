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

/// 开关配置存储协议。
public protocol FeatureFlagStore: Sendable {
    /// 读取已缓存的开关定义集合。
    func loadDefinitions() async -> [FeatureFlagDefinition]
    /// 保存最新开关定义集合。
    func saveDefinitions(_ definitions: [FeatureFlagDefinition]) async
}
