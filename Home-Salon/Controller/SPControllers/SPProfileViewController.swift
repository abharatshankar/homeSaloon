//
//  ProfileViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 30/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import Photos



class SPProfileViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var bannerAddBtn: UIButton!
    @IBOutlet weak var providerImgBtn: UIButton!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet var picturesCollectionView: UICollectionView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    @IBOutlet weak var picsCollectionHt: NSLayoutConstraint!
   
    @IBOutlet weak var tuesSt: UILabel!
    
    @IBOutlet weak var picturesSt: UILabel!
    @IBOutlet weak var ibanSt: UILabel!
    @IBOutlet weak var sunSt: UILabel!
    @IBOutlet weak var satSt: UILabel!
    @IBOutlet weak var friSt: UILabel!
    @IBOutlet weak var thursSt: UILabel!
    @IBOutlet weak var wednesSt: UILabel!
    @IBOutlet weak var mondaySt: UILabel!
    @IBOutlet weak var confirmPassSt: UILabel!
    @IBOutlet weak var availableSt: UILabel!
    @IBOutlet weak var passwordSt: UILabel!
    @IBOutlet weak var changePassSt: UILabel!
    @IBOutlet weak var mobileNumSt: UILabel!
    @IBOutlet weak var nameSt: UILabel!
    @IBOutlet weak var emailSt: UILabel!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var availableTimingHt: NSLayoutConstraint!
    
    @IBOutlet weak var monOpenTF: UITextField!
    @IBOutlet weak var monCloseTF: UITextField!
    @IBOutlet weak var tuesopenTF: UITextField!
    @IBOutlet weak var tuesCloseTF: UITextField!
    @IBOutlet weak var wedOpenTF: UITextField!
    @IBOutlet weak var wedCloseTF: UITextField!
    
    @IBOutlet weak var friCloseTF: UITextField!
    @IBOutlet weak var friOpenTF: UITextField!
    @IBOutlet weak var thuOpenTF: UITextField!
    
    @IBOutlet weak var sunCloseTF: UITextField!
    @IBOutlet weak var sunOpenTF: UITextField!
    @IBOutlet weak var satCloseTF: UITextField!
    @IBOutlet weak var satOpenTF: UITextField!
    
    @IBOutlet weak var thuCloseTF: UITextField!
    
    @IBOutlet weak var ibanNoTF: UITextField!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var showOrHideTime: UIButton!
    @IBOutlet weak var availBtn: UIButton!
    
    let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    // provider data
    var name = ""
    var email = ""
    var phone = ""
    var providerImage = ""
    var ibanNoData = ""
    var numberOfEmployees = ""
    var checkValue = 1
    var TypeOfService = ""
    var availabityOrNot = ""
    var checkavail = false
    
    // timings data
    
    var mondayOpenTime = ""
    var mondayCloseTime = ""
    var tuedayOpenTime = ""
    var tuedayCloseTime = ""
    var weddayOpenTime = ""
    var weddayCloseTime = ""
    var thursdayOpenTime = ""
    var thursdayCloseTime = ""
    var fridayOpenTime = ""
    var fridayCloseTime = ""
    var satdayOpenTime = ""
    var satdayCloseTime = ""
    var sundayOpenTime = ""
    var sundayCloseTime = ""
    var timeHideorShow = ""
    var hideOrShow = false
    var timingIdofOwner = ""
    
    var checkStr = ""
    
    var timePicker : UIDatePicker?
    var timeToolbar: UIToolbar?
    
    let datePicker = UIDatePicker()
    
     var textfieldCheckValue : Int!
    
    var picker = UIImagePickerController()
   
    var bannerImage = UIImage()
    
    var pickedImage = UIImage()
    var imageArray = [UIImage]()
    
    var bannersImage = [String]()
    var bannersIdArr = [String]()
    var bannerTitleArr = [String]()
    
    // banner image
    var upload : Bool!
     var multiImagesArr  = [UIImage]()
 
    var PhotoArray = [UIImage]()
     var myArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       createUI()
        
         self.navigationItem.title = languageChangeString(a_str:"Profile")
        picker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func createUI()
    {
        monOpenTF.delegate = self
        monCloseTF.delegate = self
        tuesopenTF.delegate = self
        tuesCloseTF.delegate = self
        wedOpenTF.delegate = self
        wedCloseTF.delegate = self
        thuOpenTF.delegate = self
        thuCloseTF.delegate = self
        friOpenTF.delegate = self
        friCloseTF.delegate = self
        satOpenTF.delegate = self
        satCloseTF.delegate = self
        sunOpenTF.delegate = self
        sunCloseTF.delegate = self
        
        self.imageArray = [#imageLiteral(resourceName: "Stock"),#imageLiteral(resourceName: "St-Brelades-Bay-Spa-Paul-Wright-Photographer-9-e1542889153536"),#imageLiteral(resourceName: "salon-compressor-1024x683")]
        
        self.providerImgBtn.isHidden = true
        
        
        self.providerImgBtn.isHidden = true
        self.nameTF.isUserInteractionEnabled = false
        self.emailTF.isUserInteractionEnabled = false
        self.phoneTF.isUserInteractionEnabled = false
        self.passwordTF.isUserInteractionEnabled = false
        self.confirmPassTF.isUserInteractionEnabled = false
        self.showOrHideTime.isUserInteractionEnabled = false
        self.availBtn.isUserInteractionEnabled = false
        
        self.monOpenTF.isUserInteractionEnabled = false
        self.monCloseTF.isUserInteractionEnabled = false
        self.tuesopenTF.isUserInteractionEnabled = false
        self.tuesCloseTF.isUserInteractionEnabled = false
        self.wedOpenTF.isUserInteractionEnabled = false
        self.wedCloseTF.isUserInteractionEnabled = false
        self.thuOpenTF.isUserInteractionEnabled = false
        self.thuCloseTF.isUserInteractionEnabled = false
        self.friOpenTF.isUserInteractionEnabled = false
        self.friCloseTF.isUserInteractionEnabled = false
        self.satOpenTF.isUserInteractionEnabled = false
        self.satCloseTF.isUserInteractionEnabled = false
        self.sunOpenTF.isUserInteractionEnabled = false
        self.sunCloseTF.isUserInteractionEnabled = false
        self.bannerAddBtn.isUserInteractionEnabled = false
        self.bannerAddBtn.isHidden = true
        self.ibanNoTF.isUserInteractionEnabled = false
        self.editBtn.title = languageChangeString(a_str:"Edit")
        
        self.nameSt.text = languageChangeString(a_str: "Name")
        self.emailSt.text = languageChangeString(a_str: "Email")
        self.mobileNumSt.text = languageChangeString(a_str: "Mobile Number")
        self.changePassSt.text = languageChangeString(a_str: "Change Password")
        self.passwordSt.text = languageChangeString(a_str: "Password")
        self.confirmPassSt.text = languageChangeString(a_str: "Confirm Password")
        self.availableSt.text = languageChangeString(a_str: "Available Time")
        self.mondaySt.text = languageChangeString(a_str: "Monday")
        self.tuesSt.text = languageChangeString(a_str: "Tuesday")
        self.wednesSt.text = languageChangeString(a_str: "Wednesday")
        self.thursSt.text = languageChangeString(a_str: "Thursday")
        self.friSt.text = languageChangeString(a_str: "Friday")
        self.satSt.text = languageChangeString(a_str: "Saturday")
        self.sunSt.text = languageChangeString(a_str: "Sunday")
        self.ibanSt.text = languageChangeString(a_str: "IBAN Number")
        self.picturesSt.text = languageChangeString(a_str: "Pictures")
       self.bannerAddBtn.setTitle(languageChangeString(a_str: "ADD"), for: UIControl.State.normal)
        
       // SPProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.passwordTF.text = UserDefaults.standard.object(forKey: "password") as? String
        self.confirmPassTF.text = UserDefaults.standard.object(forKey: "password") as? String
       
        if checkValue == 1
        {
        
           SPProfile()
        }
    }
    
    @IBAction func editOrSaveBtnTap(_ sender: Any) {
        
        
        if checkValue == 1{
            
            self.editBtn.title = languageChangeString(a_str:"Save")
            self.providerImgBtn.isHidden = false
            self.nameTF.isUserInteractionEnabled = true
            self.emailTF.isUserInteractionEnabled = false
            self.phoneTF.isUserInteractionEnabled = false
            self.passwordTF.isUserInteractionEnabled = true
            self.confirmPassTF.isUserInteractionEnabled = true
            self.showOrHideTime.isUserInteractionEnabled = true
            self.availBtn.isUserInteractionEnabled = true
            self.nameTF.becomeFirstResponder()
            
            self.monOpenTF.isUserInteractionEnabled = true
            self.monCloseTF.isUserInteractionEnabled = true
            self.tuesopenTF.isUserInteractionEnabled = true
            self.tuesCloseTF.isUserInteractionEnabled = true
            self.wedOpenTF.isUserInteractionEnabled = true
            self.wedCloseTF.isUserInteractionEnabled = true
            self.thuOpenTF.isUserInteractionEnabled = true
            self.thuCloseTF.isUserInteractionEnabled = true
            self.friOpenTF.isUserInteractionEnabled = true
            self.friCloseTF.isUserInteractionEnabled = true
            self.satOpenTF.isUserInteractionEnabled = true
            self.satCloseTF.isUserInteractionEnabled = true
            self.sunOpenTF.isUserInteractionEnabled = true
            self.sunCloseTF.isUserInteractionEnabled = true
            self.bannerAddBtn.isUserInteractionEnabled = true
            self.picturesCollectionView.reloadData()
            self.bannerAddBtn.isHidden = false
            
            checkValue = 2
            self.view.layoutIfNeeded()
    
        }
        else{
            
            self.providerImgBtn.isHidden = true
            self.nameTF.isUserInteractionEnabled = false
            self.emailTF.isUserInteractionEnabled = false
            self.phoneTF.isUserInteractionEnabled = false
            self.passwordTF.isUserInteractionEnabled = false
            self.confirmPassTF.isUserInteractionEnabled = false
            self.showOrHideTime.isUserInteractionEnabled = false
            self.availBtn.isUserInteractionEnabled = false
            
            self.monOpenTF.isUserInteractionEnabled = false
            self.monCloseTF.isUserInteractionEnabled = false
            self.tuesopenTF.isUserInteractionEnabled = false
            self.tuesCloseTF.isUserInteractionEnabled = false
            self.wedOpenTF.isUserInteractionEnabled = false
            self.wedCloseTF.isUserInteractionEnabled = false
            self.thuOpenTF.isUserInteractionEnabled = false
            self.thuCloseTF.isUserInteractionEnabled = false
            self.friOpenTF.isUserInteractionEnabled = false
            self.friCloseTF.isUserInteractionEnabled = false
            self.satOpenTF.isUserInteractionEnabled = false
            self.satCloseTF.isUserInteractionEnabled = false
            self.sunOpenTF.isUserInteractionEnabled = false
            self.sunCloseTF.isUserInteractionEnabled = false
            self.bannerAddBtn.isUserInteractionEnabled = false
            self.bannerAddBtn.isHidden = true
            
             self.editBtn.title = languageChangeString(a_str:"Edit")
            
            
            checkValue = 1
            self.picturesCollectionView.reloadData()
            self.view.layoutIfNeeded()
            
            if Reachability.isConnectedToNetwork() {
                
                if monOpenTF.text != "" && monCloseTF.text != "" && tuesopenTF.text != "" && tuesCloseTF.text != "" && wedOpenTF.text != "" && wedCloseTF.text != "" && thuOpenTF.text != "" && thuCloseTF.text != "" && friOpenTF.text != "" && friCloseTF.text != "" && satOpenTF.text != "" && satCloseTF.text != "" && sunOpenTF.text != "" && sunCloseTF.text != ""
                {
                    
                    
                    var time1 : String?
                    time1 = monOpenTF.text ?? ""
                    let mon1 = (time1 as! NSString).floatValue
                    
                    var time2 : String?
                    time2 = monCloseTF.text ?? ""
                    let mon2 = (time2 as! NSString).floatValue
                    
                    var time3 : String?
                    time3 = tuesopenTF.text ?? ""
                    let mon3 = (time3 as! NSString).floatValue
                    
                    var time4 : String?
                    time4 = tuesCloseTF.text ?? ""
                    let mon4 = (time4 as! NSString).floatValue
                    
                    var time5 : String?
                    time5 = wedOpenTF.text ?? ""
                    let mon5 = (time5 as! NSString).floatValue
                    
                    var time6 : String?
                    time6 = wedCloseTF.text ?? ""
                    let mon6 = (time6 as! NSString).floatValue
                    
                    var time7 : String?
                    time7 = thuOpenTF.text ?? ""
                    let mon7 = (time7 as! NSString).floatValue
                    
                    var time8 : String?
                    time8 = thuCloseTF.text ?? ""
                    let mon8 = (time8 as! NSString).floatValue
                    
                    var time9 : String?
                    time9 = friOpenTF.text ?? ""
                    let mon9 = (time9 as! NSString).floatValue
                    
                    var time10 : String?
                    time10 = friCloseTF.text ?? ""
                    let mon10 = (time10 as! NSString).floatValue
                    
                    var time11 : String?
                    time11 = satOpenTF.text ?? ""
                    let mon11 = (time11 as! NSString).floatValue
                    
                    var time12 : String?
                    time12 = satCloseTF.text ?? ""
                    let mon12 = (time12 as! NSString).floatValue
                    
                    var time13 : String?
                    time13 = sunOpenTF.text ?? ""
                    let mon13 = (time13 as! NSString).floatValue
                    
                    var time14 : String?
                    time14 = satCloseTF.text ?? ""
                    let mon14 = (time14 as! NSString).floatValue
                    
                
                    if mon1<mon2 && mon3<mon4 && mon5<mon6 && mon7<mon8 && mon9<mon10 && mon11<mon12 && mon13<mon14
                    {
                        
//                        if checkStr == "1"
//                        {
//                         postAProduct1(myPicture: bannerImage)
//                        }
                        
                    
                         timingsUpdate()
                        
                         postAProduct(lang: "en", myPicture: pickedImage)
                        
                        SPProfile()
                        
                    }
                    else
                    {
                        self.showToastForAlert(message:languageChangeString(a_str:"Closing time should be greater than opening time")!)
                        SPProfile()
                     }
                }
                    
                else {
                        self.showToastForAlert(message: languageChangeString(a_str:"Please enter all timings")!)
                    }
                
                
            }else
            {
                self.showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
                
            }
        }
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
    }
    

//    //MARK:SHOW TIME PICKER
//    func showTimePicker(_ textField : UITextField){
//
//        timePicker = UIDatePicker()
//        timePicker?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
//        timeToolbar?.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
//        timePicker?.minimumDate = NSDate() as Date
//        timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
//        timePicker?.datePickerMode = .time
//
//        timePicker?.backgroundColor = UIColor.white
//        timeToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
//        timeToolbar?.barStyle = .blackOpaque
//        timeToolbar?.autoresizingMask = .flexibleWidth
//        timeToolbar?.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
//
//        timeToolbar?.frame = CGRect(x: 0,y: (timePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
//        timeToolbar?.barStyle = UIBarStyle.default
//        timeToolbar?.isTranslucent = true
//        timeToolbar?.tintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
//        timeToolbar?.backgroundColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
//        timeToolbar?.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done" , style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerTime))
//        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel" , style: UIBarButtonItem.Style.plain, target: self, action: #selector(canclePickerTime))
//        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
//        timeToolbar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        timeToolbar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
//
//         textField.inputView = timePicker
//         textField.inputAccessoryView = timeToolbar
//        // self.txt_time.semanticContentAttribute
//
//    }
    
    
    
    
    
    func showTimePicker(_ textField : UITextField){
       
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 30
        //ToolBar
        var toolbar = UIToolbar();
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.barStyle = .default
        toolbar.autoresizingMask = .flexibleWidth
        toolbar.barTintColor = #colorLiteral(red: 0.3411764706, green: 0.3764705882, blue: 0.4862745098, alpha: 1)
        
        toolbar.frame = CGRect(x: 0,y:(datePicker.frame.origin.y)-44, width: self.view.frame.size.width,height: 44)
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolbar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerTime));
        doneButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(canclePickerTime));
        cancelButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        
    }

    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == self.monOpenTF)
        {
            textfieldCheckValue = 1
            self.showTimePicker(self.monOpenTF)
           
        }
        else if (textField == self.monCloseTF) {
            textfieldCheckValue = 2
            self.showTimePicker(self.monCloseTF)
        }
        
        else if (textField == tuesopenTF)
        {
            textfieldCheckValue = 3
            self.showTimePicker(self.tuesopenTF)
            
        }
        else if (textField == tuesCloseTF) {
            textfieldCheckValue = 4
            
            self.showTimePicker(self.tuesCloseTF)
        }
        
        else if (textField == self.wedOpenTF) {
            
            textfieldCheckValue = 5
            
            self.showTimePicker(self.wedOpenTF)
        }
            
        else if (textField == wedCloseTF)
        {
            textfieldCheckValue = 6
            self.showTimePicker(self.wedCloseTF)
            
        }
        else if (textField == thuOpenTF) {
            textfieldCheckValue = 7
            
            self.showTimePicker(self.thuOpenTF)
        }
        else if (textField == thuCloseTF) {
            textfieldCheckValue = 8
            
            self.showTimePicker(self.thuCloseTF)
        }
            
        else if (textField == self.friOpenTF) {
            textfieldCheckValue = 9
            
            self.showTimePicker(self.friOpenTF)
        }
            
        else if (textField == friCloseTF)
        {
            textfieldCheckValue = 10
            self.showTimePicker(self.friCloseTF)
            
        }
        else if (textField == satOpenTF) {
            textfieldCheckValue = 11
            
            self.showTimePicker(self.satOpenTF)
        }
        else if (textField == satCloseTF) {
            textfieldCheckValue = 12
            
            self.showTimePicker(self.satCloseTF)
        }
            
        else if (textField == self.sunOpenTF) {
            textfieldCheckValue = 13
            
            self.showTimePicker(self.sunOpenTF)
        }
            
        else if (textField == sunCloseTF)
        {
            textfieldCheckValue = 14
            self.showTimePicker(self.sunCloseTF)
            
        }
    }
    
  
    //MARK:DONE PICKER TIME
    @objc func donePickerTime ()
    {
        timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        // txt_time.textAlignment = NSTextAlignment.left
        
        if textfieldCheckValue == 1
        {
            
            //txt_StartTime.text = formatter.string(from: datePicker.date)
        monOpenTF.text! = formatter.string(from: (datePicker.date))
        self.view.endEditing(true)
        monOpenTF.resignFirstResponder()
            
        }
        else if textfieldCheckValue == 2
        {
            monCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            monCloseTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 3
        {
            tuesopenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            tuesopenTF.resignFirstResponder()
            
        }
        else if textfieldCheckValue == 4
        {
            tuesCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            tuesCloseTF.resignFirstResponder()
        }
        
        else if textfieldCheckValue == 5
        {
            wedOpenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            wedOpenTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 6
        {
            wedCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            wedCloseTF.resignFirstResponder()
            
        }
        else if textfieldCheckValue == 7
        {
            thuOpenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            thuOpenTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 8
        {
            thuCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            thuCloseTF.resignFirstResponder()
        }
            
        else if textfieldCheckValue == 9
        {
            friOpenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            friOpenTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 10
        {
            friCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            friCloseTF.resignFirstResponder()
            
        }
        else if textfieldCheckValue == 11
        {
            satOpenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            satOpenTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 12
        {
            satCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            satCloseTF.resignFirstResponder()
        }
        else if textfieldCheckValue == 13
        {
            sunOpenTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            sunOpenTF.resignFirstResponder()
            
        }
        else if textfieldCheckValue == 14
        {
            sunCloseTF.text! = formatter.string(from: (datePicker.date))
            self.view.endEditing(true)
            sunCloseTF.resignFirstResponder()
        }
        
        
        
    }
    
    //MARK:CANCEL PICKER TIME
    @objc func canclePickerTime ()
    {
        self.view.endEditing(true)
        //mondayOpenTimeLbl.resignFirstResponder()
    }
    
    @IBAction func showOrHideBtnTap(_ sender: Any)
    {
        if hideOrShow == false
        {
            timeHideorShow = "1"
            //availableTimingHt.constant = 270.5
            //availabilityView.isHidden = false
            
            showOrHideTime.setImage(UIImage(named: "Switch"), for: UIControl.State.normal)
            
            hideOrShow = true
        }
        else
        {
            timeHideorShow = "0"
           // availableTimingHt.constant = 0
           // availabilityView.isHidden = true
               showOrHideTime.setImage(UIImage(named: "off1"), for: UIControl.State.normal)
            hideOrShow = false
        }
        
    }
    
    
    @IBAction func availBtnTap(_ sender: Any)
    {
        
        if checkavail == false
        {
            availabityOrNot = "1"
            availBtn.setTitle(languageChangeString(a_str:"Available"), for: UIControl.State.normal)
            //availBtn.backgroundColor = UIColor(red: 50/255, green: 174/255, blue: 0/255, alpha: 1)
            
            checkavail = true
        }
        else
        {
            availabityOrNot = "0"
            availBtn.setTitle(languageChangeString(a_str:"UnAvailable"), for: UIControl.State.normal)
            //availBtn.backgroundColor = UIColor(red: 161/255, green: 144/255, blue: 129/255, alpha: 1)
            checkavail = false
        }
        
//        if self.availabityOrNot == "1"
//        {
//            availBtn.setTitle("Available", for: UIControl.State.normal)
//        }
//        if self.availabityOrNot == "0"
//        {
//            availBtn.setTitle("Unavailable", for: UIControl.State.normal)
//        }
//
    }
    
    
    func SPProfile()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let profileData = "\(base_path)services/profile?"
            
            //            https://www.volive.in/spsalon/services/profile
            //            api_key:2382019
            //            lang:en
            //            user_id:
            
            let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"user_id":myuserID]
            
            print(parameters)
            
            Alamofire.request(profileData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    self.bannersImage.removeAll()
                    self.bannersIdArr.removeAll()
                    self.bannerTitleArr.removeAll()
                    
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                       
                        
                        if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                            
                            print(userDetailsData)
                            
                            if let userName = userDetailsData["name"] as? String
                            {
                                self.name = userName
                            }
                            if let emailId = userDetailsData["email"] as? String
                            {
                                self.email = emailId
                            }
                            if let phoneNo = userDetailsData["phone"] as? String
                            {
                                self.phone = phoneNo
                            }
                            if let display_pic = userDetailsData["display_pic"] as? String
                            {
                                self.providerImage = base_path+display_pic
                            }
                            if let iban_number = userDetailsData["iban_number"] as? String
                            {
                                self.ibanNoData = iban_number
                            }
                            if let employees = userDetailsData["employees"] as? String
                            {
                                self.numberOfEmployees = employees
                            }
                            if let service_type = userDetailsData["service_type"] as? String
                            {
                                self.TypeOfService = service_type
                            }
                          
                            if let  avalability_status = userDetailsData["avalability_status"] as? String
                            {
                                self.availabityOrNot =  avalability_status
                            }
                            
                            
                             if let timings = userDetailsData["timings"] as? Dictionary<String, AnyObject>
                             {
                                
                                if let timing_id = timings["timing_id"] as? String
                                {
                                    self.timingIdofOwner = timing_id
                                }
                                
                                if let monday_open = timings["monday_open"] as? String
                                {
                                    self.mondayOpenTime = monday_open
                                }
                                if let monday_close = timings["monday_close"] as? String
                                {
                                    self.mondayCloseTime = monday_close
                                }
                                if let tuesday_open = timings["tuesday_open"] as? String
                                {
                                    self.tuedayOpenTime = tuesday_open
                                }
                                if let tuesday_close = timings["tuesday_close"] as? String
                                {
                                    self.tuedayCloseTime = tuesday_close
                                }
                                if let wednesday_open = timings["wednesday_open"] as? String
                                {
                                    self.weddayOpenTime = wednesday_open
                                }
                                if let wednesday_close = timings["wednesday_close"] as? String
                                {
                                    self.weddayCloseTime = wednesday_close
                                }
                                if let thursday_open = timings["thursday_open"] as? String
                                {
                                    self.thursdayOpenTime = thursday_open
                                }
                                if let thursday_close = timings["thursday_close"] as? String
                                {
                                    self.thursdayCloseTime = thursday_close
                                }
                                if let friday_open = timings["friday_open"] as? String
                                {
                                    self.fridayOpenTime = friday_open
                                }
                                if let friday_close = timings["friday_close"] as? String
                                {
                                    self.fridayCloseTime = friday_close
                                }
                                if let saturday_open = timings["saturday_open"] as? String
                                {
                                    self.satdayOpenTime = saturday_open
                                }
                                if let saturday_close = timings["saturday_close"] as? String
                                {
                                    self.satdayCloseTime = saturday_close
                                }
                                if let sunday_open = timings["sunday_open"] as? String
                                {
                                    self.sundayOpenTime = sunday_open
                                }
                                if let sunday_close = timings["sunday_close"] as? String
                                {
                                    self.sundayCloseTime = sunday_close
                                }
                                if let status = timings["status"] as? String
                                {
                                    self.timeHideorShow = status
                                }
                            }
                            
                            if let banners = userDetailsData["banners"] as? [[String:Any]]
                            {
                                
                                for i in 0..<banners.count
                                {
                                    if let image = banners[i]["banner_image"] as? String
                                    {
                                        self.bannersImage.append(base_path+image)
                                    }
                                    if let banner_id = banners[i]["banner_id"] as? String
                                    {
                                        self.bannersIdArr.append(banner_id)
                                    }
                                    if let title_en = banners[i]["title_en"] as? String
                                    {
                                        self.bannerTitleArr.append(title_en)
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                        }
                       
                        DispatchQueue.main.async {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            self.nameTF.text = self.name
                            self.emailTF.text = self.email
                            self.phoneTF.text = self.phone
                             UserDefaults.standard.set(self.providerImage as Any, forKey: "pic")
                            self.providerImg.layer.borderWidth = 1
                            self.providerImg.clipsToBounds = true
                            self.providerImg.layer.cornerRadius = self.providerImg.frame.size.width/2
                            self.providerImg.layer.masksToBounds = true
                            self.providerImg.sd_setImage(with: URL (string: self.providerImage), placeholderImage:
                                UIImage(named: ""))
                            
                            self.monOpenTF.text = self.mondayOpenTime
                            self.monCloseTF.text = self.mondayCloseTime
                            self.tuesopenTF.text = self.tuedayOpenTime
                            self.tuesCloseTF.text = self.tuedayCloseTime
                            self.wedOpenTF.text = self.weddayOpenTime
                            self.wedCloseTF.text = self.weddayCloseTime
                            self.thuOpenTF.text = self.thursdayOpenTime
                            self.thuCloseTF.text = self.thursdayCloseTime
                            self.friOpenTF.text = self.fridayOpenTime
                            self.friCloseTF.text = self.fridayCloseTime
                            self.satOpenTF.text = self.satdayOpenTime
                            self.satCloseTF.text = self.satdayCloseTime
                            self.sunOpenTF.text = self.sundayOpenTime
                            self.sunCloseTF.text = self.sundayCloseTime
                            self.picturesCollectionView.reloadData()
                            
                            self.ibanNoTF.text = self.ibanNoData
                            
                            self.picturesCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                            
                            self.view.layoutIfNeeded()
                            
//                            if checkavail == false
//                            {
//                                availabityOrNot = "1"
//                                availBtn.setTitle("Available", for: UIControl.State.normal)
//                                checkavail = true
//                            }
//                            else
//                            {
//                                availabityOrNot = "0"
//
//                                checkavail = false
//                            }
                            
                            
                            if self.availabityOrNot == "1"
                            {
                                self.checkavail = true
                                self.availBtn.setTitle(self.languageChangeString(a_str:"Available"), for: UIControl.State.normal)
                                 //self.availBtn.backgroundColor = UIColor(red: 50/255, green: 174/255, blue: 0/255, alpha: 1)
                                
                            }
                            else
                            {
                                self.checkavail = false
                                self.availBtn.setTitle(self.languageChangeString(a_str:"UnAvailable"), for: UIControl.State.normal)
                                // self.availBtn.backgroundColor = UIColor(red: 161/255, green: 144/255, blue: 129/255, alpha: 1)
                            }
                            
                            if self.timeHideorShow == "1"
                            {
                                self.hideOrShow = true
                                //self.availableTimingHt.constant = 270.5
                                // self.availabilityView.isHidden = false
                                self.showOrHideTime.setImage(UIImage(named: "Switch"), for: UIControl.State.normal)
                                self.view.layoutIfNeeded()
                            }
                            else
                            {
                                self.hideOrShow = false
                                //self.availableTimingHt.constant = 0
                                 //self.availabilityView.isHidden = true
                                self.showOrHideTime.setImage(UIImage(named: "off1"), for: UIControl.State.normal)
                            }
                            
                             self.view.layoutIfNeeded()
                        }
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        print(message)
                    }
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
        
        
        picturesCollectionView.layer.removeAllAnimations()
        picsCollectionHt.constant = picturesCollectionView.contentSize.height
        
        UIView.animate(withDuration: 0.0) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func uploadImgBtnTap(_ sender: Any) {
        
        self.checkStr = "2"
        
        let alert = UIAlertController(title:languageChangeString(a_str:"Choose Image"), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title:languageChangeString(a_str:"Camera"), style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title:languageChangeString(a_str:"Gallery"), style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func bannerAddBtnTap(_ sender: Any)
    {
//        checkStr = "1"
//
//        checkPhotoLibraryPermission()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBannerViewController")as! AddBannerViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
 }

extension SPProfileViewController :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return bannersImage.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.picturesCollectionView.dequeueReusableCell(withReuseIdentifier: "picsCell", for: indexPath) as! PicturesCollectionViewCell
        cell.picImageView.sd_setImage(with: URL (string: self.bannersImage[indexPath.row]), placeholderImage:
            UIImage(named: "Group"))
        cell.nameLabel.text = bannerTitleArr[indexPath.row]
        if checkValue == 2
        {
         cell.deleteBtn.isHidden = false
         cell.deleteBtn.tag = indexPath.row
         cell.deleteBtn.addTarget(self, action: #selector(deleteBanner(sender:)), for: .touchUpInside)
        }
        else
        {
            cell.deleteBtn.isHidden = true
        }
        
        return cell
    }
    
    
    @objc func deleteBanner(sender:UIButton) {
        
        print(bannersIdArr)
     
        let sectionId = sender.tag
        print("section tap is :\(sectionId)")
      
        
        let bannerId = bannersIdArr[sender.tag]
        
        bannersServiceCall(id: bannerId)
      
    }
    
    func bannersServiceCall(id:String)
    {
        
        
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/delete_banner"
            
//            https://www.volive.in/spsalon/services/delete_banner
//            SP module
//
//            Delete banner Image
//
//            api_key:2382019
//            lang:en
//            user_id:79
//            banner_id:24
            
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":language,"api_key":APIKEY,"user_id":ownerId,"banner_id":id]
            
            
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
                        
                        self.bannersImage.removeAll()
                        self.bannersIdArr.removeAll()
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                           self.showToastForAlert(message: message)
                            
                            
                            if let userDetailsData = responseData?["banners"] as? [[String:Any]]
                            {
                                for i in 0..<userDetailsData.count
                                {
                                    if let image = userDetailsData[i]["banner_image"] as? String
                                    {
                                        self.bannersImage.append(base_path+image)
                                    }
                                    if let banner_id = userDetailsData[i]["banner_id"] as? String
                                    {
                                        self.bannersIdArr.append(banner_id)
                                    }
                                }
                                
                                self.picturesCollectionView.reloadData()
                                
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
            self.showToastForAlert(message:languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        print(width * 0.33)
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.28, height:95)
        //return CGSize(width: 100.0,height: 94.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension SPProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            showToastForAlert(message: languageChangeString(a_str: "You don't have camera")!)
            
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
     
        
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
//        if checkStr == "1"
//        {
//            self.bannerImage = image
//             self.postAProduct1(myPicture: bannerImage)
//
//        }
//        else if checkStr == "2"
//        {
        self.providerImg.image = image
        pickedImage = image
        self.providerImg.layer.borderWidth = 1
        self.providerImg.layer.masksToBounds = false
        self.providerImg.layer.cornerRadius = self.providerImg.frame.height/2
        self.providerImg.clipsToBounds = true
       // }
        
       
       // self.postAProduct(lang:"en" , myPicture: image)
    }
    
    func alertController (title: String,msg: String) {
        
        let alert = UIAlertController.init(title:title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: languageChangeString(a_str: "Ok"), style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func postAProduct1(myPicture: UIImage)
    {
        if Reachability.isConnectedToNetwork()
        {
            
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            
//            https://www.volive.in/spsalon/services/add_spbanner
//            SP module
//
//            add banner Image
//
//            api_key:2382019
//            lang:en
//            user_id:79
//            title_ar:ar
//            title_en:en
//            banner_image:(image field name)
            
                let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"user_id":myuserID,"title_ar":"2","title_en":"en"]
                
                print(parameters)
            
            
                
                let  url = "\(base_path)services/add_spbanner"
                
            
                
                print(url)
                
                var imageData1 = Data()
                
            
                if let imgData = bannerImage.jpegData(compressionQuality: 0.1)
                {
                    imageData1 = imgData
                }
            
                Alamofire.upload(multipartFormData: { multipartFormData in
                    
                    // import image to request
                    
                    multipartFormData.append(imageData1, withName: "banner_image", fileName: "file.jpg", mimeType: "image/jpeg")
                    
                    
                    for (key, value) in parameters {
                        
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    
                }, to: url,method:.post,
                   
                   encodingCompletion:
                    { (result) in
                        switch result {
                        case .success(let upload, _, _):
                            
                            upload.responseJSON{ response in
                                
                                 MobileFixServices.sharedInstance.dissMissLoader()
                             
                                
                                print("response data is :\(response)")
                                
                                if let responseData = response.result.value as? Dictionary <String,Any>{
                                    
                                    print(responseData)
                                    let status = responseData["status"] as! Int
                                    let message = responseData ["message"] as! String
                                    //self.showToastForAlert(message: message)
                                
                                    self.bannersImage.removeAll()
                                    self.bannersIdArr.removeAll()
                                    
                                    if status == 1{
                                        
                                        //self.showToastForAlert(message: message)
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                        if let userDetailsData = responseData["banners"] as? [[String:Any]]
                                        {
                                            for i in 0..<userDetailsData.count
                                            {
                                                if let image = userDetailsData[i]["banner_image"] as? String
                                                {
                                                    self.bannersImage.append(base_path+image)
                                                }
                                                if let banner_id = userDetailsData[i]["banner_id"] as? String
                                                {
                                                    self.bannersIdArr.append(banner_id)
                                                }
                                            }
                                            
                                            self.picturesCollectionView.reloadData()
                                            
                                        }
                                        
                                        
                                        
                                        
                                    }else{
                                        self.showToastForAlert(message: message)
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                        
                                    }
                                }
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            
                        }
                        
                })
            
            
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: "Please ensure you have proper internet connection")
            
        }
    }
    
    func postAProduct(lang:String , myPicture: UIImage)
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.passwordTF.text == self.confirmPassTF.text
            {
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
                
                
                let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"name":nameTF.text ?? "","phone":phoneTF.text ?? "","user_id":myuserID,"user_type":"2","new_password":self.passwordTF.text ?? "","confirm_password":self.confirmPassTF.text ?? "","employees":numberOfEmployees ,"iban_number":ibanNoTF.text ?? "" ,"service_type":TypeOfService,"avail_status":availabityOrNot,"timing_show":timeHideorShow]
                
                print(parameters)
            
                //            https://www.volive.in/spsalon/services/update_profile
                
                //            user_id:
                //            user_type: (1->user, 2->owner)
                //            api_key:2382019
                //            lang:en
                //            name:
                //            phone:
                //            gender: (1->male, 2->female)(Optional)
                //            display_pic
                //            new_password
                //            confirm_password
//                employees:
//                iban_number:
//                service_type: (option id)
                
                let  url = "\(base_path)services/update_profile"
                
                //"https://www.volive.in/spsalon/services/update_profile"
               
                print(url)
                
                var imageData1 = Data()
                
                pickedImage = self.providerImg.image!
                
                if let imgData = pickedImage.jpegData(compressionQuality: 0.1)
                {
                    imageData1 = imgData
                }
                //print(imageData1)
                Alamofire.upload(multipartFormData: { multipartFormData in
                    
                    // import image to request
                    
                    multipartFormData.append(imageData1, withName: "display_pic", fileName: "file.jpg", mimeType: "image/jpeg")
                    
                    
                    for (key, value) in parameters {
                        
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    
                }, to: url,method:.post,
                   
                   encodingCompletion:
                    { (result) in
                        switch result {
                        case .success(let upload, _, _):
                            
                            upload.responseJSON{ response in
                                
                                print("response data is :\(response)")
                                
                                if let responseData = response.result.value as? Dictionary <String,Any>{
                                    
                                    print(responseData)
                                    let status = responseData["status"] as! Int
                                    let message = responseData ["message"] as! String
                                    
                                    if status == 1{
                                        
                                        UserDefaults.standard.set(self.passwordTF.text, forKey: "password")
                                        
                                        if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                                            
                                            print(userDetailsData)
                                            
                                            if let userName = userDetailsData["name"] as? String
                                            {
                                                self.name = userName
                                            }
                                            if let emailId = userDetailsData["email"] as? String
                                            {
                                                self.email = emailId
                                            }
                                            if let phoneNo = userDetailsData["phone"] as? String
                                            {
                                                self.phone = phoneNo
                                            }
                                            if let display_pic = userDetailsData["display_pic"] as? String
                                            {
                                                self.providerImage = base_path+display_pic
                                            }
                                            if let iban_number = userDetailsData["iban_number"] as? String
                                            {
                                                self.ibanNoData = iban_number
                                            }
                                            if let approve_status = userDetailsData["avalability_status"] as? String
                                            {
                                                self.availabityOrNot = approve_status
                                            }
                                            
                                            if let status = userDetailsData["status"] as? String
                                            {
                                                self.timeHideorShow = status
                                            }
                                          
                                            
            
                                        }
                                        
                                        DispatchQueue.main.async {
                                            self.showToastForAlert(message: message)
                                            MobileFixServices.sharedInstance.dissMissLoader()
                                            
                                            //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                            
                                            self.nameTF.text = self.name
                                            self.emailTF.text = self.email
                                            self.phoneTF.text = self.phone
                                            self.ibanNoTF.text = self.ibanNoData
                                            UserDefaults.standard.set(self.providerImage as Any, forKey: "pic")
                                    self.providerImg.sd_setImage(with: URL (string: self.providerImage), placeholderImage:
                                                UIImage(named: ""))
                                       UserDefaults.standard.set(self.passwordTF.text, forKey: "password")
                                            
                                            if self.timeHideorShow == "1"
                                            {
                                                self.hideOrShow = true
                                                //self.availableTimingHt.constant = 270.5
                                                //self.availabilityView.isHidden = false
                                                self.showOrHideTime.setImage(UIImage(named: "Switch"), for: UIControl.State.normal)
                                                self.view.layoutIfNeeded()
                                            }
                                            else
                                            {
                                                self.hideOrShow = false
                                                //self.availableTimingHt.constant = 0
                                                //self.availabilityView.isHidden = true
                                                self.showOrHideTime.setImage(UIImage(named: "off1"), for: UIControl.State.normal)
                                            }
                                            
                                            if self.availabityOrNot == "1"
                                            {
                                                self.checkavail = true
                                                self.availBtn.setTitle(self.languageChangeString(a_str:"Available"), for: UIControl.State.normal)
                                                //self.availBtn.backgroundColor = UIColor(red: 50/255, green: 174/255, blue: 0/255, alpha: 1)
                                                
                                            }
                                            else
                                            {
                                                self.checkavail = false
                                                self.availBtn.setTitle(self.languageChangeString(a_str:"UnAvailable"), for: UIControl.State.normal)
                                                // self.availBtn.backgroundColor = UIColor(red: 161/255, green: 144/255, blue: 129/255, alpha: 1)
                                            }
                                            
                                            self.view.layoutIfNeeded()
                                            
                                            
                                           // self.SPProfile()
                                            
                                        }
                                        
                                    }else{
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                        self.showToastForAlert(message: message)
                                        
                                    }
                                }
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                        }
                        
                })
            }
            else
            {
                showToastForAlert(message: languageChangeString(a_str:"password and confirm password are different")!)
                self.passwordTF.text = UserDefaults.standard.object(forKey: "password") as? String
                self.confirmPassTF.text = UserDefaults.standard.object(forKey: "password") as? String
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
    func timingsUpdate()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let timingsUrl = "\(base_path)services/update_timings"
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = ["api_key":APIKEY,
                "lang":language,"timing_id":timingIdofOwner,"user_id":userId,"monday_open":monOpenTF.text ?? "",
                "monday_close":monCloseTF.text ?? "","tuesday_open":tuesopenTF.text ?? "","tuesday_close":tuesCloseTF.text ?? "",
                "wednesday_open":wedOpenTF.text ?? "","wednesday_close":wedCloseTF.text ?? "",
                "thursday_open":thuOpenTF.text ?? "","thursday_close":thuCloseTF.text ?? "",
                "friday_open":friOpenTF.text ?? "",
                "friday_close":friCloseTF.text ?? "",
                "saturday_open":satOpenTF.text ?? "",
                "saturday_close":satCloseTF.text ?? "",
                "sunday_open":sunOpenTF.text ?? "",
                "sunday_close":sunCloseTF.text ?? ""]
            
            
            
            print(parameters)
            
            Alamofire.request(timingsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                   
                    print(responseData)
                    
                    if status == 1
                    {

                        //self.showToastForAlert(message: message)
                         //self.SPProfile()
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        //self.showToastForAlert(message: message)
                        
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        }
        
    }
    
    
    
    
    
    
}

