//
//  FiltersViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 01/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

var filterApplied = Bool()

class FiltersViewController: UIViewController,VPRangeSliderDelegate,UITextFieldDelegate  {
   
    
    var timePicker : UIDatePicker?
    var timeToolbar: UIToolbar?
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    //price
    var strMini         = String()
    var strMax          = String()
    
    @IBOutlet var rangeSlider: VPRangeSlider!
    @IBOutlet var categoryTF: UITextField!
    @IBOutlet var subCategoryTF: UITextField!
    @IBOutlet var locationTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var timeTF: UITextField!
    
    @IBOutlet weak var restBtn: UIBarButtonItem!
    @IBOutlet weak var applyFilterbtn: UIButton!
    @IBOutlet weak var highToLowSt: UILabel!
    @IBOutlet weak var lowtoHighSt: UILabel!
    @IBOutlet weak var popularitySt: UILabel!
    @IBOutlet weak var rate1St: UILabel!
    @IBOutlet weak var sortBySt: UILabel!
    @IBOutlet weak var rate2St: UILabel!
    @IBOutlet weak var rate3St: UILabel!
    @IBOutlet weak var ratye4St: UILabel!
    @IBOutlet weak var rate5St: UILabel!
    @IBOutlet weak var ratingSt: UILabel!
    @IBOutlet weak var timeSt: UILabel!
    @IBOutlet weak var dateSt: UILabel!
    @IBOutlet weak var locationSt: UILabel!
    @IBOutlet weak var maxSt: UILabel!
    @IBOutlet weak var minSt: UILabel!
    @IBOutlet weak var priceSt: UILabel!
    @IBOutlet weak var subCatSt: UILabel!
    @IBOutlet weak var catSt: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var popularity: UIButton!
    @IBOutlet weak var lowToHigh: UIButton!
    @IBOutlet weak var highToLow: UIButton!
    
    let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var textfieldCheckValue : Int!
    
    var category_idArray = [String]()
    var categoryNameArray = [String]()
    var catIconArray = [String]()
    var catString : String! = ""
    var catIdString : String! = ""
    
