//
//  UserHomeViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SDWebImage
import GoogleMaps
import GooglePlaces
import CoreLocation

var userOrOwnerType = ""
var selectedOptionId = ""



//AIzaSyCh-YbEG2kBFdTYIqGu0ONA0LvVPb9FBVE

class UserHomeViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UITextViewDelegate {
    
      var locationManager = CLLocationManager()
    
   
    @IBOutlet weak var selectlocationSt: UILabel!
    @IBOutlet weak var chooseYourSt: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTV: UITextView!
    @IBOutlet var salonBtn: UIButton!
    @IBOutlet var homeServiceBtn: UIButton!
    @IBOutlet weak var locationTVht: NSLayoutConstraint!
    @IBOutlet weak var btn2Lbl: UILabel!
    @IBOutlet weak var btn1Lbl: UILabel!
    @IBOutlet weak var salonImage: UIImageView!
    @IBOutlet weak var homeImg: UIImageView!
    
    var homeOptionNamesArray = [String]()
     var homeOptionIdArray = [String]()
     var homeOptionImgArray = [String]()
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String = ""
    var longitudeString : String = ""
    var checkMapString : String?
    var city : String?

    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    //var userType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseYourSt.text = languageChangeString(a_str: "Choose your option")
        selectlocationSt.text = languageChangeString(a_str: "Select your location")
       
        createUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    func createUI()
    {
        self.locationTV.delegate = self
        locationTV.isUserInteractionEnabled = true
        locationTV.isSelectable = true
        
        isAuthorizedtoGetUserLocation()
        
        let tapRatings = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        locationView.isUserInteractionEnabled = true
        locationView.addGestureRecognizer(tapRatings)
        
        homeServiceBtn.layer.shadowColor = UIColor.lightGray.cgColor
        homeServiceBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        homeServiceBtn.layer.shadowOpacity = 0.50
        homeServiceBtn.layer.shadowRadius = 2.50
        //homeServiceBtn.layer.masksToBounds = false
        
        
        salonBtn.layer.shadowColor = UIColor.lightGray.cgColor
        salonBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        salonBtn.layer.shadowOpacity = 0.50
        salonBtn.layer.shadowRadius = 2.50
        //salonBtn.layer.masksToBounds = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
        
        
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        menuLeftNavigationController.leftSide = true
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationDismissDuration = 0.2
        SideMenuManager.default.menuAnimationPresentDuration = 0.5
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuShadowRadius = 50
        SideMenuManager.default.menuShadowOpacity = 1
        SideMenuManager.default.menuWidth = 300
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
       
    }
  
    

    override func viewWillAppear(_ animated: Bool) {
        
        filterApplied = false
        arrSelected.removeAll()
        self.navigationController?.isNavigationBarHidden = true
        selectedOptionId = ""
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//                self.navigationController?.navigationBar.shadowImage = UIImage()
//                self.navigationController?.navigationBar.isTranslucent = true

                //navigationController?.navigationBar.backgroundColor = .clear
        
        
//                let image = UIImage(named: "BG1")
//               self.navigationController?.navigationBar.setBackgroundImage(image,
//                                                                            for: .default)
        
       // self.navigationController?.navigationBar.shouldRemoveShadow(true)
        
     
     
       
        homeServiceCall()
        
        registerForLocationUpdates()
        
       
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")

                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str:"Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: languageChangeString(a_str: "Settings"), style: .default) { (UIAlertAction) in

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




            }
        } else {
            print("Location services are not enabled")
        }
//
        
    }
    
    
