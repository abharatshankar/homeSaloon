//
//  DetailsVC.swift
//  HomeSalon_ServiceProvider_App
//
//  Created by Rajesh Kishanchand on 8/1/19.
//  Copyright © 2019 Volive Solutions. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation
import FSCalendar

var timesArr = [[String]]()
var employeesArr = [[Int]]()

    
    //[["10"],["11"],["12"],["1"],["2"],["3"],["4"],["5"],["6"],["7"]]
//var timesArr = ["10","11","12","1","2","3","4","5","6","7"]
var indexOfTime :Int = 0
var numberOfEmployees = 0

var selectedIdArr = String()

class DetailsVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,FSCalendarDelegate,UITextFieldDelegate,UITextViewDelegate{
    
  
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var calenderHt: NSLayoutConstraint!
    @IBOutlet weak var schTvHt: NSLayoutConstraint!
    @IBOutlet weak var schTV: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var availabilityViewHeight: NSLayoutConstraint!
    @IBOutlet var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet var dateViewHeight: NSLayoutConstraint!
    @IBOutlet var sendrequest_Button: UIButton!
    @IBOutlet var salonImages_CollectionView: UICollectionView!
    @IBOutlet var serviceList_TableView_Hight_Constain: NSLayoutConstraint!
    @IBOutlet var serviceList_TableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerLocation: UILabel!
    @IBOutlet weak var providerRating: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var timeSelectionView1: UIView!
    @IBOutlet weak var service1TimeTF: UITextField!
    @IBOutlet weak var service1dateTF: UITextField!
    @IBOutlet weak var view1Ht: NSLayoutConstraint!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var instructionViewHt: NSLayoutConstraint!
    
    @IBOutlet weak var instructionTextView: UITextView!
    
    @IBOutlet weak var calenderTopView: UIView!
    
    var marker:GMSMarker!
    var googleMapView : GMSMapView?
    var currentLocation:CLLocationCoordinate2D!
    var spLongitude = ""
    var spLatitude = ""
    
    // user location
    var location = ""
    var longitude = ""
    var latitude = ""
    
    var arrSelectedCatIds = [String]()
    var arrSelectedRows = [Int]()
    var totalPriceArray = [String]()
    
    var ownerId = ""
    var timigOfProvider = "0"
   
    var typeCheckString  = ""
     var timer:Timer!
    
    // to show services
    var sectionIsExpanded = [Bool]()
    var arrSectionData: NSArray = []
    var providerListData = [ServiceProviderServicesModel]()
    var subCatageoriesArr:[SubCatageoriesData] = []
    var allSubCatArray = [[String]]()
    var subcatageoryId = [String]()
    var subcatageoryNamesArray = [String]()
    var subcatageoryPriceArray = [String]()
    
    
    var bannerImageArr = [String]()
    var bannersNameArr = [String]()
    
    var userNameArr = ""
    var userDesArr = ""
    var userLocationArr = ""
    var userRatingArr = ""
    var userImgArr = ""
    
    // schedule
    
    var schTime = ""
    var schDate = ""
    
     var selDateStr : String?
    
    //
     var timingsOfProvider = [String]()
     var bookingCountAtTime = [Int]()
    
    var timePicker : UIDatePicker?
    var timeToolbar: UIToolbar?
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    //pricing
    
    var totalPriceOfService = ""
    var priceForSelected = 0
    var selectCatArray = [String]()
    var total = 0
    
    
    @IBOutlet weak var writeInstSt: UILabel!
    @IBOutlet weak var selectdateSt: UILabel!
    @IBOutlet weak var selectDate: UILabel!
    @IBOutlet weak var availabilitySt: UILabel!
    @IBOutlet weak var ourServiceSt: UILabel!
    @IBOutlet weak var desSt: UILabel!
    @IBOutlet var calandarView: UIView!
   
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    // for hiding mon,tues... days in story board weekdays height is 0
    
    //https://stackoverflow.com/questions/42994617/how-to-remove-days-in-fscalendar-swift-library
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.desSt.text = languageChangeString(a_str: "Description")
        self.ourServiceSt.text = languageChangeString(a_str: "Our Services")
        self.selectDate.text = languageChangeString(a_str: "Select Time")
        self.selectdateSt.text = languageChangeString(a_str: "Select Date")
        self.availabilitySt.text = languageChangeString(a_str: "Availability")
        self.writeInstSt.text = languageChangeString(a_str: "Write your order instructions")
        self.service1TimeTF.text = languageChangeString(a_str: "Time")
        self.service1dateTF.text = languageChangeString(a_str: "Date")
        self.instructionTextView.text = languageChangeString(a_str:"Write your instructions......")
        
        if language == "ar"
        {
            
            self.service1dateTF.textAlignment = .right
            self.service1dateTF.setPadding(left: -10, right: -10)
            self.service1TimeTF.textAlignment = .right
            self.service1TimeTF.setPadding(left: -10, right: -10)
            self.instructionTextView.textAlignment = .right
            
        }
        else if language == "en"{
            
            self.service1TimeTF.textAlignment = .left
            self.service1TimeTF.setPadding(left: 10, right: 10)
            self.service1dateTF.textAlignment = .left
            self.service1dateTF.setPadding(left: 10, right: 10)
            self.instructionTextView.textAlignment = .right
    
        }
        
        
        self.mapView.delegate = self
        instructionTextView.delegate = self
        
        self.sendrequest_Button.setTitle(languageChangeString(a_str: "SEND REQUEST"), for: UIControl.State.normal)
        
