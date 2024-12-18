import SwiftUI
import UIKit

struct ChallengeImagesGrid: View {
    let challengeImages: [ChallengeImage]
    let showPhotoUpload: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showReportView: Bool
    @State private var selectedImageId: Int? // for report
    @State private var showingActionSheet = false
    @State private var showingCamera = false
    @Binding var selectedImage: UIImage?  // @State를 @Binding으로 변경
    @State private var isUploading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showUploadConfirmation = false
    @State private var uploadedImages: [ChallengeImage] = []  // 유저가 방금 업로드한 챌린지 이미지(유저 피드백을 위한 프론트에서의 처리)
    @State private var hasUploadedToday: Bool = false
    @State private var hasJustUploaded: Bool = false  // 새로운 상태 변수 추가

    // 챌린지 사진 업로드 관련(구조체의 프로퍼티로 정의해야 ChallengeDetailView에서 해당 값들을 전달 가능)
    let challengeId: Int
    @ObservedObject var viewModel: ChallengeViewModel
    
    var onRefresh: () -> Void
    
    private let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()
    
    private func checkTodayUpload() {
        Task {
            do {
                hasUploadedToday = try await viewModel.checkTodayUpload(challengeId: challengeId)
            } catch {
                print("오늘 업로드 확인 실패:", error)
            }
        }
    }
    
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
                // 1. 카메라 버튼을 항상 첫 번째로
                if showPhotoUpload {
                    ZStack {
                        Button(action: {
                            if !hasUploadedToday {
                                showingActionSheet = true
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                                
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24))
                            }
                        }
                        .disabled(hasUploadedToday)
                        
                        // 오늘 업로드 완료 시 오버레이
                        if hasUploadedToday {
                            Rectangle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                                .overlay(
                                    Text("오늘 참여 완료")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(
                            title: Text("사진 선택"),
                            buttons: [
                                .default(Text("카메라로 촬영")) {
                                    showingCamera = true
                                },
                                .default(Text("앨범에서 선택")) {
                                    showingImagePicker = true
                                },
                                .cancel(Text("취소"))
                            ]
                        )
                    }
                    .sheet(isPresented: $showingCamera) {
                        ImagePicker(image: $selectedImage, isPresented: $showingCamera, sourceType: .camera)
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $selectedImage, isPresented: $showingImagePicker, sourceType: .photoLibrary)
                    }
                    .onChange(of: selectedImage) { newImage in
                        print("🔍 onChange triggered - selectedImage changed")
                        if newImage != nil && !showUploadConfirmation && !isUploading && !hasUploadedToday && !hasJustUploaded {
                            print("📱 Setting showUploadConfirmation to true")
                            showUploadConfirmation = true
                            checkTodayUpload()
                        }
                    }
                    .alert("사진 업로드", isPresented: $showUploadConfirmation) {
                        Button("취소") {
                            selectedImage = nil
                        }
                        Button("확인") {
                            // 이미지 검사 중일 때 애니메이션 표시
                            if let image = selectedImage {
                                Task {
                                    do {
                                        print("🚀 Upload started")
                                        
                                        
                                        isUploading = true
                                        hasJustUploaded = true
                                        showUploadConfirmation = false
                                        
                                        let responseString = try await viewModel.uploadChallengeImage(challengeId: challengeId, image: image)
                                        if let data = responseString.data(using: .utf8),
                                           let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                           let message = jsonResponse["message"] as? String {
                                            
                                            if message.contains("챌린지 인증 이미지가 업로드되었습니다") {
                                                print("✅ Upload successful")
                                                
                                                // 진행 상황만 업데이트
                                                await viewModel.fetchChallengeProgress(challengeId: challengeId)
                                                
                                                // 이미지는 그대로 유지
                                                await MainActor.run {
                                                    withAnimation {
                                                        hasUploadedToday = true  // 오늘 업로드 완료 상태로 변경
                                                    }
                                                }
                                                
                                                isUploading = false
                                            } else {
                                                // 부적절한 이미지에 대한 메시지 처리
                                                print("❌ 부적절한 이미지: \(message)")
                                                errorMessage = message
                                                showError = true
                                                selectedImage = nil // 부적절한 이미지일 경우 선택된 이미지 초기화
                                            }
                                        }
                                    } catch {
                                        print("❌ Upload failed: \(error)")
                                        isUploading = false
                                        hasJustUploaded = false
                                    }
                                }
                            }
                        }
                    } message: {
                        Text("선택한 사진으로 오늘 챌린지를 인증할까요?")
                    }
                }
                
                // 2. 선택된 이미지를 카메라 버튼 다음에 표시
                if let image = selectedImage {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                            .clipped()
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.3)),
                        removal: .opacity.combined(with: .scale(scale: 0.3))
                    ))
                }
                
                // 3. 기존 이미지들
                ForEach(challengeImages.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: challengeImages[index].imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            SkeletonView(
                                startColor: Color.keyColor.opacity(0.1),
                                middleColor: Color.keyColor.opacity(0.2),
                                endColor: Color.keyColor.opacity(0.1)
                            )
                            .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 4 - 8, height: UIScreen.main.bounds.width / 4 - 8)
                                .clipped()
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.3)),
                                    removal: .opacity.combined(with: .scale(scale: 0.3))
                                ))
                                .contextMenu(menuItems: {
                                    if showPhotoUpload {  // 참여중일 때만 신고하기 버튼 표시
                                        Button(role: .destructive, action: {
                                            print("=== 신고하기 버튼 클릭 ===")
                                            print("선택된 이미지 ID:", challengeImages[index].id)
                                            print("이미지 업로더 ID:", challengeImages[index].userId)
                                            selectedImageId = challengeImages[index].id
                                            showReportView.toggle()
                                            
                                            // .sensoryFeedback은 iOS 17 이상에서만 사용 가능해서 대체
                                            // 3D 터치 햅틱 (Haptic Feedback) - UIKit의 것을 사용
                                            let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
                                            impactGenerator.impactOccurred()
                                            showReportView = true
                                        }) {
                                            Label("신고하기", systemImage: "exclamationmark.bubble.fill")
                                        }
                                    }
                                })

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
        .alert("🤔", isPresented: $showError) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onReceive(viewModel.$selectedChallenge) { _ in
            if !showUploadConfirmation {  // 조건 추가
                print("🔄 Challenge detail updated, resetting selectedImage")
                selectedImage = nil
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 초기화
            selectedImage = nil
        }
        .sheet(isPresented: $showReportView) {
            ReportView(targetType: "L", targetId: selectedImageId ?? 0)
                .onAppear {
                    print("\n=== 신고하기 뷰 열림 ===")
                    print("전달되는 파라미터:")
                    print("- Target Type: L")
                    print("- Target ID:", selectedImageId ?? 0)
                }
        }
        .onAppear {
            checkTodayUpload()
            // 뷰가 나타날 때 초기화
            selectedImage = nil
        }
    }

}

// ChallengeImage 모델 확장
extension ChallengeImage {
    var localImage: UIImage? { // 로컬 이미지를 저장하기 위한 프로퍼티
        get { objc_getAssociatedObject(self, &localImageKey) as? UIImage }
        set { objc_setAssociatedObject(self, &localImageKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

private var localImageKey: UInt8 = 0  // Associated Object를 위한 키

extension View {
    func debug(_ message: String) -> some View {
        print(message)
        return self
    }
}

// UIImage Extension 추가
extension UIImage {
    func preparingForUpload() -> UIImage {
        let maxSize: CGFloat = 1024
        let scale = min(maxSize/size.width, maxSize/size.height, 1)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return resized
    }
}
