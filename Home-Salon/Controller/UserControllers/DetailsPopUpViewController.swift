//
//  DetailsPopUpViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 05/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class DetailsPopUpViewController: UIViewController {

    
    @IBOutlet weak var bookingServicesSt: UILabel!
    @IBOutlet weak var timeSt: UILabel!
    @IBOutlet weak var bookingDetailsSt: UILabel!
    @IBOutlet weak var dateSt: UILabel!
    @IBOutlet weak var sendReqBtn: UIButton!
    @IBOutlet weak var bookingTVheight: NSLayoutConstraint!
    @IBOutlet weak var bookingTV: UITableView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var nonExisttingProducts:[nonExisttingProductData] = []
    
    var arrSectionData: NSArray = []
    
    var location = ""
    var longitude = ""
    var latitude = ""
    
    var array1 = [[String:Any]]()
    var currentDate = ""
    var totalPrice = 0
    let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    var checkDetails = ""
    
     var subCatId = ""
     var today : String!
     var ownerId1 = ""
    
    // schedule
    
    var schDate = ""
    var schTime = ""
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sendReqBtn.isUserInteractionEnabled = true
        //currentDate = Date().today(format: "dd/MM/yyyy")
        currentDate = Date().today(format: "yyyy-MM-dd")
        today = getTodayString()
        
        if typeString == "now"
        {
            dateLbl.text = currentDate
            timeLbl.text = today
            
        }
        else
        {
            dateLbl.text = schDate
            timeLbl.text = schTime
        }
        
        bookingServiceCall()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if typeString == "now"
        {
        
         nowRequestServiceCall(date: currentDate, time: today)
            
        }
        else if typeString == "schedule"
        {
            scheduleRequestServiceCall(date: schDate, time: schTime)
        }
        
        sendReqBtn.isUserInteractionEnabled = false
     }
    
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour,.minute], from: date)
        
        
        let hour = components.hour
        let minute = components.minute
        
        
        let today_string =  String(hour!)  + ":" + String(minute!)
        
        return today_string
        
    }
    
    
   
    func scheduleRequestServiceCall(date:String,time:String)
    {
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/schedule_request"
            
            //https://www.volive.in/spsalon/services/testing/schedule_request
            
           // https://www.volive.in/spsalon/services/schedule_request
            
//            api_key:2382019
//            lang:en
//            owner_id:79
//            user_id:80
//            schedule_date:07-12-2019
//            schedule_time:17:00
//            amount:200
//            subcategory_id:17
//            service_at:2
//            location:ameerpet
//            longitude:78.448288
//            latitude:17.437462
            
            var parameters: Dictionary<String, Any> = [:]
            
            //location,longitude,latitude
            
            if checkDetails == "detailsVC"
            {
                
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerId1,"subcategory_id":selectedIdArr,"schedule_date":date,"schedule_time":time,"amount":totalStrAmount,"service_at":selectedOptionId,"location":location,"longitude":longitude,"latitude":latitude
                ]
                print(parameters)
            }
                
            else if filterApplied == true
            {
                
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerIdsArray,"subcategory_id":subCatId,"schedule_date":date,"schedule_time":time,"amount":totalStrAmount,"service_at":selectedOptionId,"location":location,"longitude":longitude,"latitude":latitude
                ]
                print(parameters)
            }
                
            
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
                            
                           // self.showToastForAlert(message: message)
                           
                            
                            UserDefaults.standard.removeObject(forKey: "Stime")
                            UserDefaults.standard.removeObject(forKey: "Sdate")
                            
                            filterApplied = false
                            
                            if UserDefaults.standard.object(forKey: "typeOfService") as! String == "schedule"{
                                
                                NotificationCenter.default.post(name: NSNotification.Name("scheduleReq"), object: nil)
                            }
                            
                    
                            DispatchQueue.main.async {
                                
                                self.dismiss(animated: true, completion: nil)
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
            self.showToastForAlert(message:"Please ensure you have proper internet connection")
            
        }
        
        
    }

    
    
    

    func nowRequestServiceCall(date:String,time:String)
    {
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/now_request"
            
            //    https://www.volive.in/spsalon/services/now_request
            //    api_key:2382019
            //    lang:en
            //    user_id
            //    owner_id
            //    subcategory_id
            //    now_date
            //    now_time
            //    amount
            //searvice_at
            
            var parameters: Dictionary<String, Any> = [:]
            
            //location,longitude,latitude
            
            if checkDetails == "detailsVC"
            {
                
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerId1,"subcategory_id":selectedIdArr,"now_date":date,"now_time":time,"amount":totalStrAmount,"service_at":selectedOptionId,"location":location,"longitude":longitude,"latitude":latitude
                ]
                print(parameters)
            }
                
            else if filterApplied == true
            {
                
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerIdsArray,"subcategory_id":subCatId,"now_date":date,"now_time":time,"amount":totalStrAmount,"service_at":selectedOptionId,"location":location,"longitude":longitude,"latitude":latitude
                ]
                print(parameters)
            }
                
            
            else
            {
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerIdsArray,"subcategory_id":stringArray,"now_date":date,"now_time":time,"amount":totalStrAmount,"service_at":selectedOptionId,"location":location,"longitude":longitude,"latitude":latitude
                ]
                print(parameters)
            }
            
            
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
                            
                            filterApplied = false
                            
                            if UserDefaults.standard.object(forKey: "typeOfService") as! String == "now"{
                                NotificationCenter.default.post(name: NSNotification.Name("navigate"), object: nil)
                            }else
                            {
                                NotificationCenter.default.post(name: NSNotification.Name("push"), object: nil)
                            }
