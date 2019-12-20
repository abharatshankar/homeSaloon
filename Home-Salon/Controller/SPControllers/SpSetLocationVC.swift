//
//  SpSetLocationVC.swift
//  HomeSalon
//
//  Created by volive solutions on 25/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class SpSetLocationVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    var checkMapString : String! = ""
    
    var checkMapString2 :String! = ""
    
    
    
    
    @IBOutlet weak var setLocationBtn: UIButton!
   
    @IBOutlet var setServiceLocationStaticLabel: UILabel!
   
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressTV: UITextView!
    
    var checkStr : String?
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
     var city : String! = ""
    
    var currentLocation:CLLocationCoordinate2D!
    
    var latStr : String?
    var langStr :String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showUpdatedValueOnMap(_:)), name: NSNotification.Name(rawValue:"showUpdatedValueOnMap"), object: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 87/255.0, green: 96/255.0, blue: 124/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        isAuthorizedtoGetUserLocation()
        
    }
    
    @objc func showUpdatedValueOnMap(_ notification: NSNotification){
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["lat"] as? String
            longitudeString = dict["lang"] as? String
            addressStr = dict["address"] as? String
            checkMapString2 = dict["map1"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
            print("checkMapString2",checkMapString)
        }
        
        self.addressTV.text = addressStr
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundRefreshHome), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //locationManager delegates
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: "Location Services Disabled!" , message: "Please enable Location Based Services for better results! We promise to keep your location private", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                //google maps
                mapView?.isMyLocationEnabled = true
                
            default:
                locationManager.startUpdatingLocation()
                
            }
        } else {
            print("Location services are not enabled")
        }
        //self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    @objc func willEnterForegroundRefreshHome() {
        
        //Register for
        registerForLocationUpdates()
    }
    func registerForLocationUpdates(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                
                let alertController = UIAlertController(title: "Location Services Disabled!" , message: "Please enable Location Based Services for better results! We promise to keep your location private", preferredStyle: .alert)
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (nil) in
                }
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                
            }
        } else {
            print("Location services are not enabled")
        }
        
    }

    
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_ConfirmLocation(_ sender: UIButton) {
        
        
        checkMapString = "confirm"
        let imageDataDict:[String: String] = ["key": latitudeString,"key1":longitudeString,"key2":self.addressTV.text!,"map":checkMapString,"Currentcity":city]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLocation"), object: nil, userInfo: imageDataDict)
        
        self.navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true) {
        //            print("dismmissed")
        //        }
        
    }
    
    @IBAction func showCurrentLocationAction(_ sender: Any) {
        //latitudeString = ""
        checkMapString2 = ""
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            
        }
        
    }
    
    
    //for map
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView){
        
        let geocoder = GMSGeocoder()
        self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
        self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
        print("wrap lat\(self.latitudeString)")
        print("wrap lang\(self.longitudeString)")
        let latitud = Double(self.latitudeString ?? "") ?? 0.0
        let longitud = Double(self.longitudeString ?? "") ?? 0.0
        let position = CLLocationCoordinate2DMake( latitud, longitud)
        
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                // print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                guard let result = response?.results()?.first else {
                    return
                }
                print("adress of that location is \(result)")
                self.addressStr = result.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                 self.city = result.locality
                
                print("Address Str Is :\(self.addressStr ?? "")")
                
                DispatchQueue.main.async {
                    self.addressTV.text = self.addressStr
                    
                }
            }
        }
        
    }
    
    //MARK:mapview delegate methods
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didchange")
        //called everytime
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        // wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    //MARK:DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        
        
        
        DispatchQueue.main.async {
            if self.checkMapString2 == "map1"{
                if self.latitudeString == ""{
                    print("if check map1 str")
                    print("latitudeString is empty")
                    let userLocation:CLLocation = locations[0] as CLLocation
                    self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
                    let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:self.currentLocation.longitude, zoom: 15)
                    let position = CLLocationCoordinate2D(latitude:  self.currentLocation.latitude, longitude: self.currentLocation.longitude)
                    print(position)
                    DispatchQueue.main.async {
                        
                        self.mapView.camera = camera
                        
                        self.mapView.delegate = self
                        self.mapView.isMyLocationEnabled = true
                        self.mapView.settings.myLocationButton = true
                        self.locationManager.stopUpdatingLocation()
                    }
                    
                }
                    
                else{
                    print("check map str")
                    print("latitudeString is not empty")
                    let latitud = Double(self.latitudeString ?? "") ?? 0.0
                    let longitud = Double(self.longitudeString ?? "") ?? 0.0
                    let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
                    let position = CLLocationCoordinate2D(latitude:  latitud, longitude: longitud)
                    print(position)
                    DispatchQueue.main.async {
                        
                        self.mapView.camera = camera
                        self.mapView.delegate = self
                        self.mapView.isMyLocationEnabled = true
                        self.mapView.settings.myLocationButton = true
                        self.locationManager.stopUpdatingLocation()
                    }
                    
                }
                
            }
                
            else{
                let userLocation:CLLocation = locations[0] as CLLocation
                self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:self.currentLocation.longitude, zoom: 15)
                let position = CLLocationCoordinate2D(latitude:  self.currentLocation.latitude, longitude: self.currentLocation.longitude)
                print(position)
                DispatchQueue.main.async {
                    
                    self.mapView.camera = camera
                    self.mapView.delegate = self
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.locationManager.stopUpdatingLocation()
                }
                
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
}