      // createUI()
        
//        var timesArr1 = ["10","11","12","1","2","3","4","5","6","7"]
//        
//         var array2 = [[String]]()
//        
//        for i in 0..<timesArr.count
//        {
//            array2.append([timesArr1[i]])
//        }
//        
//        print(array2)
        
        
        self.calenderHt.constant = 250
        let scope : FSCalendarScope = FSCalendarScope.week
        self.calenderView.setScope(scope, animated: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = NSDate()
        selDateStr = formatter.string(from: date as Date)
        print("seldate str \(String(describing: selDateStr))")
        
        self.instructionTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.instructionTextView.layer.borderWidth = 1.0
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "bookTimePressed"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func showSpinningWheel(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let time = dict["slotTime"] as? String{
                
                UserDefaults.standard.set(time as String, forKey: "Stime")
                UserDefaults.standard.set(selDateStr as! String, forKey: "Sdate")
              
            }
        }
    }
    
    
    func loadMaps(){
        self.mapView.delegate = self
        self.googleMapView?.delegate = self
        let dLati = Double(self.spLatitude ) ?? 0.0
        let dLong = Double(self.spLongitude ) ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 12)
        self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.marker = GMSMarker()
        self.marker!.position = CLLocationCoordinate2DMake(dLati, dLong)
        self.marker?.map = self.googleMapView
        self.mapView.addSubview(self.googleMapView!)
        //self.googleMapView?.settings.setAllGesturesEnabled(false)
        self.marker?.icon = UIImage.init(named: "Group 3282")
    }
    
    
    func createUI(){
        
        timesArr.removeAll()
        employeesArr.removeAll()
        
        if typeString == "schedule"
        {
            
             schTime = UserDefaults.standard.object(forKey: "Stime") as? String ?? ""
             schDate = UserDefaults.standard.object(forKey: "Sdate") as? String ?? ""
        }
        
        
        if self.typeCheckString == "now"{
            
            selectCatArray = arrSelected.map { String($0)}
            arrSelectedCatIds = selectCatArray
            selectedIdArr = stringArray
            total = Int(totalPriceOfService)!
            
            self.dateViewHeight.constant = 0
            //self.calendarViewHeight.constant = 0
            //self.availabilityViewHeight.constant = 0
            self.calandarView.isHidden = true
            self.timeSelectionView1.isHidden = true
            self.view1Ht.constant = 0
            self.instructionView.isHidden = true
            self.instructionViewHt.constant = 0
            
        }else{
            
            
            selectCatArray = arrSelected.map { String($0)}
            arrSelectedCatIds = selectCatArray
             selectedIdArr = stringArray
            
            total = Int(totalPriceOfService)!
        
            self.calandarView.isHidden = false
            self.dateViewHeight.constant = 120
            self.timeSelectionView1.isHidden = true
            self.view1Ht.constant = 0
            self.instructionView.isHidden = false
            self.instructionViewHt.constant = 151
            
            if arrSelectedCatIds.count >= 2
            {
                self.calandarView.isHidden = true
                self.dateViewHeight.constant = 0
                self.timeSelectionView1.isHidden = false
                self.view1Ht.constant = 90
            }
            
            self.showTimePicker()
            self.showDatePicker()
            
           //self.availabilityViewHeight.constant = 577
        }
        
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        if let aSize = UIFont(name: "Poppins-Regular", size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str:"View Details")
            print("font changed")
            
        }
        
        self.sendrequest_Button.layer.cornerRadius = 25
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(navigate), name: NSNotification.Name(rawValue: "push"), object: nil)
        
        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(autoScrollImageSlider), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigate), name: NSNotification.Name(rawValue: "navigate"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(schrequest), name: NSNotification.Name(rawValue: "scheduleReq"), object: nil)
    
    }
    
    
    @objc func schrequest(){
        
        DispatchQueue.main.async {

            //self.showToastForAlert(message: "Successfully requested")

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
            {
        
                let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
                details.checkString = "Side"
                self.navigationController?.pushViewController(details, animated: true)
            }

        }
//
      NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    @objc func navigate(){
        
        let acceptance = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcceptanceViewController") as! AcceptanceViewController
        self.navigationController?.pushViewController(acceptance, animated: true)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserDefaults.standard.set(selDateStr as! String, forKey: "Sdate")
        UserDefaults.standard.removeObject(forKey: "Stime")
        
        createUI()
        //serviceProviderTimeList()
        serviceProviderList()
        
    }

    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.instructionTextView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if instructionTextView.text == ""
        {
            self.instructionTextView.text = languageChangeString(a_str:"Write your instructions......")
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("first call")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // selDateStr = formatter.string(from: date)
        let d1 = formatter.date(from: selDateStr!)
        if date == d1{
            print("date first call")
           serviceProviderList()
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
        UserDefaults.standard.set(selDateStr as! String, forKey: "Sdate")
        serviceProviderList()
            
        
    }
    
    
    //MARK:- AUTO SCROLLING ADV
    
    @objc func autoScrollImageSlider() {
        
        
        DispatchQueue.main.async {

            if self.bannerImageArr.count > 1
            {
                let visibleItems = self.salonImages_CollectionView.indexPathsForVisibleItems

                if visibleItems.count > 0 {

                    var currentItemIndex: IndexPath? = visibleItems[0]

                    if currentItemIndex?.item == self.bannerImageArr.count-1
                    {
                        //self.imagesBannerArray.count - 1 {
                        let nexItem = IndexPath(item: 0, section: 0)

                        self.salonImages_CollectionView.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)

                    }

                    else {

                        let nexItem = IndexPath(item: (currentItemIndex?.item ?? 0) + 1, section: 0)

                        self.salonImages_CollectionView.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                    }
                }
            }

        }
    }
    
    
//    @objc func navigate(){
//        if self.typeCheckString == "now"{
//            let acceptance = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcceptanceViewController") as! AcceptanceViewController
//            self.navigationController?.pushViewController(acceptance, animated: true)
//        }else{
//            let requests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
//            self.navigationController?.pushViewController(requests, animated: true)
//        }
//    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func sendRequest_Btn_Tapped(_ sender: Any) {
        
        
        let array = arrSelectedCatIds.map {String($0)}
        selectedIdArr = array.minimalDescription
        
        //let array1 = totalPriceArray.map {String($0)}
        //totalStrAmount = array1.minimalDescription
       
        if typeCheckString == "now"
        {
//          let priceArr = totalPriceArray.map { Int($0)!}
//
//          for i in 0..<priceArr.count
//          {
//            priceForSelected = priceForSelected+priceArr[i]
//          }
//            totalStrAmount = String(priceForSelected)
            
            totalStrAmount = String(total)
            
        }
        else
        {
            totalStrAmount = String(total)
           
        }
        
//        if selectCatArray.count == arrSelectedCatIds.count
//        {
//            totalStrAmount = totalPriceOfService
//        }
//        else if selectCatArray.count > arrSelectedCatIds.count
//        {
//            if var amount = Int(totalStrAmount)
//            {
//                amount = amount-priceForSelected
//            }
//        }
       
        print(stringArray)
       
        if array.count > 0
        {
            if array.count <= 3
            {
            let popUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPopUpViewController") as! DetailsPopUpViewController
            popUp.checkDetails = "detailsVC"
            popUp.ownerId1 = ownerId
            
            popUp.location = location
            popUp.longitude = longitude
            popUp.latitude = latitude
            
            if typeString == "schedule"
            {
                if arrSelectedCatIds.count == 1 && self.timigOfProvider == "1"
                {
                schTime = UserDefaults.standard.object(forKey: "Stime") as? String ?? ""
                schDate = UserDefaults.standard.object(forKey: "Sdate") as? String ?? ""
                    if  schTime == ""
                    {
                        showToastForAlert(message:languageChangeString(a_str:"Please select Schedule Time")!)
                        return
                    }
                 }
                else
                {
                    schTime = service1TimeTF.text ?? ""
                    schDate = service1dateTF.text ?? ""
                    
                    if schDate == "" && schTime == ""
                    {
                        showToastForAlert(message:languageChangeString(a_str:"Please select Schedule Date and Time")!)
                        return
                    }
                    
                    
                }
                
                popUp.schDate = self.schDate
                popUp.schTime = self.schTime
            }
            
            
            self.present(popUp, animated: true, completion: nil)
            }
            else
            {
                showToastForAlert(message:languageChangeString(a_str:"You can select upto 3 services only")!)
            }
            
        }else{
            showToastForAlert(message: languageChangeString(a_str:"Please select any service")!)
        }
        
    }
    

    //MARK:SHOW TIME PICKER
    func showTimePicker(){
        
        timePicker = UIDatePicker()
        
        timePicker?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        timeToolbar?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        //timePicker?.minimumDate = NSDate() as Date
        timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker?.datePickerMode = .time
        timePicker?.minuteInterval = 30
        timePicker?.backgroundColor = UIColor.white
        timeToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        timeToolbar?.barStyle = .blackOpaque
        timeToolbar?.autoresizingMask = .flexibleWidth
        timeToolbar?.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        timeToolbar?.frame = CGRect(x: 0,y: (timePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        timeToolbar?.barStyle = UIBarStyle.default
        timeToolbar?.isTranslucent = true
        timeToolbar?.tintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        timeToolbar?.backgroundColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        timeToolbar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.donePickerTime))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: languageChangeString(a_str:"Cancel") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.canclePickerTime))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        timeToolbar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeToolbar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.service1TimeTF.inputView = timePicker
        self.service1TimeTF.inputAccessoryView = timeToolbar
        
        
    }
    
    //MARK:DONE PICKER TIME
    @objc func donePickerTime ()
    {
        timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        // txt_time.textAlignment = NSTextAlignment.left
        service1TimeTF.text! = formatter.string(from: (timePicker?.date)!)
       
        self.view.endEditing(true)
        service1TimeTF.resignFirstResponder()
    }
    
    //MARK:CANCEL PICKER TIME
    @objc func canclePickerTime ()
    {
        self.view.endEditing(true)
        service1TimeTF.resignFirstResponder()
    }
    
    //MARK:SHOW DATE PICKER
    func showDatePicker(){
        datePicker = UIDatePicker()
        //datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        datePicker?.datePickerMode = .date
        datePicker?.backgroundColor = UIColor.white
        dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        dateToolBar?.barStyle = .blackOpaque
        dateToolBar?.autoresizingMask = .flexibleWidth
        dateToolBar?.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        dateToolBar?.frame = CGRect(x: 0,y: (datePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        dateToolBar?.barStyle = UIBarStyle.default
        dateToolBar?.isTranslucent = true
        dateToolBar?.tintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        dateToolBar?.backgroundColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        dateToolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.donePickerDate))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.canclePickerDate))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        dateToolBar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateToolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.service1dateTF.inputView = datePicker
        self.service1dateTF.inputAccessoryView = dateToolBar
        // self.datePicker?.minimumDate =
        let date = Date()
        let calendar = Calendar(identifier: .indian)
        var components = DateComponents()
        components.day = 0
        // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
        //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
        let newDate : Date? = calendar.date(byAdding: components, to: date)
        datePicker?.minimumDate = newDate
        
    }
    
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
        //datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //txt_date.textAlignment = NSTextAlignment.left
        service1dateTF.text! = formatter.string(from: (datePicker?.date)!)
        
        self.view.endEditing(true)
        service1dateTF.resignFirstResponder()
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        self.view.endEditing(true)
        service1dateTF.resignFirstResponder()
    }
    
    
    
    
