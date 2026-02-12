//
//  MockFeatureFlagProvider.swift
//  SwiftFeatureFlagKitTests
//
//  创建于 2026
//  主要功能：
//  - 提供测试用远程配置模拟
//  - 用于验证 refresh 场景
//
//

@testable import SwiftFeatureFlagKit

struct MockFeatureFlagProvider: FeatureFlagProvider {
    let definitions: [FeatureFlagDefinition]

    func fetchDefinitions() async throws -> [FeatureFlagDefinition] {
        definitions
    }
}
