//
//  ViewOne.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct ViewOne: View {
    var body: some View {
        ZStack() {
//            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Color("GradientBottom").ignoresSafeArea()
            Text("ViewOne").foregroundColor(.white)
        }
    }
}

struct ViewOne_Previews: PreviewProvider {
    static var previews: some View {
        ViewOne()
    }
}
