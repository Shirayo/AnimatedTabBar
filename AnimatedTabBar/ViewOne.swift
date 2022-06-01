//
//  ViewOne.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI


enum focusTextField {
    case email
    case password
}

class Credentials: ObservableObject {
    
    @Published var emailText = ""
    @Published var passwordText = ""
}

struct ViewOne: View {
   
    @StateObject var credentals = Credentials()
    @FocusState var activeTextField: focusTextField?
    
    var body: some View {
        NavigationView {
            ZStack() {
                LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        Image("sms")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 20)
                            .foregroundColor(activeTextField == .email ? .red : .gray)
                        TextField("enter email...", text: $credentals.emailText)
                            .focused($activeTextField, equals: .email)
                            .foregroundColor(activeTextField == .email ? .red : .gray)
                    }
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(activeTextField == .email ? .red : .gray, lineWidth: 2)
                    )
                    .padding(.horizontal, 40)
                    
                    HStack(spacing: 8) {
                        Image("sms")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 20)
                            .foregroundColor(activeTextField == .password ? .red : .gray)
                        SecureField("password...", text: $credentals.passwordText)
                            .focused($activeTextField, equals: .password)
                            .foregroundColor(activeTextField == .password ? .red : .gray)
                    }
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(activeTextField == .password ? .red : .gray, lineWidth: 2)
                    )
                    .padding(.horizontal, 40)
                    NavigationLink(destination: ViewOne().navigationBarHidden(true)) {
                        Text("heh").foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct ViewOne_Previews: PreviewProvider {
    static var previews: some View {
        ViewOne()
    }
}
