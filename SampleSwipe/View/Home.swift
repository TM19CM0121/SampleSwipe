//
//  Home.swift
//  SampleSwipe
//
//  Created by 高良 昌辰 on 2021/02/26.
//

import SwiftUI

struct Home: View {
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    @State var currentPage = 1
    
    var body: some View {
        
        ScrollView(.init()) {
            
            TabView(selection: $currentPage){
                
                GeometryReader {proxy in
                    
                    let screen = proxy.frame(in: .global)
                    
                    let offset = screen.minX
                    let scale = 1 + ( offset / screen.width )
                    
                    TabView(selection: $currentPage) {
                        ForEach(1...5, id: \.self) {index in
                            Image("img\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getRect().width)
                                .cornerRadius(1)
                                .modifier(VerticalTabBarModifier(screen: screen))
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .rotationEffect(.init(degrees: 90))
                    .frame(width: screen.width)
                    .scaleEffect(scale >= 0.88 ? scale : 0.88, anchor: .center)
                    .offset(x: -offset)
                    .blur(radius: ( 1 - scale ) * 20)
                }
                
                DetailView(currentPage: $currentPage)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(Color.black.ignoresSafeArea())
        .ignoresSafeArea()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct DetailView: View {
    
    @Binding var currentPage : Int
    
    var body: some View {
        
        VStack(spacing: 15){
            
            Text("詳細")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top, edges?.top ?? 15)
            
            Image("img\(currentPage)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
                .cornerRadius(20)
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10, content: {
                Text("タイトル")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("撮影者名")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,30)
            
            Button(action: {}, label: {
                
                Text("画像をダウンロードする")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical,10)
                    .frame(maxWidth: .infinity)
                
            })
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 1.5)
            )
            .padding(.vertical)
            
            Button(action: {}, label: {
                Text("不適切な画像として報告する")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.vertical,10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red, lineWidth: 1.5)
                    )
            })
            .padding(.vertical)
            
            Spacer()
            
        }
        .padding()
        .background(Color.gray.ignoresSafeArea())
    }
}

struct VerticalTabBarModifier: ViewModifier {
    var screen: CGRect
    func body(content: Content) -> some View {
        return content
            .frame(width: screen.width, height: screen.height)
            .rotationEffect(.init(degrees: -90))
            .frame(width: screen.height, height: screen.width)
    }
}

var edges = UIApplication.shared.windows.first?.safeAreaInsets
