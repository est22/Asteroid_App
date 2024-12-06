import Foundation

struct NotificationModel: Identifiable {
    let id: Int
    let title: String
    let message: String
    let timeAgo: String
    var isRead: Bool
} 