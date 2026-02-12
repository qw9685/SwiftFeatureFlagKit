//
//  FeatureFlagEvaluator.swift
//  SwiftFeatureFlagKit
//
//  创建于 2026
//  主要功能：
//  - 执行规则匹配与优先级计算
//  - 提供版本比较与稳定分桶
//
//

import Foundation

struct FeatureFlagEvaluator {
    func evaluate(definition: FeatureFlagDefinition, context: FeatureFlagContext) -> FeatureFlagValue {
        let rules = definition.rules.sorted { $0.priority < $1.priority }

        for rule in rules where matches(rule.condition, context: context, key: definition.key) {
            return rule.value
        }

        return definition.defaultValue
    }

    private func matches(_ condition: FeatureFlagCondition, context: FeatureFlagContext, key: String) -> Bool {
        switch condition {
        case .always:
            return true

        case .userIDIn(let ids):
            guard let userID = context.userID else { return false }
            return ids.contains(userID)

        case .appVersionAtLeast(let minimumVersion):
            guard let currentVersion = context.appVersion else { return false }
            return compareVersions(currentVersion, minimumVersion) != .orderedAscending

        case .percentageRollout(let percentage):
            guard percentage > 0 else { return false }
            guard percentage < 100 else { return true }
            guard let userID = context.userID else { return false }

            return stableBucket(seed: "\(key):\(userID)") < percentage

        case .attributeEquals(let key, let value):
            return context.attributes[key] == value
        }
    }

    private func compareVersions(_ lhs: String, _ rhs: String) -> ComparisonResult {
        let left = lhs.split(separator: ".").compactMap { Int($0) }
        let right = rhs.split(separator: ".").compactMap { Int($0) }
        let total = max(left.count, right.count)

        for index in 0..<total {
            let l = index < left.count ? left[index] : 0
            let r = index < right.count ? right[index] : 0

            if l < r { return .orderedAscending }
            if l > r { return .orderedDescending }
        }

        return .orderedSame
    }

    private func stableBucket(seed: String) -> Int {
        var hash: UInt64 = 14_695_981_039_346_656_037

        for byte in seed.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1_099_511_628_211
        }

        return Int(hash % 100)
    }
}