    var subCategory_idArray = [String]()
    var subCategoryNameArray = [String]()
    var subCatString : String! = ""
    var subCatIdString : String! = ""
    
    
    // for button selections
    var selectedStarRating = ""
    var sortBy = ""
    
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    var city = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       createUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    func createUI()
    {
        categoryTF.delegate = self
        subCategoryTF.delegate = self
        locationTF.delegate = self
        
        self.categoryTF.layer.borderColor = UIColor.lightGray.cgColor
        self.categoryTF.layer.borderWidth = 1.0
        
        self.subCategoryTF.layer.borderColor = UIColor.lightGray.cgColor
        self.subCategoryTF.layer.borderWidth = 1.0
        
        self.locationTF.layer.borderColor = UIColor.lightGray.cgColor
        self.locationTF.layer.borderWidth = 1.0
        
        self.dateTF.layer.borderColor = UIColor.lightGray.cgColor
        self.dateTF.layer.borderWidth = 1.0
        
        self.timeTF.layer.borderColor = UIColor.lightGray.cgColor
        self.timeTF.layer.borderWidth = 1.0
        self.rangeSlider.minRangeText = "0"
        self.rangeSlider.maxRangeText = "10000"
        self.rangeSlider.delegate = self
        self.showTimePicker()
        self.showDatePicker()
        
        self.navigationItem.title = languageChangeString(a_str:"Filters")
        self.catSt.text = languageChangeString(a_str: "Category")
        self.subCatSt.text = languageChangeString(a_str: "Subcategory")
        self.priceSt.text = languageChangeString(a_str: "Price Range")
        self.maxSt.text = languageChangeString(a_str: "Max")
        self.minSt.text = languageChangeString(a_str: "Min")
        self.locationSt.text = languageChangeString(a_str: "Location")
        self.timeSt.text = languageChangeString(a_str: "Time")
        self.dateSt.text = languageChangeString(a_str: "Date")
        self.rate1St.text = languageChangeString(a_str: "1 & UP")
        self.rate2St.text = languageChangeString(a_str: "2 & UP")
        self.rate3St.text = languageChangeString(a_str: "3 & UP")
        self.ratye4St.text = languageChangeString(a_str: "4 & UP")
        self.rate5St.text = languageChangeString(a_str: "5 Rating")
        
        self.sortBySt.text = languageChangeString(a_str: "Sort By")
        self.popularitySt.text = languageChangeString(a_str: "Popularity")
        self.lowtoHighSt.text = languageChangeString(a_str: "Price from Low to High")
        self.highToLowSt.text = languageChangeString(a_str: "Price from Hight to Low")
        self.applyFilterbtn.setTitle(languageChangeString(a_str: "APPLY FILTER"), for: UIControl.State.normal)
        self.restBtn.title = languageChangeString(a_str: "Reset")
        if language == "ar"
        {
            
            self.categoryTF.textAlignment = .right
            self.categoryTF.setPadding(left: -10, right: -10)
            self.subCategoryTF.textAlignment = .right
            self.subCategoryTF.setPadding(left: -10, right: -10)
            self.locationTF.textAlignment = .right
            self.locationTF.setPadding(left: -10, right: -10)
            self.dateTF.textAlignment = .right
            self.dateTF.setPadding(left: -10, right: -10)
            self.timeTF.textAlignment = .right
            self.timeTF.setPadding(left: -10, right: -10)
            
        }
        else if language == "en"{
            
            self.categoryTF.textAlignment = .left
            self.categoryTF.setPadding(left: 10, right: 10)
            self.subCategoryTF.textAlignment = .left
            self.subCategoryTF.setPadding(left: 10, right: 10)
            self.locationTF.textAlignment = .right
            self.locationTF.setPadding(left: 10, right: 10)
            self.dateTF.textAlignment = .left
            self.dateTF.setPadding(left: 10, right: 10)
            self.timeTF.textAlignment = .left
            self.timeTF.setPadding(left: 10, right: 10)
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
    }
    
    @objc func getLocation(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            addressStr = dict["key2"] as? String
            city = dict["Currentcity"] as? String ?? ""
            
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
        }
        
        self.locationTF.text = addressStr
        
    }
    

