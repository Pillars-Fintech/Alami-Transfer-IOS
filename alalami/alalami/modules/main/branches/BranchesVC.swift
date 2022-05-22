//
//  BranchesVC.swift
//  alalami
//
//  Created by Zaid Khaled on 9/6/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class BranchesVC: BaseVC {
    
    //shortname
    @IBOutlet weak var lblShortName: MyUILabel!
    
    @IBOutlet weak var viewGoogleMap: UIView!
    
    var items = [BranchDatum]()
    var selectedItem : BranchDatum?
    
    var selectedLocation:CLLocation?
    // MARK: Properties
    var markerLocation: GMSMarker?
    var currentZoom: Float = 12
    var gMap = GMSMapView()
    
    var latitude = 0.0
    var longitude = 0.0
    
    var tappedmarker : GMSMarker?
    
    @IBOutlet weak var viewBranchDetails: CardView!
    @IBOutlet weak var viewBranchDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBranchTitle: MyUILabel!
    @IBOutlet weak var lblBranchAddress: MyUILabel!
    @IBOutlet weak var lblDistance: MyUILabel!
    
    
    //notifications
    @IBOutlet weak var cvCount: CardView!
    @IBOutlet weak var lblCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gMap = GMSMapView()
        self.applyMapStyle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotifications), name: NSNotification.Name(rawValue: "notificationsCountShouldRefresh"), object: nil)
    }
    
    
    private func setupMaps() {
        self.latitude = UserDefaults.standard.value(forKey: Constants.LAST_LATITUDE) as? Double ?? 0.0
        self.longitude = UserDefaults.standard.value(forKey: Constants.LAST_LONGITUDE) as? Double ?? 0.0
        
        if (self.latitude == 0.0 || self.longitude == 0.0) {
            self.showLoading()
            LabasLocationManager.shared.delegate = self
            LabasLocationManager.shared.startUpdatingLocation()
        }else {
            self.setUpGoogleMap()
        }
    }
    
    @objc private func refreshNotifications() {
        validateNotificationsCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblShortName.text = getUserShortName()
        validateNotificationsCount()
        setupMaps()
    }
    
    func validateNotificationsCount() {
        let count = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.NOTIFICATION_COUNT) as? Int ?? 0
        if (count > 0) {
            self.cvCount.isHidden = false
            self.lblCount.text = "\(count)"
        }else {
            self.cvCount.isHidden = true
        }
    }
    
    func loadBranches() {
        self.showLoading()
        self.getApiManager().getBranches(token: self.getAccessToken()) { (response) in
            self.hideLoading()
            if (response.success ?? false) {
                self.items.removeAll()
                self.items.append(contentsOf: response.data ?? [BranchDatum]())
                //addmarkers
                self.addMarkers()
            }else {
                self.handleError(code: response.code, message: response.message)
            }
        }
    }
    
    func addMarkers() {
        self.gMap.clear()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title =  ""
        marker.snippet = ""
        marker.icon = UIImage(named: "ic_map_mylocation")
        marker.map = gMap
        
        for center in self.items {
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude: Double(center.latitude ?? "0.0") ?? 0.0, longitude: Double(center.longitude ?? "0.0") ?? 0.0)
            
            marker.title =  center.branchID ?? ""
            marker.snippet = "\(center.name ?? "")"
            
            marker.icon = UIImage(named: "ic_map_branch")
            
            marker.map = gMap
        }
    }
    
    fileprivate func setUpGoogleMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 11.0)
        gMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewGoogleMap.frame.width, height: self.viewGoogleMap.frame.height), camera: camera)
        self.applyMapStyle()
        gMap.delegate = self
        
        
        self.viewGoogleMap.addSubview(gMap)
        gMap.bindFrameToSuperviewBounds()
        self.view.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.loadBranches()
        }
        
    }
    
    func goToMyLocation() {
        switch LabasLocationManager.shared.getLocationServiceState() {
        case .allowed:
            
            let zoomToLocation = GMSCameraPosition.camera(withTarget:  CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), zoom: self.currentZoom)
            self.gMap.animate(to: zoomToLocation)
            
        case .denied:
            self.showAlert(title: "LocationNotEnabled".localized, message: "PleaseEnableLocation".localized, actionTitle: "ok".localized, cancelTitle: "cancel".localized, actionHandler: {
                LabasLocationManager.shared.openAppLocationSetting()
            }) {
                
            }
        case .notEnabled:
            self.showAlert(title: "LocationNotEnabled".localized, message: "PleaseEnableLocation".localized, actionTitle: "ok".localized, cancelTitle: "cancel".localized, actionHandler: {
                LabasLocationManager.shared.openAppLocationSetting()
            }) {
                
            }
        }
    }
    
    func applyMapStyle() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                self.gMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        }catch let err{
            NSLog("One or more of the map styles failed to load. \(err.localizedDescription)")
        }
    }
    
    func selectItem() {
        self.viewBranchDetails.isHidden = false
        self.viewBranchDetailsHeight.constant = 125.0
        
        self.lblBranchTitle.text = self.selectedItem?.name ?? ""
        self.lblBranchAddress.text = self.selectedItem?.address ?? ""
        
        self.lblDistance.text = self.getDistance(fromLatitude: self.latitude, fromLongitude: self.longitude, toLatitude: Double(self.selectedItem?.latitude ?? "0.0") ?? 0.0, toLongitude: Double(self.selectedItem?.longitude ?? "0.0") ?? 0.0)
        
    }
    
    
    @IBAction func goToMyLocationAction(_ sender: Any) {
        goToMyLocation()
    }
    
    @IBAction func getDirectionsAction(_ sender: Any) {
        self.startNavigation(longitude: Double(self.selectedItem?.longitude ?? "0.0") ?? 0.0, latitude: Double(self.selectedItem?.latitude ?? "0.0") ?? 0.0)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        self.openProfileScreen()
    }
    
    
    @IBAction func notificationsAction(_ sender: Any) {
        self.openNotificationsScreen()
    }
    
    @IBAction func closeBranchDetailsAction(_ sender: Any) {
        selectedItem = nil
        self.viewBranchDetails.isHidden = true
        self.viewBranchDetailsHeight.constant = 1
        goToMyLocation()
    }
    
}

