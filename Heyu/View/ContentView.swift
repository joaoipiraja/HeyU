//
//  ContentView.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 09/08/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var posts: [Post] = []
    @State var isLoaded: Bool = false
    
    var body: some View {
        ZStack{
            
            if isLoaded{
                Text(posts[1].content ?? "")
                    .padding()
            }else{
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                ).progressViewStyle(CircularProgressViewStyle())
            }
            
        }.task{
            posts = await API.getPosts()
            isLoaded = true
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
