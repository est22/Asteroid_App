//
//  NotificationsView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification)
                }
            }
            .listStyle(.inset)
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("모두 읽음") {
                        viewModel.markAllAsRead()
                    }.foregroundColor(.keyColor)
                }
            }
        }
    }
}

struct NotificationCell: View {
    let notification: NotificationModel
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(notification.isRead ? Color.gray.opacity(0.3) : Color.color3)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.system(size: 16, weight: .medium))
                
                Text(notification.message)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(notification.timeAgo)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    
    }
}

#Preview {
    NotificationsView()
}
