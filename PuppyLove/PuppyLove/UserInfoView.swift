//
//  UserInfoView.swift
//  PuppyLove
//
//  Created by Reagan Green on 3/18/23.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreLocation
import Amplify

struct UserInfoView: View {
    @StateObject var user: User
    @StateObject var dog: Dog
    @StateObject var locationDataManager = LocationDataManager()
    @EnvironmentObject var vm: UserAuthModel
    
    var sexOptions = ["Male", "Female", "Non-binary"]
    @State var selectedSex = "Male"
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var userPhoto: Data? = nil
    
    @State var date = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1900, month: 1, day: 1)
        let endComponents = DateComponents(year: 2004, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    func grabLocation() {
        switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                user.Location = String((locationDataManager.locationManager.location?.coordinate.latitude.description ?? "0.0") + ", " + (locationDataManager.locationManager.location?.coordinate.longitude.description ?? "0.0"))
                print(user.Location)
                break
            
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                break
            
            case .notDetermined:        // Authorization not determined yet.
                break
            
            default:
                break
        }
    }
    
    func uploadImage() async throws {
        if userPhoto != nil {
            let userPhotoData: Data! = userPhoto ?? nil
            let imageKey: String = "\(vm.emailAddress)"
            let profileImage = UIImage(data: userPhotoData)!
            let profileImageData = profileImage.jpegData(compressionQuality: 1)!
            
            let uploadTask = Amplify.Storage.uploadData(
                    key: imageKey,
                    data: profileImageData
                )
                Task {
                    for await progress in await uploadTask.progress {
                        print("Progress: \(progress)")
                    }
                }
                let value = try await uploadTask.value
                print("Completed: \(value)")
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Name").foregroundColor(.white)) {
                    TextField("Name", text: $user.OwnerName)
                    
                }.padding()
                
                Section(header: Text("Birthday").foregroundColor(.white)) {
                    DatePicker(
                        "Select Date",
                        selection: $date,
                        in: dateRange,
                        displayedComponents: .date
                    )
                }.padding()
                
                Section(header: Text("Profile Picture").foregroundColor(.white)) {
                    HStack {
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    userPhoto = data
                                }
                            }
                        }
                        Spacer()
                        if let userPhoto,
                           let image = UIImage(data: userPhoto) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                            }
                    }
                }.padding()
                
                Section(header: Text("Gender").foregroundColor(.white)) {
                    HStack {
                        Picker("Select Gender", selection: $selectedSex) {
                            ForEach(sexOptions, id: \.self, content: { sex in
                                Text(sex)
                            })
                        }
                        .pickerStyle(.segmented)
                    }
                }.padding()
            }
            .background(Color(red: 0.784, green: 0.635, blue: 0.784))
            .foregroundColor(.orange)
            .scrollContentBackground(.hidden)
            .tint(.orange)
            
            NavigationLink(destination: UserPreferencesView(user: user, dog: dog).onAppear {
                grabLocation()
                user.Sex = selectedSex
                user.calculateAge(birthday: date)
                Task {
                    try await uploadImage()
                }
            }, label: { Text("Next").foregroundColor(.black) })

        }
        .navigationBarTitle(Text("User Information"))
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        return UserInfoView(
            user: User(OwnerID: 0, OwnerName: "", OwnerEmail: "", Age: 0, MinAge: 0, MaxAge: 0, Sex: "", SexPreference: "", Location: "", MaxDistance: 0),
            dog: Dog(DogID: 0, OwnerID: 0, DogName: "", Breed: "", Weight: 0, Age: "", Sex: "", ActivityLevel: 0, VaccinationStatus: false, FixedStatus: false, BreedPreference: "none", AdditionalInfo: "", Email: "")
        )
    }
}
