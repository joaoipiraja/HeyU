//
//  Home.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 15/08/22.
//

import SwiftUI

struct Home: View {
    
    @State var posts: [Post] = []
    
    var body: some View {
        
        ScrollView{
            if !posts.isEmpty {
                ForEach($posts, id: \.self){ $post in
                    PostView(postData: post)
                        .border(.purple)
                        .task {
                            let user = await API.getUser(userId: post.userId)
                            let likes = await API.getLikes(postId: post.id)
                            
                            post.user = user
                            post.likes = likes
                            
                        }
                }.padding()
            }else{
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                ).progressViewStyle(CircularProgressViewStyle())
            }
            
        }.task {
            posts = await API.getPosts()
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
