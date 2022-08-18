
import Foundation


//try JSONDecoder().decode([Post].self, from:data)

struct Post {
    
    
    var content:String?
    var media: URL?
    var likes: [User]
    var userId: String
    var user: User?
    var isLikedByUser: Bool
    var id: String
    var createdAt: Date
    var updatedAt: Date
    
}

extension Post: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Post: Decodable{
    
    
    enum CodingKeys: String, CodingKey {
           case media
           case userId = "user_id"
           case id
           case createdAt = "created_at"
           case updatedAt = "updated_at"
           case content
          
    }
    
    init(from decoder: Decoder) throws{
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        content = try values.decode(String.self, forKey: .content)
        
        if let mediaString = try? values.decode(String.self, forKey: .media) {
            media = URL(string: API.domain + mediaString)
        }

        userId = try values.decode(String.self, forKey: .userId)
        id = try values.decode(String.self, forKey: .id)
        
        let dateFormatter = ISO8601DateFormatter()
        
        let createdAtString = try values.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString)!
        
        let updatedAtString = try values.decode(String.self, forKey: .updatedAt)
        
        updatedAt = dateFormatter.date(from: updatedAtString)!
     
        user = nil
        likes = []
        isLikedByUser = false
        
    }
}

//extension Post: Equatable{
//    static func ==(lhs: Post, rhs: Post) -> Bool{
//        return lhs.id == rhs.id
//    }
//}


