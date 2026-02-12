//
//  FeatureFlagProvider.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 定义远程配置拉取协议
//  - 统一服务端配置数据入口
//
//

/// 远程配置提供方协议。
public protocol FeatureFlagProvider: Sendable {
    /// 拉取最新开关定义集合。
    func fetchDefinitions() async throws -> [FeatureFlagDefinition]
}
