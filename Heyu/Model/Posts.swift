
import Foundation


//try JSONDecoder().decode([Post].self, from:data)

struct Post {
    
    
    var content:String?
    var media: URL?
    var likeCount: Int
    var userId: String
    var id: String
    var createdAt: Date
    var updatedAt: Date
    
}

extension Post: Decodable{
    
    
    enum CodingKeys: String, CodingKey {
           case likeCount = "like_count"
           case media
           case userId = "user_id"
           case id
           case createdAt = "created_at"
           case updatedAt = "updated_at"
           case content
          
    }
    
    init(from decoder: Decoder) throws{
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        likeCount = try values.decode(Int.self, forKey: .likeCount)
        
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
        
    }
}

extension Post: Equatable{
    static func ==(lhs: Post, rhs: Post) -> Bool{
        return lhs.id == rhs.id
    }
}


