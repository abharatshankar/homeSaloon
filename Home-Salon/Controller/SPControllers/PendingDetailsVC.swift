//
//  PendingDetailsVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 30/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation

class PendingDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var displayImgView: UIImageView!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var servicesLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    
    @IBOutlet weak var paymentSt: UILabel!
    @IBOutlet weak var descripSt: UILabel!
    @IBOutlet weak var addressSt: UILabel!
    @IBOutlet weak var visitDateTimeSt: UILabel!
    @IBOutlet weak var costSt: UILabel!
    @IBOutlet weak var serviceTypeSt: UILabel!
    @IBOutlet weak var serviceSt: UILabel!
    
    @IBOutlet weak var startWorkBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    var marker:GMSMarker!
    var googleMapView : GMSMapView?
    var currentLocation:CLLocationCoordinate2D!
    
    var orderIdToSee = ""
    var orderStatus = ""
    var name = ""
    var orderId = ""
    var amout = ""
    var orderType = ""
    var serviceNames = ""
    var dateData = ""
    var timeData = ""
    var serviceType = ""
    var address = ""
    var proDescription = ""
    var displayImage = ""
    var paidAmt = ""
    var amount = ""
    var longitude = ""
    var latitude = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Pending Details"
        
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.serviceSt.text = languageChangeString(a_str: "Service")
        self.serviceTypeSt.text = languageChangeString(a_str: "Service Type")
        self.visitDateTimeSt.text = languageChangeString(a_str: "Visit Date & Times")
        self.costSt.text = languageChangeString(a_str: "Cost")
        self.addressSt.text = languageChangeString(a_str: "Address")
        self.descripSt.text = languageChangeString(a_str: "Description")
        self.paymentSt.text = languageChangeString(a_str: "Payment Status")
        self.startWorkBtn.setTitle(languageChangeString(a_str: "START WORKING"), for: UIControl.State.normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pendingViewDetailsCall()
    }
    
    @objc fileprivate func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func startWorkBtnAction(_ sender: Any) {
       
        if orderStatus == "1"
        {
           startWorkServiceCall(id: "6")
        }
        if orderStatus == "6"
        {
            startWorkServiceCall(id: "4")
        }
        
    }
    
    
    func loadMaps(){
        
        self.mapView.delegate = self
        self.googleMapView?.delegate = self
        
        let dLati = Double(self.latitude ) ?? 0.0
        let dLong = Double(self.longitude ) ?? 0.0
        
        var lati1 = "17.454720"
        var lati2 = "78.456282"
        //(17.454720, 78.456282)
        
        let dLati2 = Double(lati1) ?? 0.0
        let dLong2 = Double(lati2) ?? 0.0
        
        
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 12)
        self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        
        //        self.marker = GMSMarker()
        //        self.marker!.position = CLLocationCoordinate2DMake(dLati, dLong)
        //        // marker.tracksViewChanges = true
        //        self.marker?.map = self.googleMapView
        //        self.mapView.addSubview(self.googleMapView!)
        //        //self.googleMapView?.settings.setAllGesturesEnabled(false)
        //        self.marker?.icon = UIImage.init(named: "Group 3282")
        
        //sp location
        let locationMark :GMSMarker!
        let posit = CLLocationCoordinate2D(latitude: dLati2 , longitude: dLong2 )
        locationMark = GMSMarker(position: posit )
        locationMark.map = self.mapView
        locationMark.appearAnimation =  .pop
        locationMark.icon = UIImage(named: "Group 3282")?.withRenderingMode(.alwaysTemplate)
        //user
        locationMark.opacity = 0.75
        locationMark.isFlat = true
        locationMark?.map = self.googleMapView
        //self.mapView.addSubview(self.googleMapView!)
        
        
        //user location
        let locationMarker1 :GMSMarker!
        
        let position1 = CLLocationCoordinate2D(latitude: dLati , longitude: dLong )
        locationMarker1 = GMSMarker(position: position1 )
        locationMarker1.map = self.mapView
        locationMarker1.appearAnimation =  .pop
        
        locationMarker1.icon = UIImage(named: "Group 3282")?.withRenderingMode(.alwaysTemplate)
        
        locationMarker1.opacity = 0.75
        locationMarker1.isFlat = true
        
        locationMarker1?.map = self.googleMapView
        self.mapView.addSubview(self.googleMapView!)
        
        let locationstart = CLLocation(latitude: dLati2, longitude: dLong2)
        let locationEnd = CLLocation(latitude: dLati, longitude: dLong)
        
        
        self.fetchRoute(startLocation: locationstart, endLocation: locationEnd)
        
    }
    
    
    
    
    func startWorkServiceCall(id:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/update_order_status"
            
            //        https://www.volive.in/spsalon/services/update_order_status
    
            //        To update order status incase of start and complte work
            //
            //        api_key:2382019
            //        lang:en
            //        owner_id:136
            //        order_id:172
            //        order_status:(6
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":language,"api_key":APIKEY,"owner_id":ownerId,"order_id":orderIdToSee,"order_status":id
            ]
            
            print(parameters)
            
            
            Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                        print(responseData)
                        
                        if status == 1
                        {
                        
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            self.showToastForAlert(message: message)
                            
                             DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                             {
                            if self.orderStatus == "1"
                            {
                            self.pendingViewDetailsCall()
                            }
                            else
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                                vc.checkIntValue = "3"
                                vc.checkStr = ""
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            }
                           //self.startWorkBtn.setTitle("COMPLETE WORK", for: UIControl.State.normal)
                            
                           
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            print(message)
                        }
                    }catch let error as NSError {
                        print(error)
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                    break
                    
                case .failure(_):
                    MobileFixServices.sharedInstance.dissMissLoader()
                    print(response.result.error ?? "")
                    break
                    
                }
            }
            
        }
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    

    // viewDetails Service call
    
    func pendingViewDetailsCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/view_request"
            
            //"https://www.volive.in/spsalon/services/view_request"
            //            api_key:2382019
            //            lang:en
            //            owner_id
            //            order_id
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":language,"api_key":APIKEY,"owner_id":ownerId,"order_id":orderIdToSee
            ]
            
            print(parameters)
            
            
            Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                      print(responseData)
                        
                        if status == 1
                        {
                            
                            
                            if let orderDetails = responseData?["order"] as? [Dictionary<String,Any>]
                            {
                                for i in 0..<orderDetails.count
                                {
                                    if let name = orderDetails[i]["name"] as? String
                                    {
                                        self.name = name
                                    }
                                    if let order_id = orderDetails[i]["order_id"] as? String
                                    {
                                        self.orderType = order_id
                                    }
                                    if let subcategory_name = orderDetails[i]["subcategory_name"] as? String
                                    {
                                        self.serviceNames = subcategory_name
                                    }
                                    if let now_date = orderDetails[i]["now_date"] as? String
                                    {
                                        self.dateData = now_date
                                    }
                                    if let now_time = orderDetails[i]["now_time"] as? String
                                    {
                                        self.timeData = now_time
                                    }
                                    if let amount = orderDetails[i]["amount"] as? String
                                    {
                                        self.amout = amount
                                    }
                                    if let order_type = orderDetails[i]["order_type"] as? String
                                    {
                                        self.serviceType = order_type
                                    }
                                    if let order_status = orderDetails[i]["order_status"] as? String
                                    {
                                        self.orderStatus = order_status
                                    }
                                    
                                    if let display_pic = orderDetails[i]["display_pic"] as? String
                                    {
                                        self.displayImage = base_path+display_pic
                                    }
                                    
                                    if let address = orderDetails[i]["address"] as? String
                                    {
                                        self.address = address
                                    }
                                    
                                    if let paid_amount = orderDetails[i]["paid_amount"] as? String
                                    {
                                        self.paidAmt = paid_amount
                                    }
                                    
                                    if let amount = orderDetails[i]["amount"] as? String
                                    {
                                        self.amount = amount
                                    }

                                    if let longitude = orderDetails[i]["longitude"] as? String
                                    {
                                        self.longitude = longitude
                                    }
                                    if let latitude = orderDetails[i]["latitude"] as? String
                                    {
                                        self.latitude = latitude
                                    }
                                    
                                }
                            }
                            
                            
                            if let providerDetails = responseData?["provider_info"] as? Dictionary<String,Any>
                            {
                                
//                                if let address = providerDetails["address"] as? String
//                                {
//                                    self.address = address
//                                }
                                if let desc = providerDetails["description"] as? String
                                {
                                    self.proDescription = desc
                                }
                            
                            }
                        
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            // print(self.reasonsArr)
                            DispatchQueue.main.async {
                                self.orderNameLbl.text = self.name
                                self.orderIdLbl.text = String(format: "%@%@%@", self.languageChangeString(a_str: "Order No") ?? ""," : ",(self.orderType))
                               // self.orderIdLbl.text = "Order No  : " + "\(self.orderType)"
                                self.costLbl.text = self.amout
                                self.servicesLbl.text = self.serviceNames
                                self.costLbl.text = "\(self.amout)" + " " + "SAR"
                                self.servicesLbl.text = self.serviceNames
                                self.dateTimeLbl.text = "\(self.dateData)" + " " + "\(self.timeData)"
                                self.servicesLbl.text = self.serviceNames
                                self.addressLbl.text = self.address
                                self.desLbl.text = self.proDescription
                                self.locationLbl.text = self.address
                                if self.serviceType == "1"
                                {
                                    self.serviceTypeLbl.text = self.languageChangeString(a_str:"HomeService")
                                }
                                else if self.serviceType == "2"
                                {
                                    self.serviceTypeLbl.text = self.languageChangeString(a_str:"At the Salon")
                                }
                                else
                                {
                                    self.serviceTypeLbl.text = "HomeService & At the Salon"
                                }
                                
                                if self.paidAmt != "0"
                                {
                                    self.paymentStatusLbl.text = self.paidAmt + " " + "SAR " + self.languageChangeString(a_str:"PAID" ?? "")!
                                }
                                else
                                {
                                    self.paymentStatusLbl.text = self.amount + " " + "SAR " + self.languageChangeString(a_str:"PAY" ?? "")!
                                }
                               if self.orderStatus == "6"
                                {
                                self.startWorkBtn.setTitle(self.languageChangeString(a_str:"COMPLETE WORK"), for: UIControl.State.normal)
                                }
                               if self.orderStatus == "1"
                                {
                                 self.startWorkBtn.setTitle(self.languageChangeString(a_str:"START WORKING"), for: UIControl.State.normal)
                                }
                                
                                
                                self.displayImgView.sd_setImage(with: URL(string:self.displayImage), placeholderImage:UIImage(named:"Group 3873"))
                                
                               self.loadMaps()
                                        

                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            print(message)
                        }
                    }catch let error as NSError {
                        print(error)
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                    break
                    
                case .failure(_):
                    MobileFixServices.sharedInstance.dissMissLoader()
                    print(response.result.error ?? "")
                    break
                    
                }
            }
            
        }
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
    
    
    // destination coordinates in this method.
    
    func fetchRoute(startLocation: CLLocation, endLocation: CLLocation){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url1 = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCh-YbEG2kBFdTYIqGu0ONA0LvVPb9FBVE"
        
        
        let url = URL(string: url1)!
        
        DispatchQueue.main.async {
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    MobileFixServices.sharedInstance.dissMissLoader()
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            
                            guard let routes = json["routes"] as? NSArray else {
                                DispatchQueue.main.async {
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                if (routes.count > 0) {
                                    let overview_polyline = routes[0] as? NSDictionary
                                    let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                    
                                    let points = dictPolyline?.object(forKey: "points") as? String
                                    self.showPath(polyStr: points!)
                                    DispatchQueue.main.async {
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                    }
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                MobileFixServices.sharedInstance.dissMissLoader()
                                
                            }
                        }
                    }
                    catch {
                        print("error in JSONSerialization")
                        DispatchQueue.main.async {
                            MobileFixServices.sharedInstance.dissMissLoader()
                        }
                    }
                }
            })
            
            task.resume()
        }
    }
    func showPath(polyStr :String){
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: polyStr)
            
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 3.0
            polyline.strokeColor = #colorLiteral(red: 0.0431372549, green: 0.1921568627, blue: 0.2588235294, alpha: 1)
            polyline.map = self.mapView // Your map view
        }
        
        
    }
    
}
