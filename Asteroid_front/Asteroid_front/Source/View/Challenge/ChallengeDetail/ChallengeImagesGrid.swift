import SwiftUI
import UIKit

struct ChallengeImagesGrid: View {
    let challengeImages: [ChallengeImage]
    let showPhotoUpload: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showReportView: Bool
    @State private var selectedImageId: Int?
    @State private var shouldShowReport: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(" 유저 참여 현황")
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                if showPhotoUpload {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .aspectRatio(1, contentMode: .fit)
                            
                            Image(systemName: "camera.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 24))
                        }
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                ForEach(challengeImages.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: challengeImages[index].imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            SkeletonView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .contextMenu {
                                    Button(role: .destructive, action: {
                                        print("=== 신고하기 버튼 클릭 ===")
                                        print("선택된 이미지 ID:", challengeImages[index].id)
                                        print("이미지 업로더 ID:", challengeImages[index].userId)
                                        selectedImageId = challengeImages[index].id
                                        // .sensoryFeedback은 iOS 17 이상에서만 사용 가능해서 대체
                                        // 3D 터치 햅틱 (Haptic Feedback) - UIKit의 것을 사용
                                        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
                                        impactGenerator.impactOccurred()
                                        shouldShowReport = true
                                    }) {
                                        Label("신고하기", systemImage: "exclamationmark.bubble.fill")
                                    }
                                }
                        case .failure(_):
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .onChange(of: shouldShowReport) { newValue in
            if newValue {
                showReportView = true
                shouldShowReport = false
            }
        }
        .sheet(isPresented: $showReportView) {
            if let imageId = selectedImageId {
                ReportView(targetType: "L", targetId: imageId)
            }
        }
    }
} 
