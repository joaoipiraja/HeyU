
import Foundation
import AuthenticationServices

struct LoginModel: Encodable, Decodable, Equatable {
    var email: String
    var password: String
    var name: String
    
    init?(credentials: ASAuthorizationAppleIDCredential){
        
        guard
            let name = credentials.fullName?.givenName,
            let email = credentials.email
        else {
            return nil
        }
        
        self.password = credentials.user
        self.email = email
        self.name = name
        
    }
}
