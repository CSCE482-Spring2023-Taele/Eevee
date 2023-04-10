//
//  HeaderBanner.swift
//  PuppyLove
//
//  Created by Truitt Millican on 4/9/23.
//

import SwiftUI

struct Header: View {
    @AppStorage("rValue") var rValue = DefaultSettings.rValue
    @AppStorage("gValue") var gValue = DefaultSettings.gValue
    @AppStorage("bValue") var bValue = DefaultSettings.bValue
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(red: rValue, green: gValue, blue: bValue, opacity: 1.0))
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
