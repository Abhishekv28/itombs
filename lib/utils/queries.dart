class Queries {
  static const String login = """
      mutation generateAccessToken(\$email: String!, \$password: String!){
        generateAccessToken(
          data:{
            email:\$email
            password:\$password
          }
        ),
        {
          token
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink    
            
          }
        }
      }
    """;

  static const String register = """
      mutation addUser(\$email: String!, \$name: String!, \$photo: ID!, \$password: String!){
        addUser(
          data:{
            email:\$email
            name: \$name
            photo: \$photo
            password:\$password
          }
        ),
        {
          token
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink    
            
          }
        }
      }
    """;

  static const String fileUpload = """
    mutation uploadAsset(
      \$file: Upload!
    ){
      uploadAsset(file:\$file){
        id
        url
        status
        type
        size
        path
      }
    }
  """;

  static const String socialSign = """
    mutation addUserBySocial(\$provider: LoginProvider!,\$email: String!, \$name: String!,\$token: String!,){
      addUserBySocial(
        data:{
          provider:\$provider,
          token:\$token,
          email:\$email,
          name:\$name
        }
      ){
        token
        user{
          id      
          name
          email
          phone
          photo
          bio
          qrCodeLink
        }
      }
    }
  """;

  static const String requestResetPassword = """
    mutation requestResetPassword(\$email: String!){
      requestResetPassword(
        email:\$email
      ){
        status
        code
      }
    }
  """;

  static const String changePassword = """
    mutation changePassword(\$email: String!,\$newPassword: String!,\$code: String!){
      changePassword(
        email:\$email
        newPassword:\$newPassword
        verificationCode:\$code
      )
    }
  """;

  static const String changePasswordWithOldPwd = """
    mutation changePassword(\$email: String!,\$password: String!,\$newPassword: String!){
      changePassword(
        email:\$email
        password:\$password
        newPassword:\$newPassword
      )
    }
  """;

  static const String updateProfilePhoto = """
      mutation updateUser(\$photo: ID!){
        updateUser(
          data:{
            photo:\$photo
          }
        ),
        {
          id      
          name
          email
          phone
          photo{
            url
          }
          bio
          qrCodeLink  
        }
      }
    """;

  static const String updateProfile = """
      mutation updateUser(\$name: String!, \$email: String!){
        updateUser(
          data:{
            email:\$email
            name:\$name
          }
        ),
        {
          id      
          name
          email
          phone
          photo{
            url
          }
          bio
          qrCodeLink  
        }
      }
    """;

  static const String getAllItombs = """
    query{
      getAllItembs{
        id
        name
        photo{
          url
        }
        bio
        dob
        dop
        gender
        user
      }
    }
  """;

  static const String getMyItombs = """
    query{
      getItembs{
        id
        name
        photo{
          url
        }
        bio
        dob
        dop
        gender
        user
      }
    }
  """;

  static const String createItomb = """
    mutation addItomb(\$name: String!,\$dob: String!,\$dop: String!,\$bio: String!,\$gender: GenderType!, \$photo: [ID]!){
      addItomb(
        data:{
          name:\$name,
          dob:\$dob,
          dop:\$dop,
          bio: \$bio,
          photo: \$photo,
          gender: \$gender
        }
      ),{
        id
        name
        photo{
          url
        }
        bio
        dob
        dop
        gender
        user
      }
    }
  """;

  static const String updateItomb = """
    mutation updateItomb(\$id: ID!, \$name: String!,\$dob: String!,\$dop: String!,\$bio: String!,\$gender: GenderType!, \$photo: [ID]!){
      updateItomb(
        id: \$id,
        data:{
          name:\$name,
          dob:\$dob,
          dop:\$dop,
          bio: \$bio,
          photo: \$photo,
          gender: \$gender
        }
      ),{
        id
        name
        photo{
          url
        }
        bio
        dob
        dop
        gender
        user
      }
    }
  """;

  static const String getAllUsers = """
      query{
        getAllUsers{
          id      
          name
          email
          phone
          photo{
            url
          }
          bio
          qrCodeLink    
        }
      }
  """;

  static const String getUsersByItomb = """
      query getUsersByItomb(\$id: ID!){
        getUsersByItomb(id:\$id){
          joinStatus
          isApproved
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink 
          }
        }
      }
  """;

  static const String addUsersToItomb = """
      mutation addUsersToItomb(\$itombID: ID!,\$users: [ID]!){
        addUsersToItomb(
          itombID:\$itombID,
          users:\$users
        ){
          joinStatus
          isApproved
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink 
          }
        }
      }
  """;

  static const String removeItombs = """
      query removeItombs(\$ids: [ID]!){
        removeItombs(ids:\$ids)
      }
  """;

  static const String leaveItomb = """
      mutation leaveItomb(\$id: ID!){
        leaveItomb(
          id:\$id
        ){
          id
          joinStatus
          isApproved
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink 
          }
        }
      }
  """;

  static const String removeUsersOfItomb = """
      query removeUsersOfItomb(\$itomb: [ID]!, \$users: [ID]!){
        removeUsersOfItomb(
          itomb:\$itomb,
          users:\$users
        )
      }
  """;

  static const String getVideos = """
      query getVideos(\$target:VideoTargetType!, \$target_id:ID!){
        getVideos(target:\$target, target_id:\$target_id){
          id
          video{
            url
          }
          thumbnail{
            url
          }
          title
          description
          isPrivate
          like_count
          is_liked
        }
      }
  """;

  static const String addVideo = """
      mutation addVideo(\$video: ID!,\$thumbnail: ID!, \$target: VideoTargetType!, \$target_id: ID!, \$title: String!, \$description: String!){
        addVideo(
          data:{
            video: \$video,
            thumbnail: \$thumbnail, 
            target: \$target, 
            target_id: \$target_id, 
            title: \$title, 
            description: \$description
          }
        ),{
          id
          video{
            url
          }
          thumbnail{
            url
          }
          title
          description
          isPrivate
        }
      }
  """;

  static const String getPostsByItomb = """
      query getPostsByItomb(\$id:ID!){
        getPostsByItomb(id:\$id){
          id
          content
          like_count
          is_liked
          photo {
            url
          }
          user{
            id      
            name
            email
            phone
            photo{
              url
            }
            bio
            qrCodeLink 
          }          
        }
      }
  """;

  static const String addPost = """
    mutation addPost(\$content: String!, \$itomb: ID!, \$photo: [ID]!){    
      addPost(
            data:{
              itomb: \$itomb,
              content: \$content
              photo: \$photo
            }
          ),{
            id
            content
            photo{
              url
            } 
            user{
              id      
              name
              email
              phone
              photo{
                url
              }
              bio
              qrCodeLink 
            }        
          }
        }
  """;

  static const String toggleLike = """
    mutation toggleLike(\$tag: LikeTagType!, \$tag_id: String!){    
      toggleLike(
            data:{
              tag: \$tag,
              tag_id: \$tag_id
            }
          ), {
            tag
            tag_id
            likeCount
          }
        }
  """;

  static const String toggledLikeSocket = """
      subscription toggledLike(){
        toggledLike(){
          tag
          tag_id
          likeCount      
        }
      }
  """;

  static const String getChats = """
      query myMessageThreads(\$limit: Int!, \$sort: MessageSortInput!){
        myMessageThreads(){
          id
          name
          unreadMessages
          participants {
            id
            name
            gender
            photo {
              url
            }
          }
          messages(limit: \$limit,sort: \$sort){
            id 
            thread{
              id
            }     
            data
            createdAt
            author {
              id
              name
              photo {
                url
              }
            }
          }          
        }
      }
  """;

  static const String addChat = """
    mutation addMessageThread(\$input: MessageThreadInput!){    
      addMessageThread(
            input: \$input
          ),{
            id
            name
            unreadMessages
            participants {
              id
              name
              gender
              photo {
                url
              }
            }
            messages{
              id
              thread{
                id
              }      
              data
              author {
                id
                name
                photo {
                  url
                }
              }
            }        
          }
        }
  """;

  static const String addChatSocket = """
      subscription messageThreadAdded(){
        messageThreadAdded(){
          id
          name
          unreadMessages
          participants {
            id
            name
            gender
            photo {
              url
            }
          }
          messages{
            id    
            thread{
              id
            }  
            data
            author {
              id
              name
              photo {
                url
              }
            }
          }          
        }
      }
  """;

  static const String getMessages = """
      query messages(\$thread: ID!, \$limit: Int!, \$sort: MessageSortInput!){
        messages(thread: \$thread, limit: \$limit, sort: \$sort){
          id
          thread{
            id
          }
          data
          createdAt         
          author {
            id
            name
            photo {
              url
            }
          }     
        }
      }
  """;

  static const String addMessage = """
    mutation addMessage(\$input: MessageInput!){    
      addMessage(
            input: \$input
          ),{
            id
            thread{
              id
            }
            data
            createdAt         
            author {
              id
              name
              photo {
                url
              }
            }        
          }
        }
  """;

  static const String addMessageSocket = """
      subscription messageAdded(){
        messageAdded(){
          id
          thread{
            id
          }
          data
          createdAt         
          author {
            id
            name
            photo {
              url
            }
          }          
        }
      }
  """;

  static const String addFeedbck = """
    mutation updateFeedback(\$description: String!, \$images: [ID]!){
      updateFeedback(
        data:{
          description:\$description,
          images: \$images
        }
      ),{
        id
        description
        images{
          url
        }
        user {
          id
          name
          photo {
            url
          }
          bio
        }
      }
    }
  """;
}
