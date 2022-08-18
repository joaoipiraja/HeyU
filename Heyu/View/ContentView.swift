//
//  ContentView.swift
//  Heyu
//
//  Created by João Victor Ipirajá de Alencar on 09/08/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias SourceType = UIImagePickerController.SourceType

    let sourceType: SourceType
    let completionHandler: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.sourceType = sourceType
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completionHandler: (UIImage?) -> Void
        
        init(completionHandler: @escaping (UIImage?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image: UIImage? = {
                if let image = info[.editedImage] as? UIImage {
                    return image
                }
                return info[.originalImage] as? UIImage
            }()
            completionHandler(image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completionHandler(nil)
        }
    }
}


struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var posts: [Post] = []
    @State var imageSelected: UIImage?
    @State var showImagePicker:Bool = false
    @State private var textEditor: String = ""
    @State private var isSended: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        
        VStack{
                    
            if !isLoading{
                
            
            Button {
                showImagePicker = true
            } label: {
                
                if let image = imageSelected{
                    Image(uiImage: image).resizable().aspectRatio(2.0, contentMode: .fill)
                }else{
                    Text("Abrir Image picker")
                }
               
            }
            
            TextEditor(text: $textEditor).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                isSended = true
                isLoading = true
                
            }) {
                Text("Bordered")
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            
            }else{
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                ).progressViewStyle(CircularProgressViewStyle())
            }

            
        }.task(id: isSended) {
            
            if isSended{
                if !textEditor .isEmpty {
                    if let image = imageSelected{
                        print(await API.createPost(imageData: image.pngData(), content: textEditor))
                    }else{
                        print(await API.createPost(content: textEditor))
                    }
                }
                viewRouter.currentPage = .home
            }
        }
        
        .sheet(isPresented: $showImagePicker){
            ImagePicker(sourceType: .photoLibrary) { image in
                
               imageSelected = image
               showImagePicker = false
               
                
            }
        }.padding(50)
       
        
//        ZStack{
//            if isLoaded{
//                VStack{
//                    Text(posts[1].content ?? "")
//                        .padding()
//                }
//            }
//
//
//        }.task{
//            posts = await API.getPosts()
//            isLoaded = true
//        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
