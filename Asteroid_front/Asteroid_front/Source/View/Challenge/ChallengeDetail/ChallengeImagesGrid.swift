import SwiftUI

struct ChallengeImagesGrid: View {
    let challengeImages: [ChallengeImage]
    let showPhotoUpload: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showReportView: Bool
    @State private var selectedImageId: Int?
    
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
                                        showReportView.toggle()
                                    }) {
                                        Label("신고하기", systemImage: "exclamationmark.bubble.fill")
                                    }
                                }
                                .sensoryFeedback(.impact(weight: .medium), trigger: true) // 3D 터치 햅틱
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
        .sheet(isPresented: $showReportView) {
            if let imageId = selectedImageId {
                let _ = print("\n=== 신고하기 뷰 열림 ===")
                let _ = print("전달되는 파라미터:")
                let _ = print("- Target Type: L")
                let _ = print("- Target ID:", imageId)
                
                ReportView(targetType: "L", targetId: imageId)
            }
        }
    }
} 
