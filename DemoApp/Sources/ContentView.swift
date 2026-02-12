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
                Section("Local Rule") {
                    statusRow(title: "new_home (vip_1)", value: viewModel.localNewHomeEnabled)
                }

                Section("Remote Rule") {
                    statusRow(title: "chat_streaming", value: viewModel.remoteStreamingEnabled)
                    statusRow(title: "new_paywall", value: viewModel.remotePaywallEnabled)
                }
            }
            .navigationTitle("Feature Flags Demo")
            .task {
                await viewModel.loadDemoData()
            }
        }
    }

    private func statusRow(title: String, value: Bool) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value ? "ON" : "OFF")
                .fontWeight(.semibold)
                .foregroundStyle(value ? .green : .secondary)
        }
    }
}

#Preview {
    ContentView()
}
