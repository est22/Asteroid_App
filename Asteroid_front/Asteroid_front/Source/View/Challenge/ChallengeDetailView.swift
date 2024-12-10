//
//  ChallengeDetailView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/6/24.
//

import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let challengeId: Int
    let challengeName: String
    @ObservedObject var viewModel: ChallengeViewModel
    @State private var showProgress: Bool = false
    @State private var showPhotoUpload: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var challengeImages: [String] = []
    @State private var currentPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var hasMoreData: Bool = true
    
    let itemsPerPage: Int = 20
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
//                    Text(challengeName)
//                        .font(.system(size: 22, weight: .bold))
                    
                    // 회색 배경 영역
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.systemGray6))
                            .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 16) {
                            Text("\(viewModel.selectedChallenge?.description ?? "")")
                                .font(.system(size: 14))
                            Text("챌린지 기간: \(viewModel.selectedChallenge?.period ?? 0)일")
                                .font(.system(size: 16, weight:.heavy))
                                .foregroundColor(.keyColor)
                            
                            AsyncImage(url: URL(string: viewModel.selectedChallenge?.rewardImageUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 140, height: 140)
                            }
                            
                            Text("챌린지 달성 시 \(viewModel.selectedChallenge?.rewardName ?? "")을 받아요")
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Text("참여중인 유저")
                                    .font(.system(size: 14))
                                Text("\(viewModel.selectedChallenge?.participantCount ?? 0)")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 14, weight: .bold))
                                Text("명")
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(16)
                    }
                    .padding(.horizontal, -10) // 회색 영역이 화면 가득 차게 설정
                    
                    // Progress Bar (조건부 표시)
                    if showProgress {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("내 진행 상황")
                                .font(.system(size: 15, weight: .bold))
                            HStack{
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .foregroundColor(.gray.opacity(0.2))
                                            .frame(height: 8)
                                        
                                        Rectangle()
                                            .foregroundColor(.orange)
                                            .frame(width: geometry.size.width * 0.6, height: 8)
                                    }
                                    .cornerRadius(4)
                                }
                                .frame(height: 8)
                                
                                Text("60%")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 12, weight: .bold))
                            }
                            
                            
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // showProgress 조건문 밖으로 이동
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
                                AsyncImage(url: URL(string: challengeImages[index])) { phase in
                                    switch phase {
                                    case .empty:
                                        // 로딩 중
                                        SkeletonView(
                                            startColor: Color.keyColor.opacity(0.1),
                                            middleColor: Color.keyColor.opacity(0.2),
                                            endColor: Color.keyColor.opacity(0.1)
                                        )
                                    case .success(let image):
                                        // 성공적으로 로드
                                        image
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                    case .failure(_):
                                        // 로드 실패
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
                        .onAppear {
                            loadMoreContent()
                        }
                        .onChange(of: challengeImages.count) { _ in
                            // 스크롤이 끝에 도달했는지 확인
                            if !isLoading && hasMoreData {
                                loadMoreContent()
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 0) // 네비게이션 바 아래 영역
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
            // 챌린지 이름 네비바에 표시
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
                        
                        // 참여하기 API 호출 후 상세 정보 다시 불러오기
                        Task {
                            await viewModel.participateInChallenge(id: challengeId)
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
            ImagePicker(image: $selectedImage, isPresented: $showingImagePicker)
        }
        .task {
            await viewModel.fetchChallengeDetail(id: challengeId)
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
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
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
            .navigationTitle("챌린지 인")
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
            challengeName: "3일 동안 현금만 사용하기",
            viewModel: ChallengeViewModel()
        )
    }
}




extension ChallengeViewModel {
    func participateInChallenge(id: Int) async {
        guard let url = URL(string: "\(APIConstants.baseURL)/challenge/\(id)/participate") else { return }
        
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // 토큰 추가
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Participate API Response Status: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Successfully participated in challenge")
                } else {
                    print("Failed to participate: \(httpResponse.statusCode)")
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
            
        } catch {
            print("Error participating in challenge: \(error)")
        }
    }
    

    
    func fetchChallengeImages(challengeId: Int, page: Int, limit: Int) async throws -> ChallengeImagesResponse {
        guard let url = URL(string: "\(APIConstants.baseURL)/challenge/\(challengeId)/images?page=\(page)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 토큰 추가
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ChallengeImagesResponse.self, from: data)
    }
}


