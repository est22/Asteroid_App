//
//  ChallengeDetailView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI
import PhotosUI

struct ChallengeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let challengeId: Int
    let challengeName: String
    @ObservedObject var viewModel: ChallengeViewModel
    @State private var showProgress: Bool = false
    @State private var showPhotoUpload: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var challengeImages: [ChallengeImage] = [] 
    @State private var currentPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var hasMoreData: Bool = true
    @State private var showReportView: Bool = false
    @State private var isParticipating: Bool = false
    
    let itemsPerPage: Int = 20
    
    var body: some View {

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ChallengeInfoSection(viewModel: viewModel)
                    if showProgress {
                        ProgressSection(viewModel: viewModel)
                    }
                    ChallengeImagesGrid(
                        challengeImages: challengeImages,
                        showPhotoUpload: showPhotoUpload,
                        showingImagePicker: $showingImagePicker,
                        showReportView: $showReportView,
                        selectedImage: $selectedImage, 
                        challengeId: challengeId,
                        viewModel: viewModel,
                        onRefresh: {
                            Task {
                                print("새로고침 시작")
                                await viewModel.fetchChallengeDetail(id: challengeId)
                                print("새로고침 완료")
                            }
                        }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 0) // 네비게이션 바 아래 영역
            }
            .refreshable {
                // 새로고침 시 실행될 코드
                Task {
                    // 챌린지 상세 정보 새로고침
                    await viewModel.fetchChallengeDetail(id: challengeId)
                    
                    // 이미지 그리드 새로고침
                    currentPage = 1  // 페이지 초기화
                    hasMoreData = true
                    challengeImages.removeAll()  // 기존 이미지 제거
                    await loadMoreContent()  // 새로운 이미지 로드
                }
            }
            .onAppear {
//                print("=== View appeared ===")
                loadMoreContent()  // 뷰가 나타날 때 첫 페이지 로드
                Task {
                    await viewModel.fetchParticipatingChallenges()
                    
                    // MainActor에서 UI 업데이트
                    await MainActor.run {
                        if viewModel.isParticipatingIn(challengeId: challengeId) {
                            showProgress = true
                            showPhotoUpload = true
                            
                        }
                    }
                }
            }
            .onChange(of: challengeImages.count) { _ in
//                print("=== Images count changed ===")
                // 스크롤이 끝에 도달했는지 확인
                if !isLoading && hasMoreData {
                    loadMoreContent()
                }
            }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.keyColor)
            },
            trailing: EmptyView()
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(challengeName)
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .overlay(
            VStack {
                Spacer()
                if !showProgress {
                    Button(action: {
                        withAnimation(.spring()) {
                            showProgress = true
                        }
                        
                        Task {
                            await viewModel.participateInChallenge(id: challengeId)
                            
                            DispatchQueue.main.async {
                                viewModel.incrementParticipantCount()
                            }
                            await viewModel.fetchChallengeDetail(id: challengeId)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring()) {
                                showPhotoUpload = true
                            }
                        }
                    }) {
                        Text("나도 참여하기")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        )
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage, isPresented: $showingImagePicker, sourceType: .photoLibrary)
        }
        .task {
            await viewModel.fetchChallengeDetail(id: challengeId)
            await viewModel.fetchParticipatingChallenges()
            isParticipating = viewModel.isParticipatingIn(challengeId: challengeId)
            
            if viewModel.isParticipatingIn(challengeId: challengeId) {
                withAnimation(.spring()) {
                    showProgress = true
                    showPhotoUpload = true
                }
            }
            if viewModel.isParticipatingIn(challengeId: challengeId) {
                await viewModel.fetchChallengeProgress(challengeId: challengeId)
            }
        }
        .onChange(of: viewModel.isParticipating) { newValue in
            isParticipating = viewModel.isParticipatingIn(challengeId: challengeId)
        }
        .task {
            print("\n=== 이미지 업로드 후 진행률 업데이트 ===")
            if viewModel.isParticipatingIn(challengeId: challengeId) {
                print("진행률 조회 시작...")
                await viewModel.fetchChallengeProgress(challengeId: challengeId)
                print("진행률 조회 완료")
            } else {
                print("참여 중이 아닌 챌린지")
            }
        }
    }
    
    private func loadMoreContent() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        // API 호출
        Task {
            do {
                let response = try await viewModel.fetchChallengeImages(
                    challengeId: challengeId,
                    page: currentPage,
                    limit: itemsPerPage
                )
                
                await MainActor.run {
                    // 응답으로 받은 이미지 데이터를 ChallengeImage 모델로 변환하여 추가
                    challengeImages.append(contentsOf: response.images)
                    currentPage += 1  // 다음 페이지를 위해 증가
                    hasMoreData = currentPage <= response.totalPages // 우변이 참면 true, 거짓이면 false
                    isLoading = false
                }
            } catch {
                print("Error loading images: \(error)")
                isLoading = false
            }
        }
    }
}



// ImagePicker 구조체 추가
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    let sourceType: ImagePickerSourceType
    
    enum ImagePickerSourceType {
        case camera
        case photoLibrary
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        switch sourceType {
        case .camera:
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .camera
            return picker
            
        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // UIImagePickerController delegate (for camera)
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
        
        // PHPickerViewController delegate (for photo library)
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                parent.isPresented = false
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.parent.image = image
                        }
                        self?.parent.isPresented = false
                    }
                }
            }
        }
    }
}

struct ChallengePhotoUploadView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
            .navigationTitle("챌린지 인증")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("취소") {
                    dismiss()
                },
                trailing: Button("업로드") {
                    // 사진 업로드 로직
                    dismiss()
                }
                .disabled(selectedImage == nil)
            )
        }
    }
}

#Preview {
    NavigationView {
        ChallengeDetailView(
            challengeId: 1,
            challengeName: "3일 동안 현금 사용하기",
            viewModel: ChallengeViewModel()
        )
    }
}


