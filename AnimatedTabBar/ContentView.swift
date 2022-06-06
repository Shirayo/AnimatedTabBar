//
//  ContentView.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home().preferredColorScheme(.dark)
//        LocationFormatter()
//        PickPlaceLocation()
//        OnBoardingView()
//        ViewOne()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 Pro")
    }
}
