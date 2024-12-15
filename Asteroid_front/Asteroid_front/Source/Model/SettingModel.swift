import Foundation

struct MyPosts: Codable {
    let posts: [Post]
    let balanceVotes: [BalanceVote]
}
