//
//  Home.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 15/08/22.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var posts: [Post] = []
    @State var isReloaded: Bool = false
    
    var body: some View {
        
        ZStack{
            if !posts.isEmpty {
                RefreshableScrollView {
                    ForEach($posts, id: \.self){ $post in
                        PostView(postData: post)
                            .border(.purple)
                            .task {
                                
                                    let user = await API.getUser(userId: post.userId)
                                    let likes = await API.getLikes(postId: post.id)
                                    
                                    post.user = user
                                    post.likes = likes
                                
                                
                
                            }
                    }.padding([.bottom], 50)
                        .padding([.leading, .trailing], 20)
                } onRefresh: {
                    print("OnRefresh")
                    isReloaded.toggle()
                    
                }
            }else{
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                ).progressViewStyle(CircularProgressViewStyle())
            }
        }.task(id: isReloaded) {
                posts = await API.getPosts()
            
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
