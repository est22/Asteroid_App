//
//  CompletedChallengeViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/7/24.
//

import Foundation

class CompletedChallengeViewModel: ObservableObject {
    @Published var completedChallenges: [CompletedChallenge] = []
    @Published var message: String?
    @Published var totalPoints: Int = 0
    
    func fetchCompletedChallenges() async {
        guard let url = URL(string: "\(APIConstants.baseURL)/settings/rewards"),
              let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CompletedChallengeResponse.self, from: data)
            
            await MainActor.run {
                if let message = response.message {
                    self.message = message
                    self.completedChallenges = []
                } else if let challenges = response.data {
                    self.completedChallenges = challenges
                    self.totalPoints = challenges.reduce(0) { $0 + ($1.credit ?? 0) }
                }
            }
        } catch {
            print("Error fetching completed challenges: \(error)")
        }
    }
}
