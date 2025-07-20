//
//  LocationManager.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import CoreLocation

public final class LocationManager: NSObject, CLLocationManagerDelegate {
    @MainActor public static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public var isLocationEnabled: Bool {
        return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    public func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    public func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    public func getCurrentAddress(location: CLLocation) async throws -> String? {
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
