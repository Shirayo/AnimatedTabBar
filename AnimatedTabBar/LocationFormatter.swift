//
//  LocationFormatter.swift
//  AnimatedTabBar
//
//  Created by Vasili on 31.05.22.
//

import SwiftUI
import PhotosUI

enum LocationFormatterFocuse {
    case name
}

struct LocationFormatter: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState var focuse: LocationFormatterFocuse?
    @State var name: String = ""
    @State var images: [UIImage] = []
    @State var isPickerOpened = false
    @State var categorySelection = "1"
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack() {
            Color("LocationFormatterBackground").ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Color("slateGray")
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(10)
                        }.frame(width: 32, height: 32)
                            .cornerRadius(8)
                        
                        
                    }
                    Spacer()
                    Text("Добавить новую локацию")
                    Spacer()
                    Spacer().frame(width: 32, height: 32)
                }.padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .leading) {
                            if name == "" {
                                HStack {
                                    Text("Введите название...")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color("slateGray"))
                                    Spacer()
                                }.frame(height: 56)
                            }
                            TextEditor(text: $name)
                                .focused($focuse, equals: .name)
                                .font(.system(size: 32))
                                .frame(minHeight: 56, maxHeight: 120)
                        }
                        Text("Фото локации")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(.top, 24)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Button {
                                    isPickerOpened = true
                                } label: {
                                    Image("AddImages")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color("slateGray"))
                                    .frame(width: 160, height: 160)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color("slateGray"), lineWidth: 2)
                                        )
                                }
                                
                                ForEach(images, id: \.self) { img in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                        Button {
                                                    
                                        } label: {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(8)
                                                .foregroundColor(.black)
                                        }
                                        .background(Color("lightSilver").opacity(0.6))
                                        .frame(width: 24, height: 24)
                                        .cornerRadius(12)
                                        .padding(8)
                                    }
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(12)
//                                    .clipped()
                                }
                            }.padding(.vertical, 24)
                        }
                        HStack {
                            Picker(
                                selection: $categorySelection,
                                label: Text(""),
                                content: {
                                    ForEach(0..<15) { item in
                                        Text("\(item)")
                                            .tag("\(item)")
                                    }
                                }
                            ).frame(width: 164, height: 56)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color("slateGray"), lineWidth: 2)
                                )
                            Picker(
                                selection: $categorySelection,
                                label: Text("category"),
                                content: {
                                    ForEach(0..<15) { item in
                                        Text("\(item)")
                                            .foregroundColor(Color("slateGray"))
                                            .tag("\(item)")
                                    }
                                }
                            )
                            .frame(width: 164, height: 56)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color("slateGray"), lineWidth: 2)
                                )
                        }
                        
                    }
                }.padding()
                .sheet(isPresented: $isPickerOpened) {
                    ImagePicker(images: $images, picker: $isPickerOpened)
                }
            }
            
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
   
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            parent.picker.toggle()
            
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { image, err in
                        guard let image = image else {
                            print("ERROR!!!!: \(err)")
                            return
                        }
                        print("loading")
                        self.parent.images.append(image as! UIImage)
                    }
                } else {
                    print("woopsie")
                }
            }
        }
    }
}

struct LocationFormatter_Previews: PreviewProvider {
    static var previews: some View {
        LocationFormatter()
    }
}
