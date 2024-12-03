const multer = require("multer");
const { BlobServiceClient } = require("@azure/storage-blob");
const { User, PostImage, BalanceVote, ChallengeImage } = require("../models");

const connectionString = process.env.SA_CONNECTION_STRING;
if (!connectionString) {
    console.error("Azure Storage 연결 문자열이 설정되지 않았습니다.");
    throw new Error("Storage configuration missing");
}

// 각 기능별 컨테이너 이름 정의
const containers = {
    profile: "profileimage",
    post: "postimage",
    balanceVote: "balancevoteimage",
    challenge: "challengeimage"
};

// 컨테이너 클라이언트 맵
let containerClients = {};

// 컨테이너 초기화 함수 수정
async function initializeContainers() {
    try {
        const blobServiceClient = BlobServiceClient.fromConnectionString(connectionString);
        
        for (const [key, containerName] of Object.entries(containers)) {
            const containerClient = blobServiceClient.getContainerClient(containerName);
            const exists = await containerClient.exists();
            
            if (!exists) {
                console.log(`Creating container "${containerName}"...`);
                await containerClient.create({
                    access: 'blob'
                });
                console.log(`Container "${containerName}" created`);
            }
            
            containerClients[key] = containerClient;
        }
    } catch (error) {
        console.error("Azure Storage 초기화 에러:", error);
        throw error;
    }
}

initializeContainers().catch(console.error);

const storage = multer.memoryStorage();
const upload = multer({
    storage: storage,
    fileFilter: (req, file, cb) => {
        if (file.mimetype.startsWith("image/")) {
            cb(null, true);
        } else {
            cb(new Error("이미지 파일만 업로드 가능합니다."));
        }
    },
});

const uploadPhotos = (req, res, maxFiles) => {
    return new Promise((resolve, reject) => {
        const uploadMiddleware = maxFiles === 1 
            ? upload.single("images") 
            : upload.array("images", maxFiles);

        uploadMiddleware(req, res, (err) => {
            if (err) {
                reject(err);
                return;
            }

            if (maxFiles === 1) {
                if (!req.file) {
                    reject(new Error("파일이 업로드되지 않았습니다."));
                    return;
                }
                resolve([req.file]);
            } else {
                if (!req.files || req.files.length === 0) {
                    reject(new Error("파일이 업로드되지 않았습니다."));
                    return;
                }
                resolve(req.files);
            }
        });
    });
};

// Azure Blob Storage 업로드 함수 수정
async function uploadToAzure(file, containerType) {
    const containerClient = containerClients[containerType];
    if (!containerClient) {
        throw new Error("유효하지 않은 컨테이너 타입입니다.");
    }

    const blobName = `${Date.now()}-${file.originalname}`;
    const blockBlobClient = containerClient.getBlockBlobClient(blobName);
    
    await blockBlobClient.upload(file.buffer, file.buffer.length, {
        blobHTTPHeaders: { blobContentType: file.mimetype }
    });
    
    return blockBlobClient.url;
}

// Post 이미지 전용 저장 함수
const savePostImagesToDB = async (files, postId, transaction) => {
    try {
        const fileRecords = [];
        
        for (const file of files) {
            // Azure Blob Storage에 업로드하고 URL 받아오기
            const imageUrl = await uploadToAzure(file, "post");
            
            // PostImage 테이블에 이미지 URL 저장
            const postImage = await PostImage.create({
                post_id: postId,
                image_url: imageUrl,
                fileName: file.originalname
            }, { 
                transaction: transaction
            });

            fileRecords.push({ 
                fileName: file.originalname,
                imageUrl: imageUrl
            });
        }

        return fileRecords;
    } catch (error) {
        console.error("DB 저장 에러:", error);
        throw error;
    }
};


const saveFilesToDB = async (files, userId, targetTable, challengeId) => {
    try {
        const fileRecords = [];
        
        for (const file of files) {
            let imageUrl;
            
            // 테이블별로 적절한 컨테이너 선택
            switch (targetTable) {
                case "User":
                    imageUrl = await uploadToAzure(file, "profile");
                    await User.update(
                        { profile_picture: imageUrl },
                        { where: { id: userId } }
                    );
                    break;
                    
                case "PostImage":
                    imageUrl = await uploadToAzure(file, "post");
                    await PostImage.create({
                        post_id: userId,
                        image_url: imageUrl,
                        fileName: file.originalname,
                    });
                    break;
                    
                case "ChallengeImage":
                    imageUrl = await uploadToAzure(file, "challenge");
                    const result = await ChallengeImage.create({
                        image_url: imageUrl,
                        user_id: userId,
                        challenge_id: challengeId,
                    });
                    return result;
            }

            fileRecords.push({
                fileName: file.originalname,
                imageUrl: imageUrl
            });
        }

        return fileRecords;
    } catch (error) {
        console.error("DB 저장 에러:", error);
        throw new Error("파일 저장 실패");
    }
};

module.exports = {
    uploadPhotos,
    saveFilesToDB,
    savePostImagesToDB,
};