extension BranchesVC : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //        mapView.clear()
        //        self.loadCenters()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let id = marker.title ?? "0"
        if (id.contains(find: "my_location")) {
            return true
        }
        
//        self.tappedmarker = marker
//        var point = mapView.projection.point(for: marker.position)
//        point.y = point.y - 120
//        let camera = mapView.projection.coordinate(for: point)
//        let position = GMSCameraUpdate.setTarget(camera)
//        mapView.animate(with: position)
        
        let zoomToLocation = GMSCameraPosition.camera(withTarget:  CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude), zoom: self.currentZoom)
        mapView.animate(to: zoomToLocation)
        
        //load scooter details and show its view
        let strId = id
        if (strId == "") {
            //no scooter
            return true
        }
        
        for branch in self.items {
            if (branch.branchID == strId) {
                self.selectedItem = branch
                self.selectItem()
            }
        }
        //draw directions polyline
        
        return true
    }
    
}


extension BranchesVC: LabasLocationManagerDelegate {
    func labasLocationManager(didUpdateLocation location:CLLocation) {
        
        if let currentLocation = LabasLocationManager.shared.currentLocation {
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            
            UserDefaults.standard.set(latitude, forKey: Constants.LAST_LATITUDE)
            UserDefaults.standard.set(longitude, forKey: Constants.LAST_LONGITUDE)
            
            self.latitude = latitude
            self.longitude = longitude
            
            let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: currentZoom, bearing: 3, viewingAngle: 0)
            self.gMap.animate(to: camera)
            
            LabasLocationManager.shared.stopUpdatingLocation()
        }
        
    }
    
    func didChangeAuthorization() {
        self.hideLoading()
        self.setUpGoogleMap()
    }
    
}
