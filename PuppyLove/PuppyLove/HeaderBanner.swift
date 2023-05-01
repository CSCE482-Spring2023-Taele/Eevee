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
            if let data = vm.profilePhoto, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
            }
        }
    }
}
