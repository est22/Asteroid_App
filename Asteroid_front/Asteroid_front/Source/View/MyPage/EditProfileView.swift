import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var nickname: String
    @State private var motto: String
    @State private var isLoading = false
    
    init(currentNickname: String, currentMotto: String) {
        _nickname = State(initialValue: currentNickname)
        _motto = State(initialValue: currentMotto)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 프로필 이미지 선택
                PhotosPicker(selection: $selectedItem) {
                    ZStack {
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.keyColor))
                            .offset(x: 40, y: 40)
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileImage = Image(uiImage: uiImage)
                            await viewModel.uploadProfilePhoto(imageData: data)
                        }
                    }
                }
                
                // 닉네임 입력
                VStack(alignment: .leading, spacing: 4) {
                    ClearableTextField(text: $nickname, placeholder: "닉네임", isError: !viewModel.profileErrorMessage.isEmpty)
                    
                    if !viewModel.profileErrorMessage.isEmpty {
                        Text(viewModel.profileErrorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // 소비좌우명 입력
                VStack(alignment: .leading, spacing: 4) {
                    ClearableTextField(text: $motto, placeholder: "소비좌우명", isError: false)
                        .onChange(of: motto) { newValue in
                            if newValue.count > 30 {
                                motto = String(newValue.prefix(30))
                            }
                        }
                    
                    HStack {
                        Spacer()
                        Text("\(motto.count)/30")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
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
                            isLoading = true
                            await viewModel.updateProfile(nickname: nickname, motto: motto)
                            isLoading = false
                            dismiss()
                        }
                    }
                    .disabled(isLoading)
                }
            }
        }
    }
} 