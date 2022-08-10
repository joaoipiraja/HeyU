import Darwin
import Foundation

struct User{
    var name:String
    var email:String
    var id:String
    var avatar:URL?
    
    enum CodingKeys: String, CodingKey {
           case name
           case email
           case id
           case avatar
    }
}

extension User: Decodable{
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        id = try values.decode(String.self, forKey: .id)
        let avatarString = try values.decode(String.self, forKey: .avatar)
        avatar = URL(string: API.domain + avatarString)
    }
}

extension User:Equatable{
    static func ==(lhs: User, rhs: User) -> Bool{
        return lhs.id == rhs.id
    }
}
