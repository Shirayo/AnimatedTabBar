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
    case description
}


struct LocationFormatter: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState var focuse: LocationFormatterFocuse?
    @State var isMapOpened = false
    
    @State var name: String = ""
    @State var description: String = ""
    @State var scrollPosition = 0
    
    @State var images: [UIImage] = []
    @State var isPickerOpened = false
    @State var isCategoryPickerOpened = false
    
    @State var categorySelection: String = ""
    @State var ratingSelection: String = ""
    
    var categories = ["Hookah", "Bar", "karaoke"]
    var ratings = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5"]
    private var axes: Axis.Set {
        return []
    }
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
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
                    ScrollViewReader { proxy in
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .leading) {
                                if name == "" {
                                    HStack {
                                        Text("Введите название...")
                                            .font(.system(size: 32))
                                            .foregroundColor(Color("slateGray"))
                                            .padding(.leading, 4)
                                        Spacer()
                                    }.frame(height: 56)
                                }
                                TextEditor(text: $name)
                                    .focused($focuse, equals: .name)
                                    .font(.system(size: 32))
                                    .frame(minHeight: 56, maxHeight: 120)
                                    .id(1)
                            }.padding(.horizontal)
                            
                            Text("Фото локации")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 24)
                                .padding(.horizontal)
                            
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
                                    }
                                }.padding(.vertical, 24)
                                    .padding(.horizontal)
                            }
                            
                            Text("Описание локации")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                HStack {
                                    Menu {
                                        Picker(
                                            selection: $categorySelection,
                                            label: Text(""),
                                            content: {
                                                ForEach(categories, id: \.self) { item in
                                                    Text("\(item)")
                                                        .tag("\(item)")
                                                }
                                            }
                                        ).labelsHidden()
                                            .pickerStyle(InlinePickerStyle())
                                    } label: {
                                        HStack {
                                            Text(categorySelection != "" ? categorySelection : "Categories" )
                                                .foregroundColor(categorySelection != "" ? Color("lightSilver") : Color("slateGray"))
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color("slateGray"))
                                        }
                                        .padding(.leading, 24)
                                        .padding(.trailing, 20)
                                    }
                                    
                                    
                                }.frame(height: 56)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(Color("slateGray"), lineWidth: 2)
                                    )
                                
                                HStack {
                                    Menu {
                                        Picker(
                                            selection: $ratingSelection,
                                            label: Text(""),
                                            content: {
                                                ForEach(ratings, id: \.self) { item in
                                                    Text("\(item)")
                                                        .tag("\(item)")
                                                }
                                            }
                                        ).labelsHidden()
                                            .pickerStyle(InlinePickerStyle())
                                    } label: {
                                        HStack {
                                            Text(ratingSelection != "" ? ratingSelection : "Rating" )
                                                .foregroundColor(ratingSelection != "" ? Color("lightSilver") : Color("slateGray"))
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color("slateGray"))
                                        }
                                        .padding(.leading, 24)
                                        .padding(.trailing, 20)
                                    }
                                    
                                    
                                }.frame(height: 56)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(Color("slateGray"), lineWidth: 2)
                                    )
                            }
                                .padding(.top, 16)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("ул. Гикало, 5")
                                    .foregroundColor(Color("lightSilver"))
                                Spacer()
                                Button {
                                    isMapOpened = true
                                } label: {
                                    Text("Указать на карте")
                                        .foregroundColor(Color("Selected"))
                                        .font(.system(size: 12))
                                }
                                
                            }
                            .padding(.leading, 24)
                            .padding(.trailing, 20)
                            .frame(height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color("slateGray"), lineWidth: 2)
                            )
                            .padding(.top, 16)
                            .padding(.horizontal)
                            
                            ZStack(alignment: .topLeading) {
                                if description == "" {
                                    Text("Description")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("slateGray"))
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                                TextEditor(text: $description)
                                    .focused($focuse, equals: .description)
                                    .font(.system(size: 16))
                                    .frame(minHeight: 128, maxHeight: 300)
                                    .id(2)
                                    .onTapGesture {
                                        scrollPosition = 2
                                    }
                            }
                            .padding(.top)
                            .padding(.leading, 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color("slateGray"), lineWidth: 2)
                            )
                            .padding(.top)
                            .padding(.horizontal)
                            
                        }
                        Button {
                            print("save")
                        } label: {
                            Text("Save")
                                .foregroundColor(.white)
                                .padding()
                        }.frame(width: 343, height: 48)
                            .background(Color("Selected"))
                                .cornerRadius(24)
                                .padding(.top, 40)
                                .padding(.horizontal, 16)

                        .onChange(of: scrollPosition, perform: { newValue in
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: newValue == 2 ? .center: .top)
                            }
                        })
                        .padding(.bottom)
                    }
                }
//                .fullScreenCover(isPresented: $isMapOpened) {
//                    ViewThree(isMapOpened: <#T##arg#>)
//                }
                
            }
        }.onTapGesture {
            focuse = nil
            scrollPosition = 0
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
