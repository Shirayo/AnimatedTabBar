//
//  OnBoardingView.swift
//  AnimatedTabBar
//
//  Created by Vasili on 4.05.22.
//

import SwiftUI

struct BoardingInfo {
    var title: String
    var info: String
    var imageName: String
}

struct OnBoardingView: View {
    
    private var views = [
        BoardingInfo(title: "Добро пожаловать!", info: "В самое большое сообщество путешественников и ценителей интересных мест", imageName: "planet"),
        BoardingInfo(title: "Делитесь!", info: "Рассказывайте окружающим об интересных местах и прикрепляйте фото", imageName: "Saly-2"),
        BoardingInfo(title: "Изучайте", info: "Получите доступ к информации об огромном количестве красивых и интересных мест", imageName: "Saly-1"),
        BoardingInfo(title: "Оценивайте", info: "Поделитесь своим мнением о местах и узнайте мнение других", imageName: "Saly-14"),
        BoardingInfo(title: "Пора начинать!", info: "Приветствуем вас в нашем сообществе!", imageName: "Saly-22")
    ]
    
    @State var selectedPage = 0
    
    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(views.indices, id:\.self) { index in
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(views[index].title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 16)
                        Text(views[index].info)
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 16)
                        Image(views[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 36)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                    if index == 4 {
                        Spacer()
                        VStack {
                            Button {
                                print("let's go")
                            } label: {
                                ZStack {
                                    Color("Selected")
                                        .frame(height: 48, alignment: .center)
                                    Text("Начать")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.white)
                                                              
                                }.cornerRadius(24)
                                    .padding(.horizontal, 16)
                            }.onTapGesture {
                                print("change color of button")
                            }
                        }.padding(.bottom, 48)
                    } else {
                        Spacer()
                    }
                }.tag(index)
            }
        }
        .background(LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay (
            HStack(spacing: 8) {
                ForEach(views.indices, id: \.self) { index in
                    Capsule()
                        .fill(selectedPage == index ? Color("Selected") : Color("TextColor"))
                        .frame(width: 8, height: 8)
                        .padding(.vertical, 4)
                }
            }
            .frame(height: 16)
            .padding(.horizontal, 8)
            .background(Color("PageIndicatorBackground"))
            .cornerRadius(8)
            .padding(.vertical, UIDevice.isPhoneX ? 0 : 16)
            ,alignment: .bottom
        )
    }
    
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
            .previewDevice("iPhone 13 Pro")
    }
}