//    @objc func willEnterForegroundRefreshHome() {
//
//        //Register for
//        registerForLocationUpdates()
//    }
    func registerForLocationUpdates(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted,.denied:
                print("No access")

                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str:"Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: languageChangeString(a_str: "Settings"), style: .default) { (UIAlertAction) in
                
              

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


            case .notDetermined:
                print("")
            }
        } else {
            isAuthorizedtoGetUserLocation()
            print("Location services are not enabled")
        }

    }
    
    //MARK:DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        
       
        let userLocation:CLLocation = locations[0] as CLLocation
        let locValue : CLLocationCoordinate2D = manager.location!.coordinate
            //CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        self.latitudeString = String(format: "%.8f", locValue.latitude)
        self.longitudeString = String(format: "%.8f", locValue.longitude)
        print("Lat Value:::\(self.latitudeString)")
        print("Long Value:::\(self.longitudeString)")
        
       if checkMapString == "confirm"
       {
        DispatchQueue.main.async {
            
            self.locationTV.text = self.addressStr
            self.locationTV.resizeForHeight()
            self.view.layoutIfNeeded()
            
        }
        }
        
        else
       {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(locValue) { response , error in
            if error != nil {
                // print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                guard let result = response?.results()?.first else {
                    return
                }
                
                print("adress of that location is \(result)")
                
                print(result.locality)
                self.addressStr = result.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                // result.locality
                
                print("Address Str Is :\(self.addressStr ?? "")")
                
                DispatchQueue.main.async {
                    
                    self.locationTV.text = self.addressStr
                    self.locationTV.resizeForHeight()
                    self.view.layoutIfNeeded()
                    self.cityLbl.text = result.locality
                }
            }
        }
        
        self.locationManager.stopUpdatingLocation()
        }
        
        
    }
    
       @objc func getLocation(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String ?? ""
            longitudeString = dict["key1"] as? String ?? ""
            addressStr = dict["key2"] as? String
            checkMapString = dict["map"] as? String
            city = dict["Currentcity"] as? String
            
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
            print("city",city)
        }
        
        locationTV.text = addressStr
        self.locationTV.resizeForHeight()
        self.view.layoutIfNeeded()
          self.cityLbl.text = city
    }
    
    @IBAction func onTapLocationTv(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
       
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        
        
    }
    
    @IBAction func historyBtnAction(_ sender: Any) {
        let requests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
        requests.checkString = ""
        self.navigationController?.pushViewController(requests, animated: true)
    }
    
    @IBAction func notificationBtnAction(_ sender: Any) {
        let notifications = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserNotificationsViewController") as! UserNotificationsViewController
        notifications.checkString = ""
        self.navigationController?.pushViewController(notifications, animated: true)
    }
    
    
    @IBAction func salonTap(_ sender: Any) {
        let services = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceListVC") as! ServiceListVC
        self.navigationController?.pushViewController(services, animated: true)
    }
    
    @IBAction func homeTap(_ sender: Any) {
        let services = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceListVC") as! ServiceListVC
       
        self.navigationController?.pushViewController(services, animated: true)
    }
    
    @IBAction func btn2Tap(_ sender: Any) {
        
        let services = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceListVC") as! ServiceListVC
        selectedOptionId = homeOptionIdArray[1]
        
        services.location = addressStr
        services.longitude = self.longitudeString
        services.latitude = self.latitudeString
        
        UserDefaults.standard.set(self.addressStr as Any, forKey: "location")
        UserDefaults.standard.set(self.longitudeString as Any, forKey: "longitude")
        UserDefaults.standard.set(self.latitudeString as Any, forKey: "latitude")
        
        self.navigationController?.pushViewController(services, animated: true)
    }
    
    
    @IBAction func btn1Tap(_ sender: Any) {
        
        let services = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceListVC") as! ServiceListVC
      
        services.location = addressStr
        services.longitude = self.longitudeString
        services.latitude = self.latitudeString
       
        UserDefaults.standard.set(addressStr as Any, forKey: "location")
        UserDefaults.standard.set(self.longitudeString as Any, forKey: "longitude")
        UserDefaults.standard.set(self.latitudeString as Any, forKey: "latitude")
        
        selectedOptionId = homeOptionIdArray[0]
        self.navigationController?.pushViewController(services, animated: true)
    }
    
    
    
    
    func homeServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            let userHomeData = "\(base_path)services/home_options?"
           
           // https://www.volive.in/spsalon/services/home_options?api_key=2382019&lang=en
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language]
            
            Alamofire.request(userHomeData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as? String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if let response1 = responseData["Options list"] as? [[String:Any]]
                        {
                            print(response1)
                            
                            
                            
                            if (self.homeOptionIdArray.count > 0) ||
                                (self.homeOptionImgArray.count > 0) ||
                                (self.homeOptionNamesArray.count > 0)
                            {
                                self.homeOptionIdArray.removeAll()
                                self.homeOptionImgArray.removeAll()
                                self.homeOptionNamesArray.removeAll()
                            }
                            
                            //MobileFixServices.sharedInstance.dissMissLoader()
                            for i in 0..<response1.count
                            {
                                if let imgCover = response1[i]["option_image"] as? String
                                {
                                    self.homeOptionImgArray.append(base_path+imgCover)
                                    
                                }
                                if let name = response1[i]["home_option_en"] as? String
                                {
                                    self.homeOptionNamesArray.append(name)
                                }
                                if let option_id = response1[i]["option_id"] as? String
                                {
                                    self.homeOptionIdArray.append(option_id)
                                    
                                }
                                
                            }
                           
                            DispatchQueue.main.async {
                                
                                MobileFixServices.sharedInstance.dissMissLoader()
                              
                                self.btn1Lbl.text = self.homeOptionNamesArray[0]
                               self.btn2Lbl.text = self.homeOptionNamesArray[1]
                                self.homeImg.sd_setImage(with: URL(string: self.homeOptionImgArray[1]), completed: nil)
                                self.salonImage.sd_setImage(with: URL(string: self.homeOptionImgArray[0]), completed: nil)
                                
                               
                
                            }
                        }
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message ?? "")
                        
                    }
                    
                }
                
            }
            
        }
        else{
            
             MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        }
    }
    
}
extension UITextView {
    func resizeForHeight(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
