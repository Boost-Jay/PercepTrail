//
//  ProgressIndicatorViewWrapper.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/24/24.
//

import SwiftUI
import ProgressIndicatorView

// MARK: - ProgressData

class ProgressData: ObservableObject {
    @Published var progress: CGFloat = 0.0
}

// MARK: - ProgressIndicatorViewWrapper

struct ProgressIndicatorViewWrapper: View {
    @ObservedObject var progressData: ProgressData

    var body: some View {
        ProgressIndicatorView(isVisible: .constant(true), type: .bar(progress: $progressData.progress, backgroundColor: .gray.opacity(0.25)))
            .frame(height: 8.0)
    }
}

// MARK: - CustomProgressIndicatorView

struct CustomProgressIndicatorView: View {
    @Binding var progress: CGFloat
    var backgroundColor: Color = .gray
    var foregroundColor: Color = .red

    var body: some View {
        ProgressIndicatorView(isVisible: .constant(true), type: .bar(progress: $progress, backgroundColor: backgroundColor))
            .frame(height: 8.0)
            .background(foregroundColor.opacity(0.5))
    }
}
