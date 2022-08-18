//
//  HeyuApp.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 09/08/22.
//

import SwiftUI


@main
struct HeyuApp: App {
    
    @StateObject var viewRouter: ViewRouter = .init()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.currentPage {
                case .login:
                    LoginView()
                case .createContent:
                    ContentView()
                case .home:
                    Home()
                }
            }
            .environmentObject(viewRouter)
        }
    }
}
