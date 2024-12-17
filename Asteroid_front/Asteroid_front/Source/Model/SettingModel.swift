import Foundation

struct MyPosts: Codable {
    let posts: [Post]
    let balanceVotes: [BalanceVote]
}

struct MyComment: Codable {
    let id:Int
    let postId:Int
    let postTitle:String
    let content:String
    let createdAt:String
}
