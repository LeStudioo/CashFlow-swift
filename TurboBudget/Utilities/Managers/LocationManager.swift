//
//  LocationManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var isLocationEnabled: Bool {
        return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func getCurrentAddress(location: CLLocation) async throws -> String? {        
        let geocoder = CLGeocoder()
        var addressString: String = ""
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        if let pm = placemarks.first {
            if let subLocality = pm.subLocality {
                addressString = addressString + subLocality + ", "
            }
            if let locality = pm.locality {
                addressString = addressString + locality + ", "
            }
            if let country = pm.country {
                addressString = addressString + country + ", "
            }
            if let postalCode = pm.postalCode {
                addressString += postalCode
            }
        }
        
        return addressString
    }

}
