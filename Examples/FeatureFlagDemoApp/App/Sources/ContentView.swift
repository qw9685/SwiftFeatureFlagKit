//
//  ContentView.swift
//  FeatureFlagDemoApp
//
//  创建于 2026
//  主要功能：
//  - 展示本地与远程规则命中结果
//  - 提供可视化 Demo 页面
//
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DemoViewModel()

    var body: some View {
        NavigationView {
            List {
                Section("使用说明") {
                    Text("1）选择用户、版本、地区  2）点击“重新计算”  3）查看每个开关结果与命中原因")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("上下文") {
                    Picker("用户", selection: $viewModel.selectedUserID) {
                        Text("vip_1").tag("vip_1")
                        Text("vip_2").tag("vip_2")
                        Text("guest_42").tag("guest_42")
                    }

                    Picker("版本", selection: $viewModel.selectedVersion) {
                        Text("2.4.9").tag("2.4.9")
                        Text("2.5.0").tag("2.5.0")
                        Text("2.5.1").tag("2.5.1")
                    }

                    Picker("地区", selection: $viewModel.selectedRegion) {
                        Text("CN").tag("CN")
                        Text("US").tag("US")
                        Text("JP").tag("JP")
                    }

                    Button("重新计算") {
                        Task { await viewModel.evaluate() }
                    }
                }

                Section("开关结果") {
                    statusRow(title: "new_home", value: viewModel.newHomeEnabled, reason: viewModel.newHomeReason)
                    statusRow(title: "chat_streaming", value: viewModel.chatStreamingEnabled, reason: viewModel.chatStreamingReason)
                    statusRow(title: "new_paywall", value: viewModel.newPaywallEnabled, reason: viewModel.newPaywallReason)
                    statusRow(title: "always_on", value: viewModel.alwaysOnEnabled, reason: viewModel.alwaysOnReason)
                    statusRow(title: "cn_only_feature", value: viewModel.cnOnlyEnabled, reason: viewModel.cnOnlyReason)
                }
            }
            .navigationTitle("特性开关示例")
            .task {
                await viewModel.bootstrap()
            }
        }
    }

    private func statusRow(title: String, value: Bool, reason: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(value ? "ON" : "OFF")
                    .fontWeight(.semibold)
                    .foregroundStyle(value ? .green : .secondary)
            }
            Text(reason)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
