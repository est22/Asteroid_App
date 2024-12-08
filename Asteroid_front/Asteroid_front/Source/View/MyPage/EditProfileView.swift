import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditProfileViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @FocusState private var nicknameFieldIsFocused: Bool
    
    init(profileViewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(profileViewModel: profileViewModel))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                profileImageSection
                    .padding(.top, 40) // 프로필 이미지 위에 여백 추가
                
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
                            if !profileViewModel.isNicknameChecked {
                                await profileViewModel.checkNicknameAvailability(viewModel.nickname)
                            }
                            
                            if profileViewModel.isNicknameAvailable && !viewModel.isMottoExceeded {
                                do {
                                    try await viewModel.updateProfile()
                                    dismiss()
                                } catch {
                                    print("프로필 업데이트 실패: \(error)")
                                }
                            }
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.isMottoExceeded)
                }
            }
        }
    }
    
    // MARK: - View Components
    private var profileImageSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            profileImageView
        }
        .onChange(of: selectedItem, perform: handleImageSelection)
    }
    
    private var profileImageView: some View {
        ZStack {
            if let profileImage = viewModel.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
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
            .foregroundColor(.white)
            .background(Circle().fill(Color.keyColor))
            .offset(x: 40, y: 40)
    }
    
    private var nicknameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.nickname,
                placeholder: "닉네임",
                isError: !profileViewModel.profileErrorMessage.isEmpty
            )
            .focused($nicknameFieldIsFocused)
            .onChange(of: viewModel.nickname) { _ in
                profileViewModel.isNicknameChecked = false
                profileViewModel.isNicknameAvailable = false
                profileViewModel.profileErrorMessage = ""
            }
            
            if !profileViewModel.profileErrorMessage.isEmpty {
                Text(profileViewModel.profileErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 4)
            } else if profileViewModel.isNicknameChecked && profileViewModel.isNicknameAvailable {
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
                viewModel.validateMotto(newValue)
            }
            
            HStack {
                Spacer()
                Text("\(viewModel.motto.count)/30")
                    .font(.caption)
                    .foregroundColor(viewModel.isMottoExceeded ? .red : .gray)
            }
        }
    }
    
    private func handleImageSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                viewModel.profileImage = Image(uiImage: uiImage)
                
                if let compressedData = uiImage.jpegData(compressionQuality: 0.7) {
                    await profileViewModel.uploadProfilePhoto(imageData: compressedData)
                }
            }
        }
    }
}

#Preview("프로필 수정 화면") {
    let profileViewModel = ProfileViewModel()
    // 프리뷰용 더미 데이터 설정
    profileViewModel.nickname = "테스트 닉네임"
    profileViewModel.motto = "테스트 좌우명"
    
    return NavigationView {
        EditProfileView(profileViewModel: profileViewModel)
            .environmentObject(profileViewModel)
    }
} 
