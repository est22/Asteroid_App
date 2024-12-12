import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @FocusState private var nicknameFieldIsFocused: Bool
    
    // 임시 상태 추가
    @State private var tempNickname: String
    @State private var tempMotto: String
    @State private var tempImage: Image?
    @State private var selectedImageData: Data?
    @State private var showActionSheet = false
    @State private var shouldResetImage: Bool = false  // 기본 이미지로 설정할지 여부
    @State private var isNicknameChecked = false
    @State private var isNicknameAvailable = false
    @State private var isMottoExceeded = false
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _tempNickname = State(initialValue: viewModel.nickname)
        _tempMotto = State(initialValue: viewModel.motto)
        
        // MyPage의 프로필 사진으로 초기화
        if let profileImage = viewModel.profileImage {
            _tempImage = State(initialValue: profileImage)
        } else {
            _tempImage = State(initialValue: Image(systemName: "person.circle.fill"))
        }
    }
    
    private var profileImageSection: some View {
        Button(action: {
            showActionSheet = true
        }) {
            ZStack {
                if shouldResetImage {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))
                } else if let tempImage = tempImage {
                    tempImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                cameraButton
            }
        }
        .confirmationDialog("프로필 사진 변경", isPresented: $showActionSheet) {
            Button("앨범에서 사진 선택하기") {
                showImagePicker = true
            }
            
            Button("기본 이미지로 설정하기", role: .destructive) {
                shouldResetImage = true
                tempImage = Image(systemName: "person.circle.fill")
                selectedImageData = nil
            }
            
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: Binding(
                get: { nil },
                set: { newImage in
                    if let image = newImage {
                        shouldResetImage = false
                        tempImage = Image(uiImage: image)
                        selectedImageData = image.jpegData(compressionQuality: 0.7)
                    }
                }
            ), isPresented: $showImagePicker, sourceType: .photoLibrary)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                profileImageSection
                    .padding(.top, 40)
                
                ProfileFieldsView(
                    nickname: $tempNickname,
                    motto: $tempMotto,
                    isNicknameChecked: $isNicknameChecked,
                    isNicknameAvailable: $isNicknameAvailable,
                    isMottoExceeded: $isMottoExceeded,
                    profileErrorMessage: AuthViewModel.shared.profileErrorMessage,
                    onNicknameCheck: { 
                        AuthViewModel.shared.checkNicknameAvailability(tempNickname) { success in
                            isNicknameChecked = true
                            isNicknameAvailable = success
                        }
                    },
                    currentNickname: viewModel.nickname
                )
                .padding()
                .onDisappear {
                    AuthViewModel.shared.profileErrorMessage = ""  // 뷰가 사라질 때 메시지 초기화
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        AuthViewModel.shared.profileErrorMessage = ""  // 취소 시 메시지 초기화
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        Task {
                            if let imageData = selectedImageData {
                                await viewModel.uploadProfilePhoto(imageData: imageData)
                            } else if !shouldResetImage {
                                // 이미지 관련 작업 스킵
                            } else {
                                try await viewModel.deleteProfilePhoto()
                                viewModel.profileImage = Image(systemName: "person.circle.fill")
                                    viewModel.profilePhoto = nil
                            }
                            
                            try await viewModel.updateProfile(nickname: tempNickname, motto: tempMotto)
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || isMottoExceeded || 
                              // 닉네임이나 모토가 변경되었을 때만 중복 체크 조건 적용
                              ((tempNickname != viewModel.nickname || tempMotto != viewModel.motto) && 
                               (!isNicknameChecked || !isNicknameAvailable)))
                }
            }
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
}

#Preview("프로필 수정 화면") {
    let profileViewModel = ProfileViewModel()
    profileViewModel.nickname = "테스트 닉네임"
    profileViewModel.motto = "테스트 좌우명"
    
    return NavigationView {
        EditProfileView(viewModel: profileViewModel)
    }
} 
