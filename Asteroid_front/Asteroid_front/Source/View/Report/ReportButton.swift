//
//  ReportButton.swift
//  Asteroid_front
//
//  Created by Lia An on 12/7/24.
//

import SwiftUI

struct ReportButton: View {
    @State private var showReportView = false
    let targetType: String
    let targetId: Int
    
    var body: some View {
        Button(action: {
            showReportView.toggle()
        }) {
            Image(systemName: "exclamationmark.bubble.fill")
                .foregroundColor(.red)
                .imageScale(.large)
        }
        .sheet(isPresented: $showReportView) {
            ReportView(targetType: targetType, targetId: targetId)
        }
    }
}

#Preview {
    ReportButton(targetType: "C", targetId: 2)
}
