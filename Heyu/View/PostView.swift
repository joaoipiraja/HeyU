//
//  PostView.swift
//  InstagramClone
//
//  Created by Dheeraj Kumar Sharma on 02/12/20.
//

import SwiftUI



struct PostView: View {
    // MARK:- PROPERTIES
    @State var postData: Post
    @State private var isLiked: Bool = false
    @State private var isSaved: Bool = false
    @State private var isLikeAnimation: Bool = false
    @State private var isMute: Bool = true
    
      
    func hideAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            isLikeAnimation = false
        }
    }
  
    // MARK:- BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(alignment: .center, spacing: 10){
                
                if let avatar = postData.user?.avatar{
                    AsyncImage(url: avatar) { image in
                        image.resizable().scaledToFill()
                            .frame(width: 33, height: 33, alignment: .center).clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 0.5))
                    } placeholder: {
                        
                        ProgressView().scaledToFill()
                      
                    }
                }
                
               
                Text(postData.user?.name ?? "")
                        .font(Font.system(size: 14, weight: .semibold))
                
              
            
               
            }//: HSTACK
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            
            Divider()
            
            if let media = postData.media{
            
                ZStack(alignment: .center){
                    

                        
                        AsyncImage(url: media) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            
                            ProgressView().scaledToFill()
                            
                        }.onTapGesture(count: 2) {
                            isLiked = !isLiked
                            isLikeAnimation = true
                            hideAnimation()
                        }
                
                    Image("white-heart")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 170)
                        .scaleEffect(isLikeAnimation ? 1 : 0)
                        .opacity(isLikeAnimation ? 1 : 0)
                        .animation(.spring())
                }
            }
            
            HStack(alignment: .center, spacing: 10){
                
                Spacer()
                Button(action:{
                    isLiked = !isLiked
                }){
                    Image(isLiked ? "like-selected" : "like")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30, alignment: .center)
                }
                
               
            }//: HSTACK
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            
                Text("\(postData.likes.count) like\(postData.likes.count > 1 ? "s" : "" )")
                        .font(Font.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 15)
          
            
           
            if let content = postData.content {
                Group {
                
                    Text(content)
                        .font(Font.system(size: 14))
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 6)
            }
            
           
            
        }
        .task(id: isLiked) {
            if(isLiked){
                print("Task Post View")
                await API.setLike(postId: postData.id)
            }
            //
        }
    //: VSTACK
    }
}

// MARK:- PREVIEW

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        let posts = Array(repeating: Post(content: "Teste", media: URL(string: "https://www.contentviewspro.com/wp-content/uploads/2017/07/default_image.png"), likes: [], userId: "", isLikedByUser: false, id: "", createdAt: Date.now, updatedAt: Date.now), count: 20)
        
        
        PostView(postData: posts[0])
            .previewLayout(.sizeThatFits)
    }
}