    @IBAction func applyFilter(_ sender: Any) {
        
        
        if userId == ""
        {
            navigationController?.popViewController(animated: true)
        }
        else
        {
           serviceListPostCall()
        }
       
    }
    
    
    @IBAction func restBtnTap(_ sender: Any) {
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        filterApplied = false
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func sliderScrolling(_ slider: VPRangeSlider!, withMinPercent minPercent: CGFloat, andMaxPercent maxPercent: CGFloat){
        
        let maxLabelVal = CGFloat(10000)
        let minLabelVal = CGFloat(0)
        
        let calCulatedMinLabelVal: CGFloat = (minPercent/100) * maxLabelVal
        print(minPercent)
        let calCulatedMaxLabelVal: CGFloat = (maxPercent/100) * maxLabelVal
        
        if (String(format: "%.0f", calCulatedMinLabelVal) == "0") {
            
            rangeSlider.minRangeText = "0"
             self.strMini = rangeSlider.minRangeText
        } else {
            rangeSlider.minRangeText = String(format: "%.0f", calCulatedMinLabelVal)
            self.strMini = rangeSlider.minRangeText
                       print("slider minimum \(String(describing: rangeSlider.minRangeText))")
        }
        rangeSlider.maxRangeText = String(format: "%.0f", calCulatedMaxLabelVal)
        self.strMax = rangeSlider.maxRangeText
        print("slider maximum \(String(describing: rangeSlider.maxRangeText))")
        let myIntValue1:Int = Int(minPercent)
        
    }
    
    
        //MARK:SHOW TIME PICKER
        func showTimePicker(){
            timePicker = UIDatePicker()
            timePicker?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            timeToolbar?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            timePicker?.minimumDate = NSDate() as Date
            timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            timePicker?.datePickerMode = .time
    
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
    
            let doneButton = UIBarButtonItem(title: languageChangeString(a_str:"Done") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerTime))
            doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: languageChangeString(a_str: "Cancel") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(canclePickerTime))
            cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
            timeToolbar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            timeToolbar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
            self.timeTF.inputView = timePicker
            self.timeTF.inputAccessoryView = timeToolbar
            // self.txt_time.semanticContentAttribute
    
        }
    
        //MARK:DONE PICKER TIME
        @objc func donePickerTime ()
        {
            timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            // txt_time.textAlignment = NSTextAlignment.left
            timeTF.text! = formatter.string(from: (timePicker?.date)!)
            self.view.endEditing(true)
            timeTF.resignFirstResponder()
        }
    
        //MARK:CANCEL PICKER TIME
        @objc func canclePickerTime ()
        {
            self.view.endEditing(true)
            timeTF.resignFirstResponder()
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
    
            let doneButton = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerDate))
            doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(canclePickerDate))
            cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
            dateToolBar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            dateToolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
            self.dateTF.inputView = datePicker
            self.dateTF.inputAccessoryView = dateToolBar
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
            formatter.dateFormat = "dd-MM-yyyy"
            //txt_date.textAlignment = NSTextAlignment.left
            dateTF.text! = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            dateTF.resignFirstResponder()
        }
    
        //MARK:CANCEL PICKER DATE
        @objc func canclePickerDate ()
        {
            self.view.endEditing(true)
            dateTF.resignFirstResponder()
        }
    
    
    
    
    @IBAction func button1Acton(_ sender: Any)
    {
        
        star1.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "1"
    }
    
    @IBAction func button2Acton(_ sender: Any)
    {
        star2.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "2"
    }
    
    @IBAction func button3(_ sender: Any) {
        
        star3.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "3"
    }
    
    @IBAction func button4(_ sender: Any) {
        
        star4.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "4"
    }
    
    
    @IBAction func button5(_ sender: Any) {
        
        star5.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "5"
    }
    
    @IBAction func popularityBtnTap(_ sender: Any) {
        
        popularity.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        highToLow.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        lowToHigh.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "0"
        
    }
    
    
    @IBAction func lowToHighBtnTap(_ sender: Any) {
        lowToHigh.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        highToLow.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        popularity.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "1"
        
    }
    
    @IBAction func highToLowBtnTap(_ sender: Any) {
        
        highToLow.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        popularity.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        lowToHigh.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "2"
        
    }
    
    
   // MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.4151776433, green: 0.4554072618, blue: 0.5596991777, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
     @objc func donePickerView(){
        
        print(textfieldCheckValue)
        if textfieldCheckValue == 1{
            
            self.catString = categoryNameArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
            self.categoryTF.text = self.catString
            
            catIdString = category_idArray[(pickerView?.selectedRow(inComponent: 0)) ?? 0]
            if catString.count > 0{
                self.categoryTF.text = self.catString ?? ""
            }else{
                self.categoryTF.text = categoryNameArray[0]
            }
            
            
            self.view.endEditing(true)
            categoryTF.resignFirstResponder()
            
        }
            else if textfieldCheckValue == 2{
            
            if subCategoryNameArray.count > 0
            {
                self.subCatString = subCategoryNameArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
                self.subCategoryTF.text = self.subCatString
                
                subCatIdString = subCategory_idArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
                if subCatString.count > 0{
                    self.subCategoryTF.text = self.subCatString ?? ""
                }else{
                    self.subCategoryTF.text = subCategoryNameArray[0]
                }
                self.view.endEditing(true)
                subCategoryTF.resignFirstResponder()
                print("subcatageory done")
            }
        }
    }
    
    @objc func cancelPickerView(){
        
        if textfieldCheckValue == 1{
            if (categoryTF.text?.count)! > 0 {
                self.view.endEditing(true)
                categoryTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                categoryTF.text = ""
                categoryTF.resignFirstResponder()
            }
            categoryTF.resignFirstResponder()
        }
            
        else{
            
            if (subCategoryTF.text?.count)! > 0 {
                self.view.endEditing(true)
                subCategoryTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                subCategoryTF.text = ""
                subCategoryTF.resignFirstResponder()
            }
            subCategoryTF.resignFirstResponder()
            
            print("subcatageory cancel")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == self.categoryTF)
        {
            textfieldCheckValue = 1
            catageoriesData()
            self.subCategoryTF.text = ""
            self.pickUp(self.categoryTF)
        }
        else if (textField == subCategoryTF) {
            textfieldCheckValue = 2
            if catIdString == ""{
                showToastForAlert (message: languageChangeString(a_str:"Please Select Category")!)
                self.subCategoryTF.resignFirstResponder()
            }
            else{
                subCatageoriesData()
                self.pickUp(self.subCategoryTF)
                
            }
            
        }
        else if textField == locationTF
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
            self.navigationController?.pushViewController(vc, animated: true)
            locationTF.resignFirstResponder()
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        if (textField == self.categoryTF)
        {
           return true
        }
        else if (textField == subCategoryTF) {
           
            if catIdString == ""{
                
                return false
               
            }
            else{
                subCategory_idArray.removeAll()
                subCategoryNameArray.removeAll()
                
               return true
                
            }
            
        }
        else if textField == locationTF
        {
            return true
        }
        
       return true
    }
    
    
   
    // catageories service call
    
    func catageoriesData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
           
