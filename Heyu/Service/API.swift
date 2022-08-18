//
//  API.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 09/08/22.
//

import Foundation
import SwiftUI

struct API{
    
    static let domain = "http://adaspace.local/"
    @KeychainStorage("Token") static var mockToken
    
    
    static func setLike(postId: String) async{
        
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/likes")!)
        
        urlRequest.setValue( "Bearer \(mockToken)", forHTTPHeaderField: "Authorization")
        
        print("setLikes -> \(mockToken)")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                   let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                   if case (200..<300) = statusCode{
                       print("Deu certo - setLike")
                   }
                 // handle the response here
               }.resume()
               
        
    }
    
    static func getLikes(postId: String) async -> [User] {
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/likes/liking_users/\(postId)")!)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let usersDecoded = try JSONDecoder().decode([User].self, from: data)
            return usersDecoded
        } catch {
            print(error)
        }
        return []
    }
    
    static func getUser(userId: String) async -> User? {
        
        print("getUser -> \(mockToken)")
        
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/users/\(userId)")!)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let userDecoded = try JSONDecoder().decode(User.self, from: data)
            return userDecoded
        } catch {
            print(error)
        }
        return nil
    }
    
    static func loginUser(model: LoginModel) async -> String?{
        //print(model)
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/users/login")!)
        urlRequest.httpMethod = "POST"

        let loginString = "\(model.email):\(model.password)".data(using: .utf8)!.base64EncodedString()

        urlRequest.setValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")

        do {
            
            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    return responseJSON["token"] as? String ?? nil
                }
                
            
        } catch {
            print(error)
        }
        
        return nil

    }
    
    static func createUser(model: LoginModel) async -> String? {
        var urlRequest = URLRequest(url: URL(string: API.domain + "users")!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(model)
           } catch let error {
               print(error.localizedDescription)
           }
        
        
        do {
            
            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    return responseJSON["token"] as? String ?? nil
                    
                }
                
            
        } catch {
            print(error)
        }
        
        return nil
    }
    
    
//    static func giveLike(from postId: String){
//        
//    }
//    static func getLikes(from postId: String){
//        var urlRequest = URLRequest(url: URL(string: API.domain + "ikes/liking_users/"+ postId)!)
//        urlRequest.setValue( "Bearer \(mockToken)", forHTTPHeaderField: "Authorization")
//
//    }
    
    static func getPosts() async -> [Post] {
        
        var urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)
        
        
//        urlRequest.allHTTPHeaderFields = [
//            "x-api-key": "5cffc6c8-0e59-497e-a9ef-d1b266411e9c"
//        ]
        
      print("getPosts -> \(mockToken)")
        

        do {
            
            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let postsDecoded = try JSONDecoder().decode([Post].self, from: data)
            return postsDecoded
        } catch {
            print(error)
        }
        return []
    }
    
    static func createPost(imageData:Data? = nil, content:String) async{
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        print("createPost -> \(mockToken)")
        
        var urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue( "Bearer \(mockToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()
        
        httpBody.appendString(convertFormField(named: "content", value: content, using: boundary))
        
        if let imageData = imageData {
            httpBody.append(convertFileData(fieldName: "media",
                                            fileName: "imagename.png",
                                            mimeType: "image/png",
                                            fileData: imageData,
                                            using: boundary))
        }
        

        httpBody.appendString("--\(boundary)--")

        urlRequest.httpBody = httpBody as Data
        
//        if let imageData = imageData {
//            let task = URLSession.shared.uploadTask(with: urlRequest, from: imageData)
//        }
        

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                   let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                   if case (200..<300) = statusCode{
                       print("Deu certo - Create Post")
                   }else{
                       print("Deu errado - Create Post")
                       print(String(data: data!, encoding: .utf8)!)
                   }
                 // handle the response here
               }.resume()
               
        
    }
    
    
}

extension API{
    
    static func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
