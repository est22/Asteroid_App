## ER Diagram
<!-- Mermaid Diagram Start -->

```mermaid
erDiagram
    User {
        int id PK
        string email
        string password
        string nickname
        string profile_picture
        string motto
        int reported_count
        char(1) status
        string device_token
        string apple_id
        string kakao_id
        string google_id
        string naver_id
    }

    Challenge {
        int id PK
        int period
        string name
        string description
        string reward_name
        string reward_image_url
        char(1) status
    }

    Post {
        int id PK
        string title
        string content
        datetime createdAt
        int category_id FK
        int user_id FK
        bool isShow
        int likeTotal

        %% Unique constraint: user_id, title, and content must be unique together
    }

    ChallengeImage {
        int id PK
        string image_url
        int user_id FK
        int challenge_id FK
    }

    Comment {
        int id PK
        string content
        int user_id FK
        int post_id FK
        int parent_comment_id FK
        int likeTotal
        bool isShow
    }

    Like {
      int id PK
      int user_id FK
      char(1) target_type 
      int target_id

     %% target_type : P(post), C(comment)
     %% Unique constraint: user_id, target_type, target_id
    }

    ChallengeParticipation {
        int id PK
        int user_id FK
        int challenge_id FK
        string status
        datetime start_date
        datetime end_date
        int challenge_reported_count
    }

    Message {
        int id PK
        string content
        int sender_user_id FK
        int receiver_user_id FK
        boolean is_read
    }

    PostImage {
        int id PK
        string image_url
        int post_id FK
    }

    Report {
        int id PK
        char(1) target_type
        int target_id
        int target_user_id FK
        int reporting_user_id FK
        string report_reason
        smallint report_type

        %% target_type : P(post), C(comment), U(user), L(chaLLenge)
        %% target_user_id : ID of the user who got reported
        %% reporting_user_id : ID of the user who reported
        %% report_type: 0 - 9 
        %% report_reason : Reason for the report (when the report_type is 9(others) )
        %% Unique constraint: "target_user_id","target_type", "target_id", "report_type"
    }

    Reward {
        int id PK
        int challenge_id FK
        int user_id FK
        int reward_count
        int credit
    }

    BalanceVote {
        int id PK
        string title
        string description
        int user_id FK
        string image1 
        string image2
        int vote1_count
        int vote2_count
        bool isShow
    }

    MessageRoom {
        int id PK
        int user1_id FK
        int user2_id FK
        datetime user1_left_at
        datetime user2_left_at
    }

    %% Relationships
    User ||--o| Report: "reported"
    User ||--o| Post: "creates"
    User ||--o| Like: "uploads"
    User ||--o| BalanceVote: "creates"
    User ||--o| Comment: "writes"
    User ||--o| ChallengeParticipation: "participates"
    User ||--o| Reward: "receives"
    User ||--o| ChallengeImage: "uploads"

    Challenge ||--o| ChallengeParticipation: "includes"
    Challenge ||--o| ChallengeImage: "has"
    Challenge ||--|| Reward: "gives"

    ChallengeParticipation ||--|| Reward: "gets"

    Post ||--o| Comment: "has"
    Post ||--o| PostImage: "has"
    Post ||--o| Like: "gets"

    Comment ||--o| Like: "gets"

    Message |o--o| User: "messages"
    MessageRoom |o--o| User: "messages"

    Report |o--|| User: "is reported from"
    Report |o--|| Post: "is reported from"
    Report |o--|| Comment: "is reported from"
