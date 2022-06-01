//
//  ViewTwo.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct ViewTwo: View {
    
    @State var number1: String = ""
    @State var number2: String = ""
    @State var number3: String = ""
    @State var number4: String = ""

    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        print("back")
                    } label: {
                        ZStack {
                            Color("444A7A")
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("lightSilver"))
                            
                        }.frame(width: 32, height: 32)
                            .cornerRadius(8)
                    }
                    Spacer()
                    Text("Введите код").font(.system(size: 24)).foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 32, height: 32)
                }
                .padding()
            }
        }
    }
}

enum FocusedTextField {
    case email
    case phoneNumber
    case password
    case confirmationPassword
    case none
}


struct CustomTextField: View {
    
    // MARK: - Constants
    
    struct Constants {
        static let imageAndTextSpacing = 8.0
        static let imageWidth = 20.0
        static let imageHeight = 20.0
        static let placeholderFontSize = 15.0
        static let fieldCornerRadius = 32.0
        static let borderWidth = 2.0
        static let fieldWidth = 295.0
        static let fieldHeight = 56.0
    }
    
    // MARK: - Properties
    
    @Binding var text: String
    let imageName: String
    let placeholderText: String
    var focusedField: FocusState<FocusedTextField?>.Binding
    var activeTextField: FocusedTextField
    @Binding var hasError: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: Constants.imageAndTextSpacing) {
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .foregroundColor(focusedField.wrappedValue == activeTextField ? Color("lightSilver") : hasError ? .red : Color("slateGray"))
                
                if activeTextField == .password || activeTextField == .confirmationPassword {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText).foregroundColor(Color("slateGray"))
                                .font(.system(size: 40))
                        }
                        .foregroundColor(Color("lightSilver"))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText).foregroundColor(Color("slateGray"))
                                .font(.system(size: 40))
                        }
                        .foregroundColor(Color("lightSilver"))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            }
            .padding()
            .background(hasError ? .red.opacity(0.15) : .clear).cornerRadius(Constants.fieldCornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.fieldCornerRadius)
                    .stroke(focusedField.wrappedValue == activeTextField ? Color("lightSilver") : hasError ? .red : Color("slateGray.name"), lineWidth: Constants.borderWidth)
            }

        }
    }
    
    // MARK: - Methods
    
    static func create(text: Binding<String>,
                       imageName: String,
                       placeholderText: String,
                       focusedField: FocusState<FocusedTextField?>.Binding,
                       activeTextField: FocusedTextField, hasError: Binding<Bool>) -> some View {
        return CustomTextField(text: text,
                               imageName: imageName,
                               placeholderText: placeholderText,
                               focusedField: focusedField,
                               activeTextField: activeTextField, hasError: hasError)
            .frame(width: Constants.fieldWidth, height: Constants.fieldHeight)
            .focused(focusedField, equals: activeTextField)
           
    }
}

struct ViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        ViewTwo()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
