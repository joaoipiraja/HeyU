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
    
    @State var posts: [Post] = []
    @State var isLoaded: Bool = false
    @State var imageSelected: UIImage?
    @State var showImagePicker:Bool = false
    
    var body: some View {
        
        VStack{
            if let image = imageSelected{
                Image(uiImage: image).resizable().aspectRatio(2.0, contentMode: .fill)
            }
            
            Button {
                showImagePicker = true
            } label: {
                Text("Abrir Image picker")
            }

            
        }.task {
            if let image = imageSelected{
                print("feito s")
                await API.createPost(imageData: image.pngData() , content: "Teste")
            }
            
        }
        
        .sheet(isPresented: $showImagePicker){
            ImagePicker(sourceType: .photoLibrary) { image in
                
               imageSelected = image
               showImagePicker = false
               
                
            }
        }
        
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
