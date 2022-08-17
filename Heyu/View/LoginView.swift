//
//  LoginView.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 16/08/22.
//

import SwiftUI
import AuthenticationServices
import Foundation

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

struct LoginView: View {
    
    @State private var text: String = ""
    @State private var password: String = ""
    @State private var modelSignUp: LoginModel?
    @State private var modelSignIn: LoginModel?
    @State private var isFinished:Bool = true
    @KeychainStorage("Token") var token


    func configure(_ request: ASAuthorizationOpenIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    
    
    func handle(_ authResult: Result<ASAuthorization, Error>){
        switch authResult{
        case .success(let auth):
            isFinished = false
            print(auth)
            switch auth.credential{
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let loginModel = LoginModel(credentials: appleIdCredentials){
                   if let loginModelData = try? JSONEncoder().encode(loginModel){
                        UserDefaults.standard.setValue(loginModelData, forKey: appleIdCredentials.user)
                       modelSignUp = loginModel
                       print(loginModel)
                    }
                }else{
                    guard let loginModelData = UserDefaults.standard.data(forKey: appleIdCredentials.user), let loginModel = try? JSONDecoder().decode(LoginModel.self, from: loginModelData) else{ return }
                    
                    modelSignIn = loginModel

                }
                
                
              
            break
           

            default:
                print(auth.credential)
            }
        case .failure(let error):
            print(error)
        }
        
    }
    
    var body: some View {
        ZStack{
            
            if isFinished{
                
                SignInWithAppleButton(.signIn,
                    onRequest: configure, onCompletion: handle).signInWithAppleButtonStyle(.black).frame(width: 200, height: 44, alignment: .center)
               
            }else{
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                ).progressViewStyle(CircularProgressViewStyle())
            }
           
            
        }
        .task(id: modelSignIn) {
            
            if let modelSignIn = modelSignIn {
                
                if let token = await API.loginUser(model: modelSignIn) {
                    self.token = token
                    
                }
                
                isFinished = true
            }
            
        }
        .task(id: modelSignUp) {
            
            
            if let modelSignUp = self.modelSignUp{
                
                if let token = await API.createUser(model:  modelSignUp){
                    self.token = token
                }
                
                isFinished = true
            }
            
           
            
            
        }
            
            
//            TextField("Email", text: $text)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
//            Button {
//                print("teste")
//            } label: {
//                Text("Log In")
//            }

    
        
    
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}