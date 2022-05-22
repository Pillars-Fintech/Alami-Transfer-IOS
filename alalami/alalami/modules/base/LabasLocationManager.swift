//
//  LabasLocationManager.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum LocationServiceState {
    case notEnabled
    case denied
    case allowed
}

protocol LabasLocationManagerDelegate {
    func labasLocationManager(didUpdateLocation location:CLLocation)
    func didChangeAuthorization()
}

class LabasLocationManager: NSObject {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var defaultLocation = CLLocation(latitude: 24.774265, longitude: 46.738586)
    var delegate: LabasLocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.allowsBackgroundLocationUpdates = false
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    static let shared : LabasLocationManager = {
        let instance = LabasLocationManager()
        return instance
    }()
    
    func getLocationServiceState() -> LocationServiceState {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            }
        } else {
            return .notEnabled
        }
    }
    
    func openLocationSettings() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    func openAppLocationSetting() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    func startUpdatingLocation() {
        self.locationManager!.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager!.stopUpdatingLocation()
    }
}


extension LabasLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        delegate?.labasLocationManager(didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            delegate?.didChangeAuthorization()
        }
    }
}
