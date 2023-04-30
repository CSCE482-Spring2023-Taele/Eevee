//
//  HeaderBanner.swift
//  PuppyLove
//
//  Created by Truitt Millican on 4/9/23.
//

import SwiftUI

struct Header: View {
    @EnvironmentObject var vm: UserAuthModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(red: 0.784, green: 0.635, blue: 0.784, opacity: 0.8))
                .edgesIgnoringSafeArea(.top)
                .frame(height: 50)
            Image("cr7")
                .frame(width:200, height: 200)
                .clipShape(Circle() )
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 5)
        }
    }
}
