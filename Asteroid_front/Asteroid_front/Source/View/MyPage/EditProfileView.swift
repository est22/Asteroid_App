import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @FocusState private var nicknameFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                profileImageSection
                    .padding(.top, 40)
                
                VStack(spacing: 15) {
                    nicknameField
                    mottoField
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        Task {
                            do {
                                try await viewModel.updateProfile(nickname: viewModel.nickname, motto: viewModel.motto)
                                dismiss()
                            } catch {
                                print("프로필 업데이트 실패: \(error)")
                            }
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.isMottoExceeded)
                }
            }
        }
    }
    
    private var profileImageSection: some View {
        Button(action: {
            print("이미지 선택 버튼 탭")
            showImagePicker = true
        }) {
            profileImageView
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, isPresented: $showImagePicker)
        }
        .onChange(of: selectedImage) { newImage in
            print("===== 이미지 선택 감지 =====")
            if let image = newImage {
                print("✅ 새 이미지 선택됨")
                
                // UI 업데이트
                viewModel.profileImage = Image(uiImage: image)
                
                // 이미지 압축 및 업로드
                if let imageData = image.jpegData(compressionQuality: 0.7) {
                    print("📦 압축된 이미지 데이터 크기: \(imageData.count) bytes")
                    Task {
                        await viewModel.uploadProfilePhoto(imageData: imageData)
                    }
                } else {
                    print("❌ 이미지 압축 실패")
                }
            }
            print("===== 이미지 선택 처리 완료 =====\n")
        }
    }
    
    private var profileImageView: some View {
        ZStack {
            if let profileImage = viewModel.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else if let profilePhoto = viewModel.profilePhoto,
                      let url = URL(string: profilePhoto) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray.opacity(0.5))
                
            }
            
            cameraButton
        }
    }
    
    private var cameraButton: some View {
        Image(systemName: "camera.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.keyColor)
            .background(Circle().fill(Color.white))
            .offset(x: 40, y: 40)
    }
    
    private var nicknameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.nickname,
                placeholder: "닉네임",
                isError: !viewModel.profileErrorMessage.isEmpty
            )
            .focused($nicknameFieldIsFocused)
            .onChange(of: viewModel.nickname) { _ in
                viewModel.isNicknameChecked = false
                viewModel.isNicknameAvailable = false
                viewModel.profileErrorMessage = ""
            }
            
            if !viewModel.profileErrorMessage.isEmpty {
                Text(viewModel.profileErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 4)
            } else if viewModel.isNicknameChecked && viewModel.isNicknameAvailable {
                Text("사용 가능한 닉네임입니다.")
                    .foregroundColor(Color(UIColor.systemGreen))
                    .font(.caption)
                    .padding(.leading, 4)
            }
        }
    }
    
    private var mottoField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.motto,
                placeholder: "소비좌우명",
                isError: viewModel.isMottoExceeded
            )
            .offset(x: viewModel.mottoShakeOffset)
            .onChange(of: viewModel.motto) { newValue in
                if newValue.count > 30 {
                    viewModel.motto = String(newValue.prefix(31))
                    viewModel.isMottoExceeded = true
                } else {
                    viewModel.isMottoExceeded = false
                }
            }
            
            HStack {
                Spacer()
                Text("\(viewModel.motto.count)/30")
                    .font(.caption)
                    .foregroundColor(viewModel.isMottoExceeded ? .red : .gray)
            }
        }
    }
}

#Preview("프로필 수정 화면") {
    let profileViewModel = ProfileViewModel()
    profileViewModel.nickname = "테스트 닉네임"
    profileViewModel.motto = "테스트 좌우명"
    
    return NavigationView {
        EditProfileView(viewModel: profileViewModel)
    }
} 
