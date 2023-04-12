//
//  LocationManager.swift
//  PuppyLove
//
//  Created by Reagan Green on 4/11/23.
//

import Foundation
import CoreLocation

// Code referenced from https://github.com/coledennis/CoreLocationSwiftUITutorial

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
   var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?

   override init() {
      super.init()
      locationManager.delegate = self
   }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
                case .authorizedWhenInUse:  // Location services are available.
                    // Insert code here of what should happen when Location services are authorized
                    authorizationStatus = .authorizedWhenInUse
                    locationManager.requestLocation()
                    break
                    
                case .restricted: // Location services currently unavailable.
                    // Insert code here of what should happen when Location services are NOT authorized
                    authorizationStatus = .restricted
                    break
                    
                case .denied:  // Location services currently unavailable.
                    // Insert code here of what should happen when Location services are NOT authorized
                    authorizationStatus = .denied
                    break
                    
                case .notDetermined:        // Authorization not determined yet.
                    authorizationStatus = .notDetermined
                    locationManager.requestWhenInUseAuthorization()
                    break
                    
                default:
                    break
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error: \(error.localizedDescription)")
    }
    
}
