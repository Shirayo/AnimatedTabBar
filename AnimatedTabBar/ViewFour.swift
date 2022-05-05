//
//  ViewFour.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI

struct ViewFour: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Text("ViewFour").foregroundColor(.white)
        }
    }
}

struct ViewFour_Previews: PreviewProvider {
    static var previews: some View {
        ViewFour()
    }
}