//                            DispatchQueue.main.async {
//                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AcceptanceViewController") as! AcceptanceViewController
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
                           
                           
                            
                            DispatchQueue.main.async {

                                self.dismiss(animated: true, completion: nil)

                             }
                            
                            //self.showToastForAlert(message: message)
                            
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
            self.showToastForAlert(message:"Please ensure you have proper internet connection")
            
        }
        
        
   }
    
    func bookingServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {

            let requestUrl = "https://www.volive.in/spsalon/services/services_dialog"


            //    https://www.volive.in/spsalon/services/services_dialog
            //    Add and delete whishlist (POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    subcategory_id
            //    owner_id

            var parameters: Dictionary<String, Any> = [:]

           
            if checkDetails == "detailsVC"
            {
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerId1,"subcategory_id":selectedIdArr
                ]
                print(parameters)
            }
                
            else if filterApplied == true
            {
                
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerIdsArray,"subcategory_id":subCatId
                ]
                print(parameters)
            }
                
            else
            {
                parameters =
                    ["lang":language,"api_key":APIKEY,"user_id":userId,"owner_id":ownerIdsArray,"subcategory_id":stringArray
                ]
                print(parameters)
            }

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
                            
                            let nonExsittingProductArry = responseData?["data"] as! [Dictionary<String,Any>]
                            
                            self.arrSectionData = nonExsittingProductArry as NSArray
                            
                            
                            if (nonExsittingProductArry.count)>0{
                                
                                self.nonExisttingProducts.removeAll()
                                
                                
                                for i in nonExsittingProductArry{
                                    let newNonexisttingData = nonExisttingProductData(name: (i["name"]as! String), owner_id: (i["owner_id"]as! String))
                                    self.nonExisttingProducts.append(newNonexisttingData)
                                    
                                }
                                
                            }
                            
                        
                            DispatchQueue.main.async {
                                self.bookingTV.reloadData()
                    
                                self.bookingTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

                                self.view.layoutIfNeeded()
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
            self.showToastForAlert(message:"Please ensure you have proper internet connection")

        }
    }

    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {


        bookingTV.layer.removeAllAnimations()
        bookingTVheight.constant = bookingTV.contentSize.height

        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }

    
    
   }


extension DetailsPopUpViewController:UITableViewDelegate,UITableViewDataSource
{
   
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrSectionData.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tempDic: NSDictionary = arrSectionData.object(at: section) as! NSDictionary
        let TempDataArr  = tempDic.object(forKey: "service") as! [[String:Any]]
        
        
        array1 = TempDataArr
        array1.append(["TotalPrice":""])
        print(array1)
       // bookingTVheight.constant = CGFloat(TempDataArr.count) * 60  + 30
        
        return array1.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "booking", for: indexPath) as! SalonListTableViewCell
        
        let tempDic: NSDictionary = arrSectionData[indexPath.section] as! NSDictionary
        let TempDataArr  = tempDic.object(forKey: "service") as! [[String:Any]]
        array1 = TempDataArr
        array1.append(["TotalPrice":""])

        
        
        
        if indexPath.row == 0
        {
            var array2 = [[String:Any]]()

            let tempDic: NSDictionary = arrSectionData[indexPath.section] as! NSDictionary
            let TempDataArr  = tempDic.object(forKey: "service") as! [[String:Any]]
            array2 = TempDataArr
            print(array2)
                for i in 0..<array2.count
                {
                    let value1 = (((arrSectionData[indexPath.section] as! NSDictionary)["service"] as! NSArray)[i] as! NSDictionary)["price"] as? String ?? ""
                    if let total = Int(value1)
                    {
                        totalPrice = totalPrice + total
                    }
                    print(totalPrice)

                }
        }
        
//        cell.serviceNameLbl.text = (((arrSectionData[indexPath.section] as! NSDictionary)["service"] as! NSArray)[indexPath.row] as! NSDictionary)["subcategory_name_en"] as? String
//        cell.serviceCostLbl.text = "\((((arrSectionData[indexPath.section] as! NSDictionary)["service"] as! NSArray)[indexPath.row] as! NSDictionary)["price"] as? String ?? "")" + " " + "SAR"
//
        if indexPath.row == array1.count-1
        {
            cell.serviceNameLbl.text = "Total price"
           // cell.serviceCostLbl.text = totalAmount[indexPath.section] + " " + "SAR"
            cell.serviceCostLbl.text = "\(totalPrice)" + " " + "SAR"
            totalPrice = 0
            array1.removeAll()

        }
       else
        {
            cell.serviceNameLbl.text = (((arrSectionData[indexPath.section] as! NSDictionary)["service"] as! NSArray)[indexPath.row] as! NSDictionary)["subcategory_name_en"] as? String
            cell.serviceCostLbl.text = "\((((arrSectionData[indexPath.section] as! NSDictionary)["service"] as! NSArray)[indexPath.row] as! NSDictionary)["price"] as? String ?? "")" + " " + "SAR"
            
        }
       
            return cell
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
            cell.textLabel?.text = nonExisttingProducts[section].name
        return cell
   
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cell: UITableViewCell = {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
//                return UITableViewCell(style:.value1, reuseIdentifier: "cell")
//            }
//            return cell
//        }()
//        cell.textLabel?.text = "Total Price"
//        cell.detailTextLabel?.text = "\(totalAmount[section])" + " " + "SAR"
//       // print(<#T##items: Any...##Any#>)
////        let cell = self.bookingTV.dequeueReusableHeaderFooterView(withIdentifier: "totalPriceCell") as! SalonListTableViewCell
////
////        cell.priceOfService.text = totalAmount[section]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


struct nonExisttingProductData {
    
    var name:String!
    var owner_id:String!
    
    init(name:String,owner_id:String) {
        
         self.name = name
        self.owner_id = owner_id
    
        }
    
}
