//
//  ScheduleViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 30/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire
import FSCalendar

var sptimesArr = [[String]]()


var spemployeesArr = [[Int]]()
var spEmployees = 0
var spnamesArr = [[String]]()
var spColorArr = [[String]]()
var spOrderIdArr = [[String]]()
var dictMain = [[String]]()
var dictName = [[String]]()
var dictColor = [[String]]()




class ScheduleViewController: UIViewController,FSCalendarDelegate {
   
    

    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var scheduleTableView: UITableView!
    @IBOutlet weak var empTV: UITableView!
   
    @IBOutlet weak var calenderView: FSCalendar!
    
    @IBOutlet weak var calenderHt: NSLayoutConstraint!
    
    
    @IBOutlet weak var empTVht: NSLayoutConstraint!
    
    var nameArray = [String]()
    var colorArray = [String]()
    var idArr = [String]()
    
    var timingsOfProvider = [String]()
    var bookingCountAtTime = [Int]()
    
    //
    var order_idArr = [String]()
    var employee_nameArr = [String]()
    var employeeColorArr = [String]()
    
     var selDateStr : String?
    
    //var dictMain = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calenderHt.constant = 200
        let scope : FSCalendarScope = FSCalendarScope.week
        self.calenderView.setScope(scope, animated: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = NSDate()
        selDateStr = formatter.string(from: date as Date)
        print("seldate str \(String(describing: selDateStr))")
        
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "slotTimePressed"), object: nil)
        // Do any additional setup after loading the view.
    }
    
   
    @objc func showSpinningWheel(_ notification: NSNotification) {
        
      
        
        let alert = UIAlertController(title: "Are you sure?", message: "You want to Book this slot", preferredStyle: .alert)
        
        
        let okAlert = UIAlertAction(title: "BOOK", style:.default , handler:{ (UIAlertAction)in
            
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                if let id = dict["slotTime"] as? String{
                    
                    self.autoBookingSlot(slot: id)
                    
                    // do something with your image
                }
            }
            
        })
        
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            
    
        })
        
        cancelAlert.setValue(UIColor.lightGray, forKey: "titleTextColor")
        
        alert.addAction(cancelAlert)
        alert.addAction(okAlert)
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        serviceProviderTimeList()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("first call")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // selDateStr = formatter.string(from: date)
        let d1 = formatter.date(from: selDateStr!)
        if date == d1{
            print("date first call")
            serviceProviderTimeList()
        }
        else{
            print("else")
        }
    }
    
    
    //FSCalender delegates
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderHt.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selDateStr = formatter.string(from: date)
        print("did select date \(String(describing: selDateStr))")
        serviceProviderTimeList()
    }
    
    
    
    
    func serviceProviderTimeList()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let providerListUrl = "\(base_path)services/sp_schedule_booking_timing"
            
            //        https://www.volive.in/spsalon/services/sp_schedule_booking_timing
            //
            //            lang:en
