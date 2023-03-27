//
//  Categories.swift
//  PuppyLove
//
//  Created by Irving Salinas on 3/16/23.
//

import SwiftUI

struct Categories: View {
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        CategoryRow(geometry: geometry, categoryNameLeft: "Business", categoryNameRight: "Science")
                        CategoryRow(geometry: geometry, categoryNameLeft: "Sports", categoryNameRight: "Opinion")
                        CategoryRow(geometry: geometry, categoryNameLeft: "Finance", categoryNameRight: "Politics")
                        CategoryRow(geometry: geometry, categoryNameLeft: "Health", categoryNameRight: "Arts")
                    }
                    .padding()
                }
                .navigationBarTitle("Categories")
                .navigationBarHidden(true)
            }
        }
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories()
    }
}

struct CategoryCard: View {
    let geometry: GeometryProxy
    let categoryName: String

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(categoryName.lowercased())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width*0.45, height:geometry.size.width*0.55 )
                Text(categoryName)
                           .font(.headline)
                           .foregroundColor(Color.white)
                           .padding(12)
                   }
                   .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
        
}
            



struct CategoryRow: View {
    let geometry: GeometryProxy
    let categoryNameLeft: String
    let categoryNameRight: String

    var body: some View {
        HStack {
            NavigationLink(destination:Category(categoryName: categoryNameLeft)){
                CategoryCard(geometry: geometry,categoryName: categoryNameLeft) // Pass geometry to CategoryCard
            }
            NavigationLink(destination:Category(categoryName: categoryNameRight)){
                CategoryCard(geometry: geometry,categoryName: categoryNameRight)
            }
                        
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Category: View {
    let categoryName: String
    var body: some View {
        VStack {
            Text("")
        }
        .navigationBarTitle(categoryName)
    }
}