//    func serviceProviderTimeList()
//    {
//
//        if Reachability.isConnectedToNetwork()
//        {
//
//            MobileFixServices.sharedInstance.loader(view: self.view)
//
//            let providerListUrl = "\(base_path)services/schedule_booking_timing"
//
////        https://www.volive.in/spsalon/services/schedule_booking_timing
////
////            lang:en
////            api_key:2382019
////            owner_id:79
////            user_id:80
////            schedule_date:07-12-2019
//
//            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
//
//            timesArr.removeAll()
//            employeesArr.removeAll()
//
//            let parameters: Dictionary<String, Any> = ["lang":"en","api_key":APIKEY,"owner_id":"79","user_id":"80","schedule_date":selDateStr ?? ""]
//
//            print(parameters)
//
//            Alamofire.request(providerListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//
//
//
//                switch(response.result)
//                {
//                case .success(_):
//
//                    guard let data = response.data, response.result.error == nil else { return }
//
//                    do {
//
//                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
//                        print(responseData)
//                        let status = responseData?["status"] as! Int
//                        let description = responseData?["message"] as! String
//
//                        if status == 1
//                        {
//
//                            MobileFixServices.sharedInstance.dissMissLoader()
//
//                            if let providerServiceList = responseData?["timings"] as? Dictionary<String, AnyObject>
//                            {
//                                if let count = providerServiceList["employee_count"] as? Int
//                                {
//                                    numberOfEmployees = count
//                                }
//
//                                if let userData = providerServiceList["slots"] as? [[String:Any]]
//                                {
//                                    for i in 0..<userData.count
//                                    {
//                                        if let time = userData[i]["time"] as? String
//                                        {
//                                            self.timingsOfProvider.append(time)
//                                        }
//                                        if let booking_count = userData[i]["booking_count"] as? Int
//                                        {
//                                            self.bookingCountAtTime.append(booking_count)
//                                        }
//
//                                    }
//                                }
//
//
//                            }
//
//
//                            for i in 0..<self.timingsOfProvider.count
//                            {
//                                timesArr.append([self.timingsOfProvider[i]])
//                                employeesArr.append([self.bookingCountAtTime[i]])
//                            }
//
//
//                            DispatchQueue.main.async {
//
//                                self.schTV.reloadData()
//                            }
//
//                        }
//                        else
//                        {
//                            MobileFixServices.sharedInstance.dissMissLoader()
//                            self.showToastForAlert(message: description)
//
//                        }
//                    }
//                    catch let error as NSError {
//
//                        MobileFixServices.sharedInstance.dissMissLoader()
//                    }
//                    break
//
//                case .failure(_):
//                    MobileFixServices.sharedInstance.dissMissLoader()
//                    print(response.result.error ?? "")
//                    break
//
//                }
//            }
//
//        }
//        else
//        {
//            MobileFixServices.sharedInstance.dissMissLoader()
//            self.showToastForAlert(message:"Please ensure you have proper internet connection")
//
//        }
//    }
//
    
    func serviceProviderList()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let providerListUrl = "\(base_path)services/provider_services"
            
            //            https://www.volive.in/spsalon/services/provider_services
            //            api_key:2382019
            //            lang:en
            //            user_id:15
            //            provider_user_id:14
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            var parameters = [String:Any]()
            
            if typeString == "now"
            {
                parameters = ["lang":language,"api_key":APIKEY,"provider_user_id":ownerId,"user_id":userId]
            }
            else
            {
                parameters = ["lang":"en","api_key":APIKEY,"provider_user_id":ownerId,"user_id":userId,"timing_slots":"1","schedule_date":selDateStr ?? ""]
            }
            print(parameters)
            
            Alamofire.request(providerListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        print(responseData)
                        let status = responseData?["code"] as! Int
                        let description = responseData?["description"] as! String
                        
                        timesArr.removeAll()
                        employeesArr.removeAll()
                        
                        if status == 200
                        {
                            self.bannersNameArr.removeAll()
                            self.bannerImageArr.removeAll()
                            self.timingsOfProvider.removeAll()
                            self.bookingCountAtTime.removeAll()
                            
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            self.providerListData = [ServiceProviderServicesModel]()
                            
                            if let providerServiceList = responseData?["result"] as? Dictionary<String, AnyObject>
                            {
                                
                                if let catResponse = providerServiceList["categories"] as? [[String:Any]]
                                {
                                    self.arrSectionData = catResponse as NSArray
                                    
                                    for list in catResponse {
                                        
                                        let object = ServiceProviderServicesModel(providerListData: list as NSDictionary)
                                        
                                        self.providerListData.append(object)
                                        
                                        self.allSubCatArray = [object.subcategory_id + object.subcategory_name_en + object.subcategoryPrice]
                                        
                                        
                                        for list in self.allSubCatArray{
                                            
                                            self.subcatageoryId = list
                                            self.subcatageoryNamesArray = list
                                            self.subcatageoryPriceArray = list
                                        }
                                        
                                        self.sectionIsExpanded.append(false)
                                    }
                                }
                                
                            }
                            
                            if let bannerData = responseData?["banners"] as? [[String:Any]]
                            {
                                for i in 0..<bannerData.count
                                {
                                    if let image = bannerData[i]["banner_image"] as? String
                                    {
                                        self.bannerImageArr.append(base_path+image)
                                    }
                                    if let title_en = bannerData[i]["title_en"] as? String
                                    {
                                        self.bannersNameArr.append(title_en)
                                    }
                                }
                            }
                            
                            if let userData = responseData?["user"] as? [[String:Any]]
                            {
                                for i in 0..<userData.count
                                {
                                    if let name = userData[i]["name"] as? String
                                    {
                                        self.userNameArr = name
                                    }
                                    if let description = userData[i]["description"] as? String
                                    {
                                        self.userDesArr = description
                                    }
                                    if let display_pic = userData[i]["display_pic"] as? String
                                    {
                                        self.userImgArr = base_path+display_pic
                                    }
                                    
                                    if let location = userData[i]["location"] as? String
                                    {
                                        self.userLocationArr = location
                                    }
                                    if let ratings = userData[i]["rating"] as? String
                                    {
                                        self.userRatingArr = ratings
                                    }
                                    
                                    if let longitude = userData[i]["longitude"] as? String
                                    {
                                        self.spLongitude = longitude
                                    }
                                    if let latitude = userData[i]["latitude"] as? String
                                    {
                                        self.spLatitude = latitude
                                    }
                                    if let timing = userData[i]["timing_status"] as? String
                                    {
                                       
                                        self.timigOfProvider = timing
                                    }
                                    
                                    
                                }
                            }
                            
                            
                            if let providerServiceList1 = responseData?["timings_data"] as? Dictionary<String, AnyObject>
                            {
                                if let count = providerServiceList1["employee_count"] as? Int
                                {
                                    numberOfEmployees = count
                                }
                                
                                if let userData = providerServiceList1["slots"] as? [[String:Any]]
                                {
                                    for i in 0..<userData.count
                                    {
                                        if let time = userData[i]["time"] as? String
                                        {
                                            self.timingsOfProvider.append(time)
                                        }
                                        if let booking_count = userData[i]["booking_count"] as? Int
                                        {
                                            self.bookingCountAtTime.append(booking_count)
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                            
                            
                            for i in 0..<self.timingsOfProvider.count
                            {
                                timesArr.append([self.timingsOfProvider[i]])
                                employeesArr.append([self.bookingCountAtTime[i]])
                            }
                            
                    
                            DispatchQueue.main.async {
                                self.serviceList_TableView.reloadData()
                                self.schTV.reloadData()
                                self.salonImages_CollectionView.reloadData()
                                self.pageControl.numberOfPages = self.bannerImageArr.count
                                self.providerName.text = self.userNameArr
                                self.providerLocation.text = self.userLocationArr
                                
                                self.desLbl.text = self.userDesArr
                                self.providerRating.text = self.userRatingArr
                                
                                self.providerImg.sd_setImage(with: URL (string:self.userImgArr), placeholderImage:
                                    UIImage(named:"Group 3873"))
                                
                                self.serviceList_TableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                
                                self.schTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                
                                if typeString == "schedule"
                                {
                                 if self.timigOfProvider == "1"
                                 {
                                    self.schTV.isUserInteractionEnabled = true
                                 }
                                 else
                                 {
                                    
                                    self.schTV.isUserInteractionEnabled = false
                                    self.calandarView.isHidden = false
                                    self.dateViewHeight.constant = 120
                                    self.timeSelectionView1.isHidden = false
                                    self.view1Ht.constant = 90
                                    
                                 }
                                }
                                self.view.layoutIfNeeded()
                                
                                self.loadMaps()
                                
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
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        serviceList_TableView.layer.removeAllAnimations()
        serviceList_TableView_Hight_Constain.constant = serviceList_TableView.contentSize.height
        schTV.layer.removeAllAnimations()
        schTvHt.constant = schTV.contentSize.height
        
        UIView.animate(withDuration: 0.0) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
}


//MARK:- UIColletionView DataSource and Delegates

extension DetailsVC :
 UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannerImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalonDetailsCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
       
        cell.bannerImg.sd_setImage(with: URL (string:bannerImageArr[indexPath.row]), placeholderImage:
            UIImage(named:""))
        
        cell.bannerName.text = bannersNameArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.pageControl.currentPage = indexPath.row
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

        return CGSize(width: self.salonImages_CollectionView.frame.size.width,height:  self.salonImages_CollectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0

    }
    
}

//MARK:- UITableView DataSource and Delegates

extension DetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == serviceList_TableView
        {
          return providerListData.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // First will always be header
        if tableView == serviceList_TableView
        {
        return sectionIsExpanded[section] ? (1+providerListData[section].subcategory_id.count) : 1
            
        }
        else
        {
            
            if arrSelectedCatIds.count <= 1
            {
              return timesArr.count
            }
            else
            {
                if self.timigOfProvider != "1"
                {
                   return timesArr.count
                }
                else
                {
                    return 0
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        
        if tableView == serviceList_TableView
        {
        
         if indexPath.row == 0
         {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ServieListTableViewCell", for: indexPath) as! ServieListTableViewCell
            
            cell.servicename_Label.text = providerListData[indexPath.section].category_name_en
            
            if sectionIsExpanded[indexPath.section] {
                
                cell.setExpanded()
                
            } else {
                cell.setCollapsed()
            }
            
            return cell
            
        }
            
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServieListTableViewCell
            cell.subCatageoryNameLbl.text = providerListData[indexPath.section].subcategory_name_en[indexPath.row - 1]
            cell.subCatageoryPriceLbl.text = providerListData[indexPath.section].subcategoryPrice[indexPath.row - 1]
            
         
//            if let id = Int(providerListData[indexPath.section].subcategory_id[indexPath.row-1])
//            {
//                if arrSelectedCatIds.contains(id){
//                cell.serviceSelectedOrNot.setImage(UIImage(named:"check_box_check"), for: .normal)
//
//                }else{
//                  cell.serviceSelectedOrNot.setImage(UIImage(named:"Group 3712"), for: .normal)
//                }
//                 cell.serviceSelectedOrNot.tag = id
//                 cell.serviceSelectedOrNot.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
//
//            }
            
            
            
           // cell.serviceSelectedOrNot.tag = IndexPath

            //cell.serviceSelectedOrNot.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)

         
            cell.serviceSelectedOrNot.mk_addTapHandler { (btn) in
                //print("You can use here also directly : \(indexPath.row)")
                self.checkBoxSelection(btn: btn, indexpath: indexPath)
                
            }
            
            let rowid = providerListData[indexPath.section].subcategory_id[indexPath.row-1]
            let found = arrSelectedCatIds.contains(rowid)
            if found
            {
                cell.serviceSelectedOrNot.setImage(UIImage(named:"check"), for: .normal)
            }
            else
            {
                cell.serviceSelectedOrNot.setImage(UIImage(named:"uncheck"), for: .normal)

            }
            
            
            return cell
          }
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleRequestTableViewCell", for: indexPath) as! ScheduleRequestTableViewCell
            
            if self.timigOfProvider != "1"
            {
                cell.alpha = 0.4
                calenderTopView.isHidden = false
                calenderTopView.alpha = 0.4
            }
            else
            {
                cell.alpha = 1
                calenderTopView.isHidden = true
                calenderTopView.alpha = 1
                calenderTopView.backgroundColor = .clear
            }
            
            indexOfTime = indexPath.section
            cell.schCollectionView.reloadData()
            
            cell.schCollectionView.tag = indexPath.row
            print(indexOfTime,timesArr[indexOfTime])
            return cell
        }
        
        
    }
    
    @objc func checkBoxSelection(btn:UIButton , indexpath :IndexPath)
    {
        
       
//
//        if arrSelectedCatIds.count >= 3
//        {
//            if self.arrSelectedCatIds.contains(providerListData[indexpath.section].subcategory_id[indexpath.row-1])
//            {
//
//           self.arrSelectedCatIds.remove(at: self.arrSelectedCatIds.index(of:providerListData[indexpath.section].subcategory_id[indexpath.row-1])!)
//
//            }
//            else
//            {
//
//                showToastForAlert(message: "you can select upto 3 services only")
//            }
//
//        }
//        else
//        {
            if self.arrSelectedCatIds.contains(providerListData[indexpath.section].subcategory_id[indexpath.row-1])
            {
                 self.arrSelectedCatIds.remove(at: self.arrSelectedCatIds.index(of:providerListData[indexpath.section].subcategory_id[indexpath.row-1])!)
//                if typeCheckString == "now"
//                {
//                 self.totalPriceArray.remove(at: self.totalPriceArray.index(of:providerListData[indexpath.section].subcategoryPrice[indexpath.row-1])!)
//                }
//                else
//                {
                    if selectCatArray.count > arrSelectedCatIds.count
                    {
                        if let priceDeSelected = Int(providerListData[indexpath.section].subcategoryPrice[indexpath.row-1])
                        {
                            total = total-priceDeSelected
                        }
                        
                       
                        selectCatArray = arrSelectedCatIds
                        //arrSelected = selectCatArray
                    }
                    
               // }
            }
            else
            {
                self.arrSelectedCatIds.append(providerListData[indexpath.section].subcategory_id[indexpath.row-1])
//                if typeCheckString == "now"
//                {
//                 self.totalPriceArray.append(providerListData[indexpath.section].subcategoryPrice[indexpath.row-1])
//
//                }
//                else
//                {
                    if selectCatArray.count < arrSelectedCatIds.count
                    {
                        if let priceDeSelected = Int(providerListData[indexpath.section].subcategoryPrice[indexpath.row-1])
                        {
                            total = total+priceDeSelected
                        }
                        selectCatArray = arrSelectedCatIds
                      //  arrSelected = selectCatArray
                        
                       
                    }
                    
               // }
                
            }
            
       // }
        
        if timigOfProvider == "1"
        {
        
        if typeString == "schedule"
        {
            if arrSelectedCatIds.count <= 1
            {
            self.calandarView.isHidden = false
            self.dateViewHeight.constant = 120
            self.timeSelectionView1.isHidden = true
            self.view1Ht.constant = 0
            }
            else
            {
                self.calandarView.isHidden = true
                self.dateViewHeight.constant = 0
                self.timeSelectionView1.isHidden = false
                self.view1Ht.constant = 90
                
            }
         }
         else
        {
            if typeString == "schedule"
            {
                self.calandarView.isHidden = false
                self.dateViewHeight.constant = 120
                self.timeSelectionView1.isHidden = false
                self.view1Ht.constant = 90
                
            }
            
            
        }
            
            
        }
       
        schTV.reloadData()
        print(arrSelectedCatIds)
        print(totalPriceArray)
        self.serviceList_TableView.reloadData()
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == serviceList_TableView
        {
         if indexPath.row == 0
         {
            return 80
          }else{
            return 50
         }
        
        }
        else
        {
            
            
            return 70
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == serviceList_TableView
        {
        // Expand/hide the section if tapped its header
        if indexPath.row == 0 {
            
            sectionIsExpanded[indexPath.section] = !sectionIsExpanded[indexPath.section]
            
            tableView.reloadSections([indexPath.section], with: .automatic)
          }
        }
        
        else
        {
            let cell = tableView.cellForRow(at: indexPath)as! ScheduleRequestTableViewCell
            cell.schCollectionView.reloadData()
            schTV.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
       
        return 15
    }
    
    
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        serviceList_TableView_Hight_Constain.constant = serviceList_TableView.contentSize.height
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //         return 70
    //    }
    
}


extension UIButton {
    
    private class Action {
        var action: (UIButton) -> Void
        
        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }
    
    private var tapAction: Action? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionTapped) as? Action }
    }
    
    
    @objc dynamic private func handleAction(_ recognizer: UIButton) {
        tapAction?.action(recognizer)
    }
    
    
    func mk_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
        tapAction = Action(action: action)
        
    }
}


//"REQUEST"="REQUEST";
//"COMPLETE"="COMPLETE";
//"SCHEDULE"="SCHEDULE";
//"PENDING"="PENDING";
//"Requests"="Requests";
//"Service"="Service";
//"Service Type"="Service Type";
//"Visit Date & Times"="Visit Date & Times";
//"Cost"="Cost";
//"Address"="Address";
//"Description"="Description";
//"ACCEPT"="ACCEPT";
//"REJECT"="REJECT";
//"View Details"="View Details";
//"REJECT REQUEST"="REJECT REQUEST";
//"Reasons for Rejection"="Reasons for Rejection";
//"SUBMIT"="SUBMIT";
//"Please select reason to reject the request"="Please select reason to reject the request";
//"Done"="Done";
//"Cancel"="Cancel";
//"Please ensure you have proper internet connection"="Please ensure you have proper internet connection";
//"Details"="Details";
//"HomeService"="HomeService";
//"At the Salon"="At the Salon";
//"HomeService & At the Salon"="HomeService & At the Salon";
//"Completed"="Completed";
//"REJECT"="REJECT";
//"PAID"="PAID";
//"COMPLETE WORK"="COMPLETE WORK";
//"START WORKING"="START WORKING";
//"Order ID"="Order ID";
//"Visit Date&Times"="Visit Date&Times";
//"Order NO"="Order NO";
//"Payment Status"="Order NO";
//"START WORKING"="START WORKING";
//"List of Services"="List of Services";
//"Edit"="Edit";
//"Save"="Save";
//"ADD NEW SERVICE"="ADD NEW SERVICE";
//"Delete"="Delete";
//"Please Select Category"="Please Select Category";
//"ADD NEW SERVICE"="ADD NEW SERVICE";
//"Select category"="Select category";
//"Subcategories"="Subcategories";
//"Service price"="Service price";
//"CANCLE"="CANCLE";
//"SCHEDULE"="SCHEDULE";
//"Profile"="Profile";
//"Available"="Available";
//"UnAvailable"="UnAvailable";
//"Name"="Name";
//"Email"="Email";
//"Mobile Number"="Mobile Number";
//"Change Password"="Change Password";
//"Password"="Password";
//"Confirm Password"="Confirm Password";
//"Available Time"="Available Time";
//"Monday"="Monday";
//"Tuesday"="Tuesday";
//"Wednesday"="Wednesday";
//"Thursday"="Thursday";
//"Friday"="Friday";
//"Saturday"="Saturday";
//"Sunday"="Sunday";
//"IBAN Number"="IBAN Number";
//"Pictures"="Pictures";
//"ADD"="ADD";
//"Home Salon"="Home Salon";
//"Upload Banner"="Upload Banner";
//"Title"="Title";
//"Closing time should be greater than opening time"="Closing time should be greater than opening time";
//"Please enter all timings"="Please enter all timings";
//"Choose Image"="Choose Image";
//"Camera"="Camera";
//"Gallery"="Gallery";
//"Cancel"="Cancel";
//"You don't have camera"="You don't have camera";
//"Ok"="Ok";
//"password and confirm password are different"="password and confirm password are different";
//"Error"="Error";
//"Enable photo permissions in settings"="Enable photo permissions in settings";
//"Settings"="Settings";
//"HOME"="HOME";
//"List of Services"="List of Services";
//"NOTIFICATIONS"="NOTIFICATIONS";
//"MY PROFILE"="MY PROFILE";
//"TERMS AND CONDITIONS"="TERMS AND CONDITIONS";
//"SIGN OUT"="SIGN OUT";
//"Change"="Change";
//"ORDERS"="ORDERS";
//"CONTACT US"="CONTACT US";
//"Login"="Login";
//"Create Account"="Create Account";
//"Forgot Password"="Forgot Password";
//"E-mail Address"="E-mail Address";
//"Verification"="Verification";
//"Verify your mobile"="Verify your mobile";
//"Enter your OTP CODE here"="Enter your OTP CODE here";
//"VERIFY"="VERIFY";
//"Didn't receive the code?"="Didn't receive the code?";
//"Resend code"="Resend code";
//"Choose your option"="Choose your option";
//"Select your location"="Select your location";
//"Description"="Description";
//"Our Services"="Our Services";
//"Availability"="Availability";
//"Select Time"="Select Time";
//"Select Date"="Select Date";
//"Time"="Time";
//"Date"="Date";
//"SEND REQUEST"="SEND REQUEST";
//"Services"="Services";
//"You can select upto 3 services only"="You can select upto 3 services only";
//"Please select any service"="Please select any service";
//"Location Services Disabled!"="Location Services Disabled!";
//"Please enable Location Based Services for better results! We promise to keep your location private"="Please enable Location Based Services for better results! We promise to keep your location private";
//"Cancel"="Cancel";
//"BOOKING DETAILS"="BOOKING DETAILS";
//"Booking services"="Booking services";
//"SEND REQUEST"="SEND REQUEST";
//"TotalPrice"="TotalPrice";
//"Choose your option"="Choose your option";
//"NOW"="NOW";
//"SCHEDULED"="SCHEDULED";
//"SUBMIT"="SUBMIT";
//"Filters"="Filters";
//"Reset"="Reset";
//"Category"="Category";
//"Subcategory"="Subcategory";
//"Price Range"="Price Range";
//"Min"="Min";
//"Max"="Max";
//"Location"="Location";
//"Ratings"="Ratings";
//"5 Rating"="5 Rating";
//"4 & UP"="4 & UP";
//"3 & UP"="3 & UP";
//"2 & UP"="2 & UP";
//"1 & UP"="1 & UP";
//"Sort By"="Sort By";
//"Popularity"="Popularity";
//"Price from Low to High"="Price from Low to High";
//"Price from Hight to Low"="Price from Hight to Low";
//"APPLY FILTER"="APPLY FILTER";
//"My Favorites"="My Favorites";
//"Open now"="Open now";
//"Order No"="Order No";
//"Customer Name"="Customer Name";
//"Invoice No"="Invoice No";
//"Date"="Date";
//"Service Details"="Service Details";
//"Discount coupon codes"="Discount coupon codes";
//"Enter your coupon code"="Enter your coupon code";
//"APPLY"="APPLY";
//"Details"="Details";
//"Sub Total"="Sub Total";
//"Coupon"="Coupon";
//"Total Amount"="Total Amount";
//"PAYMENT OPTION"="PAYMENT OPTION";
//"Successful"="Successful";
//"THANK YOU!"="THANK YOU!";
//"Your payment was completed and confirmation sent to email"="Your payment was completed and confirmation sent to email";
//"Give us a compliment"="Give us a compliment";
//"Write a thank you note"="Write a thank you note";
//"Service Provider"="Service Provider";
//"Service"="Service";
//"Service Type"="Service Type";
//"Scheduled Date & Time"="Scheduled Date & Time";
//"Cost"="Cost";
//"Order Status"="Order Status";
//"VIEW INVOICE"="VIEW INVOICE";
//"Address"="Address";
//"Date & Time"="Date & Time";
//"PAY"="PAY";
//"SP Status"="SP Status";
//"View Details"="View Details";
//"GIVE RATING"="GIVE RATING";
//"Payment"="Payment";
//"Pay With Card"="Pay With Card";
//"Pay by Cash"="Pay by Cash";
//"ENTER YOUR CARD DETAILS"="ENTER YOUR CARD DETAILS";
//"Card Type"="Card Type";
//"Name on Card"="Name on Card";
//"Card Number"="Card Number";
//"Card Expiry"="Card Expiry";
//"CVV"="CVV";
//"Secure Credit Card Payment"="Secure Credit Card Payment";
//"PAY NOW"="PAY NOW";
//"Profile"="Profile";
//"ADD"="ADD";
//"Saved Cards"="Saved Cards";
//"Home Salon"="Home Salon";
//"SIGN IN"="SIGN IN";
//"GUEST USER"="GUEST USER";
//"USER"="USER";
//"Service Provider"="Service Provider";
//"SIGN IN"="SIGN IN";
//"E-mail"="E-mail";
//"Password"="Password";
//"Forgot Your Password?"="Forgot Your Password?";
//"Facebook"="Facebook";
//"Google"="Google";
//"Don't have an account?"="Don't have an account?";
//"Sign up"="Sign up";
//"Please Enter All Fields"="Please Enter All Fields";
//"Please enter valid email"="Please enter valid email";
////"Please ensure you have proper internet connection"="Please ensure you have proper internet connection";
//"E-mail Address"="E-mail Address";
//"Phone number"="Phone number";
//"Create password"="Create password";
//"Confirm Password"="Confirm Password";
//"I agree to the"="I agree to the";
//"TERMS AND CONDITIONS"="TERMS AND CONDITIONS";
//"Password and confirm password are didnot match"="Password and confirm password are didnot match";
//"Please Agree Terms And Conditions"="Please Agree Terms And Conditions";
//"Both"="Both";
//"Home Services"="Home Services";
//"Salon"="Salon";
//"Number of providers"="Number of providers";
//"Already have an account?"="Already have an account?";
//"Sign in Now!"="Sign in Now!";
//". Use Current Location"=". Use Current Location";
//"SET LOCATION"="SET LOCATION";
//"Write your instructions......"="Write your instructions......";
//"Write your order instructions"="Write your order instructions";
//"Good"="Good";
//"Excellent"="Excellent";
//"Average"="Average";
//"Please wait for service provider acceptance"="Please wait for service provider acceptance";
//"Your request has been not accepted Please try again"="Your request has been not accepted Please try again";
//"Your account is under verification,Please wait for admin approval"="Your account is under verification,Please wait for admin approval";
//"Please select Schedule Time"="Please select Schedule Time";
//"Please select Schedule Date and Time"="Please select Schedule Date and Time";




