import Foundation
import SwiftUI
import Combine

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        // API 호출로 대체될 예정
        notifications = [
            NotificationModel(id: 1, title: "새로운 챌린지", message: "12월 절약 챌린지가 시작되었습니다!", timeAgo: "방금 전", isRead: false),
            NotificationModel(id: 2, title: "댓글 알림", message: "회원님의 게시글에 새로운 댓글이 달렸습니다.", timeAgo: "1시간 전", isRead: false),
            NotificationModel(id: 3, title: "밸런스 투표", message: "참여하신 투표의 결과가 나왔습니다!", timeAgo: "2시간 전", isRead: true)
        ]
    }
    
    func markAllAsRead() {
        notifications = notifications.map { notification in
            var updatedNotification = notification
            updatedNotification.isRead = true
            return updatedNotification
        }
    }
} 