//            api_key:2382019
//            user_id:79
//            schedule_date:07-12-2019
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang":"en","api_key":APIKEY,"user_id":userId,"schedule_date":selDateStr ?? ""]
            
            print(parameters)
            
            Alamofire.request(providerListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        print(responseData)
                        let status = responseData?["status"] as! Int
                        let description = responseData?["message"] as! String
                        
                        self.nameArray.removeAll()
                        self.colorArray.removeAll()
                        self.idArr.removeAll()
                        self.bookingCountAtTime.removeAll()
                        self.timingsOfProvider.removeAll()
                        self.order_idArr.removeAll()
                        self.employee_nameArr.removeAll()
                        self.employeeColorArr.removeAll()
                        dictMain.removeAll()
                        dictName.removeAll()
                        dictColor.removeAll()
                        
                        sptimesArr.removeAll()
                        spemployeesArr.removeAll()
                        
                        if status == 1
                        {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let empData = responseData?["employee"] as? [[String:Any]]
                            {
                                    for i in 0..<empData.count
                                    {
                                        if let employee_id = empData[i]["employee_id"] as? String
                                        {
                                            self.idArr.append(employee_id)
                                        }
                                        if let name = empData[i]["name"] as? String
                                        {
                                            self.nameArray.append(name)
                                        }
                                        if let color = empData[i]["color"] as? String
                                        {
                                            self.colorArray.append(color)
                                        }
                                        
                                    }
                                
                                }

                            if let providerServiceList = responseData?["timings"] as? Dictionary<String, AnyObject>
                            {
                                if let count = providerServiceList["employee_count"] as? Int
                                {
                                    spEmployees = count
                                }
                                
                                if let userData = providerServiceList["slots"] as? [[String:Any]]
                                {
                                    for i in 0..<userData.count
                                    {
                                        var idArr1 = [String]()
                                        var colorArr1 = [String]()
                                        var nameArr1 = [String]()
                                        
                                        
                                        if let time = userData[i]["time"] as? String
                                        {
                                            self.timingsOfProvider.append(time)
                                        }
                                        if let booking_count = userData[i]["booking_count"] as? Int
                                        {
                                            self.bookingCountAtTime.append(booking_count)
                                        }
                                        
                                        if let booking_details = userData[i]["booking_details"] as? [[String:Any]]
                                        {
                                            
                                            for i in 0..<booking_details.count
                                            {
                                                if let order_id = booking_details[i]["order_id"] as? String
                                                {
                                                    self.order_idArr.append(order_id)
                                                    idArr1.append(order_id)
                                                }
                                                if let employee_name = booking_details[i]["employee_name"] as? String
                                                {
                                                    self.employee_nameArr.append(employee_name)
                                                   
                                                     nameArr1.append(employee_name)
                                                }
                                                if let color = booking_details[i]["color"] as? String
                                                {
                                                    self.employeeColorArr.append(color)
                                                    colorArr1.append(color)
                                                }
                                                
                                            }
                                            if idArr1 != []
                                            {
                                                dictMain.append(idArr1)
                                                dictName.append(nameArr1)
                                                dictColor.append(colorArr1)
                                                
                                            }
                                            else
                                            {
                                                dictMain.append(["0"])
                                                dictName.append(["0"])
                                                dictColor.append(["0"])
                                            }
                                        }
                                        
                                        
                                        
                                        
                                    }
                                   
                                }
                                print(self.order_idArr)
                                print(dictMain)
                                print(dictName)
                                print(dictColor)
                                
//                                for i in 0..<self.order_idArr.count
//                                {
//                                    spOrderIdArr.append([self.order_idArr[i]])
//                                    if self.employee_nameArr[i] != ""
//                                    {
//                                        spnamesArr.append([self.employee_nameArr[i]])
//                                    }
//                                    else
//                                    {
//                                        spnamesArr.append(["0"])
//                                    }
//                                    if self.employeeColorArr[i] != ""
//                                    {
//                                        spColorArr.append([self.employeeColorArr[i]])
//                                    }
//                                    else
//                                    {
//                                        spColorArr.append(["0"])
//                                    }
//                                    //spColorArr.append([self.colorArray[i]])
//                                }
                                
                                
                                
                            }
                            
                            
                            for i in 0..<self.timingsOfProvider.count
                            {
                                sptimesArr.append([self.timingsOfProvider[i]])
                                spemployeesArr.append([self.bookingCountAtTime[i]])
                            }
                            
                            
                            DispatchQueue.main.async {
                                
                                print(spOrderIdArr)
                                print(spnamesArr)
                                print(spColorArr)
                                
                                self.scheduleTableView.reloadData()
                               self.empTV.reloadData()
                                
                            self.scheduleTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                            self.empTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                
                                self.view.layoutIfNeeded()
                                
                            }
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: description)
                            
                        }
                    }
                    catch let error as NSError {
                        
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
        
        
        scheduleTableView.layer.removeAllAnimations()
        tableViewHeight.constant = scheduleTableView.contentSize.height
        empTV.layer.removeAllAnimations()
        empTVht.constant = empTV.contentSize.height
        
        UIView.animate(withDuration: 0.0) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    
    

    func autoBookingSlot(slot:String)
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let providerListUrl = "\(base_path)services/auto_booking"
            
          
//            https://www.volive.in/spsalon/services/auto_booking
//            lang:en
//            api_key:2382019
//            user_id:79
//            schedule_date:12-12-2019
//            schedule_time:15:00
           
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang":"en","api_key":APIKEY,"user_id":userId,"schedule_date":selDateStr ?? "","schedule_time":slot]
            
            print(parameters)
            
            Alamofire.request(providerListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        print(responseData)
                        let status = responseData?["status"] as! Int
                        let description = responseData?["message"] as! String
            
                        if status == 1
                        {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: description)
                             self.serviceProviderTimeList()
                           
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: description)
                            
                        }
                    }
                    catch let error as NSError {
                        
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
    
    
}

extension ScheduleViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableView == scheduleTableView
        {
//            let height: CGFloat = CGFloat(self.nameArray.count * 60)
//            if view.frame.size.height / 2 + 200 >= height {
//                self.tableViewHeight.constant = CGFloat(self.nameArray.count * 60)
//                print("view height \(view.frame.size.height - 160)\(height) ")
//            } else {
//                print("less view height \(view.frame.size.height)")
//                self.tableViewHeight.constant = view.frame.size.height / 2 + 200
//            }
            return self.nameArray.count
        }
        else
        {
          return sptimesArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == scheduleTableView
        {
         let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
       
            cell.nameLabel.text = self.nameArray[indexPath.row]
            cell.colorLabel.backgroundColor = hexStringToUIColor(hex: self.colorArray[indexPath.row])
           
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Schedule", for: indexPath) as! SPScheduleBookingTVCell
            cell.schTimingCollection.reloadData()
            cell.schTimingCollection.tag = indexPath.row
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if tableView == scheduleTableView
        {
          return 60
        }
        else
        {
          return 70
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = (indexPath.row % 2) != 0 ? UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0) : UIColor.white
    }
    
 
    
}

