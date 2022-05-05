//
//  Home.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct Home: View {
    
    @State var selectedTab = "home"
    @State var isAddButtonPressed = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ViewOne()
                    .tag("home")
                ViewTwo()
                    .tag("search")
                ViewThree()
                    .tag("map")
                ViewFour()
                    .tag("settings")
            }
            CustomTabBar(selectedTab: $selectedTab, isAddButtonPressed: $isAddButtonPressed)
                
            .fullScreenCover(isPresented: $isAddButtonPressed) {
                Button {
                    print(UIDevice.isPhoneX)
                    isAddButtonPressed = false
                } label: {
                    Text("Add Button pressed")
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .previewDevice("iPhone 13 Pro")
    }
}
