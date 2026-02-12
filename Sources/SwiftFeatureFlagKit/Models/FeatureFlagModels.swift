//
//  FeatureFlagModels.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 定义特性开关基础模型
//  - 提供上下文、规则和配置结构
//
//

import Foundation

public enum FeatureFlagValue: Sendable, Equatable {
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)

    public var boolValue: Bool? {
        guard case .bool(let value) = self else { return nil }
        return value
    }
}

public struct FeatureFlagContext: Sendable, Equatable {
    public let userID: String?
    public let appVersion: String?
    public let attributes: [String: FeatureFlagValue]

    public init(
        userID: String? = nil,
        appVersion: String? = nil,
        attributes: [String: FeatureFlagValue] = [:]
    ) {
        self.userID = userID
        self.appVersion = appVersion
        self.attributes = attributes
    }
}

public enum FeatureFlagCondition: Sendable, Equatable {
    case always
    case userIDIn(Set<String>)
    case appVersionAtLeast(String)
    case percentageRollout(Int)
    case attributeEquals(key: String, value: FeatureFlagValue)
}

public struct FeatureFlagRule: Sendable, Equatable {
    public let condition: FeatureFlagCondition
    public let value: FeatureFlagValue
    public let priority: Int

    public init(condition: FeatureFlagCondition, value: FeatureFlagValue, priority: Int = 100) {
        self.condition = condition
        self.value = value
        self.priority = priority
    }
}

public struct FeatureFlagDefinition: Sendable, Equatable {
    public let key: String
    public let defaultValue: FeatureFlagValue
    public let rules: [FeatureFlagRule]

    public init(key: String, defaultValue: FeatureFlagValue, rules: [FeatureFlagRule] = []) {
        self.key = key
        self.defaultValue = defaultValue
        self.rules = rules
    }
}
