//
//  ViewRouter.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 18/08/22.
//

import SwiftUI




enum Page{
    
    case login
    case home
    case createContent
    
}

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .login
    
    
}