//            https://www.volive.in/spsalon/services/categories
//            Categories list (GET method)
//
//            api_key:2382019
//            lang:en
//
            let catageories = "\(base_path)services/categories?"
           
         
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language]
            
            Alamofire.request(catageories, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>
                {
                    //print(responseData)
                    let status = responseData["status"] as? Int
                    let message = responseData["message"] as? String
                    if status == 1
                    {
                        if let response1 = responseData["Categories list"] as? [[String:Any]]
                        {
                            print(response1)

                            
                            if (self.categoryNameArray.count > 0) ||
                                (self.catIconArray.count > 0) ||
                                (self.category_idArray.count > 0)
                            {
                                self.categoryNameArray.removeAll()
                                self.category_idArray.removeAll()
                                self.catIconArray.removeAll()
                            }

                            //MobileFixServices.sharedInstance.dissMissLoader()
                            for i in 0..<response1.count
                            {
                                if let imgCover = response1[i]["category_image"] as? String
                                {
                                    self.catIconArray.append(base_path+imgCover)

                                }
                                if let name = response1[i]["category_name_en"] as? String
                                {
                                    self.categoryNameArray.append(name)
                                }
                                if let cat_id = response1[i]["category_id"] as? String
                                {
                                    self.category_idArray.append(cat_id)

                                }

                            }
                            print(self.category_idArray)
                            DispatchQueue.main.async {
                             
                                MobileFixServices.sharedInstance.dissMissLoader()
                                self.pickerView?.reloadAllComponents()
                                self.pickerView?.reloadInputViews()

                            }
                       }
                    }
                    else{
                        DispatchQueue.main.async
                            {
                                MobileFixServices.sharedInstance.dissMissLoader()
                                self.showToastForAlert(message: message ?? "")
                                
                        }
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
    
    // subCatageories service call

    func subCatageoriesData()
    {

        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)

            let sub_catageories = "\(base_path)services/subcategories"
            print(catIdString)

     //            https://www.volive.in/spsalon/services/subcategories

//            api_key:2382019
//            lang:en
//            category_id:

            let parameters: Dictionary<String, Any> = ["category_id" : catIdString ?? "",
                                                       
                                                       "lang" : language,
                                                       "api_key":APIKEY

            ]
            
            print(parameters)
            
            Alamofire.request(sub_catageories, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in

            if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                     MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String

                    if status == 1
                    {
                        if let response1 = responseData["Subcategories list"] as? [[String:Any]]
                        {
                            if (self.subCategory_idArray.count > 0) ||
                                (self.subCategoryNameArray.count > 0)

                            {
                                self.subCategory_idArray.removeAll()
                                self.subCategoryNameArray.removeAll()

                            }
                            for i in 0..<response1.count
                            {

                                if let name = response1[i]["subcategory_name_en"] as? String
                                {
                                    self.subCategoryNameArray.append(name)
                                }
                                if let subCat_id = response1[i]["subcategory_id"] as? String
                                {
                                    self.subCategory_idArray.append(subCat_id)

                                }
                           }
                            DispatchQueue.main.async {
                                print(self.subCategoryNameArray)
                                MobileFixServices.sharedInstance.dissMissLoader()
                                if self.subCategoryNameArray.count > 0
                                {

                                    self.pickerView?.reloadAllComponents()
                                    self.pickerView?.reloadInputViews()

                                }

                            }
                        }
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.subCategoryTF.resignFirstResponder()
                        self.showToastForAlert(message: message)

                        
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
             subCategoryTF.resignFirstResponder()

        }

    }
    
    
    func serviceListPostCall()
    {
        //internet connection
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        if Reachability.isConnectedToNetwork()
        {
           
            filterApplied = true
            
            let serviceListUrl = "https://www.volive.in/spsalon/services/service_list"
            
          
            
            let parameters: Dictionary<String, Any> =
                ["lang":language,"api_key":APIKEY,"service_type":selectedOptionId,"subcategory_id":subCatIdString!,"location":city,"longitude":longitudeString ?? "","latitude":latitudeString ?? "" ,"user_id":userId,"category_id":catIdString!,"min_price":self.strMini,"max_price":self.strMax,"rating":selectedStarRating,"sort_by":sortBy]
            
            
            print(parameters)
            
            Alamofire.request(serviceListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                        //print(responseData)
                        
                        banners.removeAll()
                        services.removeAll()
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let bannersDataArr = responseData?["banners"] as? [[String:Any]]
                            {
                                
                                if (bannersDataArr.count)>0{
                                    
                                    
                                    for i in bannersDataArr{
                                        
                                        let newData = bannerData(banner_id: (i["banner_id"] as! String), sort_order: (i["sort_order"] as! String), banner_image: (i["banner_image"] as! String), title_en: (i["title_en"] as! String))
                                        
                                        banners.append(newData)
                                    }
                                    
                                }
                                
                            }
                            
                            if let serviceListArr = responseData?["Services list"] as? [[String:Any]]
                            {
                                
                                if (serviceListArr.count)>0{
                                    
                                    
                                    
                                    for i in serviceListArr{
                                        
                                         let newData = serviceListData(display_pic: (i["display_pic"] as! String), ratings: (i["ratings"] as! Int), promoted: (i["promoted"] as! String), name: (i["name"] as! String), price: (i["price"] as! String), whishlist: (i["whishlist"] as! String), user_id: (i["user_id"] as! String))
                                        

                                        
                                        services.append(newData)
                                    }
                                    
                                }
                                
                            }
                             MobileFixServices.sharedInstance.dissMissLoader()
                            
                            print(banners)
                            print(services)
                            DispatchQueue.main.async {
                                
                                if services.count == 0
                                {
                                    self.showToastForAlert(message: message)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserScheduleViewController") as! UserScheduleViewController
                                vc.filterSubCatId = self.subCatIdString
                                vc.location = self.locationTF.text ?? ""
                                vc.longitude = self.longitudeString ?? ""
                                vc.latitude = self.latitudeString ?? ""
                                    
//                                    if typeString == "schedule"
//                                    {
                                        let id = self.subCatIdString
                                        arrSelected.removeAll()
                                        arrSelected.append(id!)
                                    
        
                                  //  }
                                    
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
    
}
extension FiltersViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        
        
        if (textfieldCheckValue == 1) {
            
            return categoryNameArray.count
        }
        
            
        else {
            
            return subCategoryNameArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        
        
        if (textfieldCheckValue == 1)
        {
            
            return categoryNameArray[row]
        }
       
            
        else
        {
            return subCategoryNameArray[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (textfieldCheckValue == 1)
        {
            
            self.categoryTF.text =  categoryNameArray[row]
            self.catString = categoryNameArray[row]
            catIdString = category_idArray[row]
            
        }
        if textfieldCheckValue == 2
        {
            subCategoryTF.text =  subCategoryNameArray[row]
            self.subCatString = subCategoryNameArray[row]
            subCatIdString = subCategory_idArray[row]
            
        }
    }
}
