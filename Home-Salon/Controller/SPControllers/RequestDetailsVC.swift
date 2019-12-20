//
//  RequestDetailsVC.swift
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

class RequestDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var servicesLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    @IBOutlet weak var descripSt: UILabel!
    @IBOutlet weak var addressSt: UILabel!
    @IBOutlet weak var costSt: UILabel!
    @IBOutlet weak var visitDateTimeSt: UILabel!
    @IBOutlet weak var serviceTypeSt: UILabel!
    @IBOutlet weak var servicesSt: UILabel!
    @IBOutlet weak var displayImgView: UIImageView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var marker:GMSMarker!
    var googleMapView : GMSMapView?
    var currentLocation:CLLocationCoordinate2D!
    
    var reasonsArr = [String]()
    var reasonIdArr = [String]()
    
    var orderIdToSee = ""
    var orderReqId = ""
    var checkValue = ""
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
    var longitude = ""
    var latitude = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = languageChangeString(a_str:"View Details")
        
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.servicesSt.text = languageChangeString(a_str: "Service")
        self.serviceTypeSt.text = languageChangeString(a_str: "Service Type")
        self.visitDateTimeSt.text = languageChangeString(a_str: "Visit Date & Times")
        self.costSt.text = languageChangeString(a_str: "Cost")
        self.addressSt.text = languageChangeString(a_str: "Address")
        self.descripSt.text = languageChangeString(a_str: "Description")
        self.acceptBtn.setTitle(languageChangeString(a_str: "ACCEPT"), for: UIControl.State.normal)
        self.rejectBtn.setTitle(languageChangeString(a_str: "REJECT"), for: UIControl.State.normal)
        
        
        
    }
    
    @objc fileprivate func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if checkValue == "3" || checkValue == "5"
        {
            self.acceptBtn.isHidden = true
            self.rejectBtn.isHidden = true
        }
        else
        {
            self.acceptBtn.isHidden = false
            self.rejectBtn.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(rejectMethod), name: NSNotification.Name(rawValue: "reject"), object: nil)
        
          requestViewDetailsCall()
    }
    
    @objc func rejectMethod(){
        
//        let acceptance = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
//        self.navigationController?.pushViewController(acceptance, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC")as! OrderTypeListVC
        vc.checkIntValue = "5"
        vc.checkStr = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func loadMaps(){
        self.mapView.delegate = self
        self.googleMapView?.delegate = self
        let dLati = Double(self.latitude ) ?? 0.0
        let dLong = Double(self.longitude ) ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 12)
        self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.marker = GMSMarker()
        self.marker!.position = CLLocationCoordinate2DMake(dLati, dLong)
        self.marker?.map = self.googleMapView
        self.mapView.addSubview(self.googleMapView!)
        //self.googleMapView?.settings.setAllGesturesEnabled(false)
        self.marker?.icon = UIImage.init(named: "Group 3282")
    }
    
   
    @IBAction func rejectBtnAction(_ sender: Any) {
        
        let RejectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RejectVC") as! RejectVC
        RejectVC.reasons = reasonsArr
        RejectVC.reasonIds =  reasonIdArr
        RejectVC.orderIdToReject = orderIdToSee
        RejectVC.selectedReqId = orderReqId
        
       self.present(RejectVC, animated: true, completion: nil)
        
       }
    
    
    @IBAction func acceptBtnTap(_ sender: Any) {
   
        acceptOrRejectCall(id:"")
    }
    
   
    //accept or reject request post call
    
    func acceptOrRejectCall(id:String)
    {

        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/accept_request"
            //"https://www.volive.in/spsalon/services/accept_request"
            
            //        https://www.volive.in/spsalon/services/accept_request
            //        api_key:2382019
            //        lang:en
            //        owner_id
            //        order_id
            //        reason_id (for reject)
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
               
                ["lang":language,"api_key":APIKEY,"owner_id":ownerId,"order_id":orderIdToSee,"reason_id":id,"request_id":orderReqId]
            
            
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
                        
                       if status == 1
                        {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                            {
                                if id == ""
                                {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingVC")as! PendingVC
                                vc.checkStr1 = ""
                                self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC")as! OrderTypeListVC
                                    vc.checkIntValue = "5"
                                    vc.checkStr = ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                }
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
    
    
    // viewDetails Service call
    
    func requestViewDetailsCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/view_request"
            
            //"https://www.volive.in/spsalon/services/view_request"
            
//            View details of request in provider app (POST method)
//
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
                        self.reasonsArr.removeAll()
                        self.reasonIdArr.removeAll()
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
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

                                if let display_pic = orderDetails[i]["display_pic"] as? String
                                {
                                    self.displayImage = base_path+display_pic
                                }
                                
                                
                                if let address = orderDetails[i]["address"] as? String
                                {
                                    self.address = address
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
                                
//                                    if let address = providerDetails["address"] as? String
//                                    {
//                                        self.address = address
//                                    }
                                    if let desc = providerDetails["description"] as? String
                                    {
                                        self.proDescription = desc
                                    }
                                    
                                
                            }
                            
                            if let reasonsDict = responseData?["reject_reasons"] as? [Dictionary<String,Any>]
                            {
                                for i in 0..<reasonsDict.count
                                {
                                    if let reason = reasonsDict[i]["reason"] as? String
                                    {
                                        self.reasonsArr.append(reason)
                                    }
                                    if let reason_id = reasonsDict[i]["reason_id"] as? String
                                    {
                                        self.reasonIdArr.append(reason_id)
                                    }
                                   
                                }
                            }
                            
                           // print(self.reasonsArr)
                            DispatchQueue.main.async {
                                self.orderNameLbl.text = self.name
                                self.orderIdLbl.text = String(format: "%@%@%@", self.languageChangeString(a_str: "Order No") ?? ""," : ",(self.orderType))
                                    //self.languageChangeString(a_str:"Order No")  + "\(self.orderType)"
                                self.costLbl.text = self.amout
                                self.servicesLbl.text = self.serviceNames
                                self.costLbl.text = "\(self.amout)" + " " + "SAR"
                                self.servicesLbl.text = self.serviceNames
                                self.dateTimeLbl.text = "\(self.dateData)" + " " + "\(self.timeData)"
                                self.servicesLbl.text = self.serviceNames
                                self.addressLbl.text = self.address
                                 self.locationLbl.text = self.address
                                self.desLbl.text = self.proDescription
                                if self.serviceType == "1"
                                {
                                    self.serviceTypeLbl.text = self.languageChangeString(a_str: "HomeService")!
                                }
                                else if self.serviceType == "2"
                                {
                                    self.serviceTypeLbl.text = self.languageChangeString(a_str:"At the Salon")!
                                }
                                else
                                {
                                    self.serviceTypeLbl.text = "HomeService & At the Salon"
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
    
    
    
}
