//
//  UserInfoView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import SwiftUI

struct UserInfoView: View {
    @State private var name = ""
    @State private var bio = ""
    @State var date = Date()
    var genderOptions = ["Male", "Female", "Non-binary"]
    @State var genderOptionTag: Int = 0
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
                
            }.padding()
            
            Section(header: Text("Birthday")) {
                DatePicker(
                    "Select Date",
                    selection: $date,
                    in: dateRange,
                    displayedComponents: .date
                )
            }.padding()
            
            Section(header: Text("Gender")) {
                HStack {
                    Picker("Select Gender", selection: $genderOptionTag) {
                        ForEach(0 ..< genderOptions.count) {
                            Text(self.genderOptions[$0])
                        }
                    }
                }
            }.padding()
            
            Section(header: Text("Bio")) {
                TextField("Tell us about yourself...", text: $bio,  axis: .vertical)
                    .lineLimit(5...10)
            }.padding()
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
