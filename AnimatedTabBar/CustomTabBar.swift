//
//  CustomTabBar.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: String
    @Binding var isAddButtonPressed: Bool
    var tabs = ["home", "search", "add", "map", "settings"]
    
    var body: some View {
        HStack(alignment: .center ,spacing: 0) {
            ForEach(tabs, id: \.self) { tabImage in
                ZStack(alignment: .center) {
                    TabBarButton(image: tabImage, selectedTab: $selectedTab, isAddButtonPressed: $isAddButtonPressed)
                    Spacer()
                        .frame(width: 6, height: 6)
                        .background(tabImage == selectedTab ? Color("Selected") : .clear)
                        .cornerRadius(3)
                        .offset(y: tabImage == selectedTab ? -22 : 0)
                }
            }
        }
        .frame(height: 64)
        .background(Color("TabBar"))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, UIDevice.isPhoneX ? 0 : 16)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .previewDevice("iPhone 13 Pro")
    }
}

struct TabBarButton: View {
    
    var image: String
    @Binding var selectedTab: String
    @Binding var isAddButtonPressed: Bool
    
    var body: some View {
        Button {
            if image != "add" {
                withAnimation(.easeInOut(duration: 0.1)) {
                    selectedTab = image
                }
            } else {
                isAddButtonPressed = true
            }
        } label: {
            Image(image)
                .resizable()
                .frame(width: image == "add" ? 40 : 28, height: image == "add" ? 40 : 28)
                .foregroundColor(image == selectedTab ? Color("Selected") : Color("TextColor"))
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: 64)
    }
}


