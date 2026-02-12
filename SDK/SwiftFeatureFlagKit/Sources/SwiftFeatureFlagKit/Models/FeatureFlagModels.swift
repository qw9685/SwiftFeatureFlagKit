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

/// 特性开关值类型，支持布尔、数值和字符串。
public enum FeatureFlagValue: Sendable, Equatable {
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)

    /// 当值类型为 `bool` 时返回对应布尔值，否则返回 `nil`。
    public var boolValue: Bool? {
        guard case .bool(let value) = self else { return nil }
        return value
    }
}

/// 开关评估上下文，包含用户、版本和自定义属性。
public struct FeatureFlagContext: Sendable, Equatable {
    public let userID: String?
    public let appVersion: String?
    public let attributes: [String: FeatureFlagValue]

    /// - Parameters:
    ///   - userID: 当前用户标识。
    ///   - appVersion: 当前应用版本号（如 `2.5.1`）。
    ///   - attributes: 自定义属性，用于属性匹配规则。
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

/// 开关规则条件。
public enum FeatureFlagCondition: Sendable, Equatable {
    case always
    case userIDIn(Set<String>)
    case appVersionAtLeast(String)
    case percentageRollout(Int)
    case attributeEquals(key: String, value: FeatureFlagValue)
}

/// 单条规则：条件命中后返回给定值，按优先级从小到大匹配。
public struct FeatureFlagRule: Sendable, Equatable {
    public let condition: FeatureFlagCondition
    public let value: FeatureFlagValue
    public let priority: Int

    /// - Parameters:
    ///   - condition: 规则条件。
    ///   - value: 规则命中后的返回值。
    ///   - priority: 规则优先级，值越小优先级越高。
    public init(condition: FeatureFlagCondition, value: FeatureFlagValue, priority: Int = 100) {
        self.condition = condition
        self.value = value
        self.priority = priority
    }
}

/// 开关定义：包含默认值及多条规则。
public struct FeatureFlagDefinition: Sendable, Equatable {
    public let key: String
    public let defaultValue: FeatureFlagValue
    public let rules: [FeatureFlagRule]

    /// - Parameters:
    ///   - key: 开关唯一标识。
    ///   - defaultValue: 无规则命中时返回的默认值。
    ///   - rules: 规则集合。
    public init(key: String, defaultValue: FeatureFlagValue, rules: [FeatureFlagRule] = []) {
        self.key = key
        self.defaultValue = defaultValue
        self.rules = rules
    }
}
