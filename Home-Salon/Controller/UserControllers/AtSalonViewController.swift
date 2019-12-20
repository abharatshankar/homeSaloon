//
//  AtSalonViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 01/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class AtSalonViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var chooseurOptionSt: UILabel!
    @IBOutlet var nowBtn: UIButton!
    @IBOutlet var scheduledBtn: UIButton!
    var typeCheckString = ""
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var timeTF: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var timeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet var selectTimeHeaderLabel: UILabel!
    
    @IBOutlet var selectDateHeaderLabel: UILabel!
   
    
    var timePicker : UIDatePicker?
    var timeToolbar: UIToolbar?
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    @IBOutlet var timeImageView: UIImageView!
    @IBOutlet var timeBottomView: UIView!
    
    @IBOutlet var dateBottomView: UIView!
    @IBOutlet var dateImageView: UIImageView!
    
    var userLocation = ""
    var userLongitude = ""
    var userLatitude = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nowBtn.backgroundColor = #colorLiteral(red: 0.631372549, green: 0.5647058824, blue: 0.5058823529, alpha: 1)
        self.scheduledBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
       
        
        scheduledBtn.setTitleColor(UIColor.init(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        nowBtn.setTitleColor(UIColor.init(red: 234.0/255.0, green: 233.0/255.0, blue: 229.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        
        //self.scheduleView.isHidden = true
        submitBtn.isHidden = true
        self.typeCheckString = "now"
        self.title = "At the salon"
        
        self.timeViewHeight.constant = 0
        self.timeView.isHidden = true
        
//        self.timeImageView.isHidden = true
//        self.dateImageView.isHidden = true
//        self.timeTF.isHidden = true
//        self.dateTF.isHidden = true
//        self.timeBottomView.isHidden = true
//        self.dateBottomView.isHidden = true
//
//        self.timeStackView.isHidden = true
//        self.ampmStackView.isHidden = true
//        self.checkBoxStackView.isHidden = true
//        self.selectTimeHeaderLabel.isHidden = true
//        self.selectDateHeaderLabel.isHidden = true
//
//        self.submitBtn.isHidden = true
//        self.timeBtn1.isHidden = true
//        self.timeBtn2.isHidden = true
//        self.timeBtn3.isHidden = true
//        self.timeBtn4.isHidden = true
        
        //self.amCheckBtn.setImage(UIImage.init(named: "radio_on_light"), for: UIControl.State.normal)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        

        self.showTimePicker()
        self.showDatePicker()
        
        self.chooseurOptionSt.text = languageChangeString(a_str: "Choose your option")
        self.selectDateHeaderLabel.text = languageChangeString(a_str: "Select Date")
        self.selectTimeHeaderLabel.text = languageChangeString(a_str: "Select Time")
        self.timeTF.placeholder = languageChangeString(a_str: "Time")
        self.dateTF.placeholder = languageChangeString(a_str: "Date")
        self.nowBtn.setTitle(languageChangeString(a_str: "NOW"), for: UIControl.State.normal)
        self.scheduledBtn.setTitle(languageChangeString(a_str: "SCHEDULED"), for: UIControl.State.normal)
         self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
        filterApplied = false
        totalAmount = []
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceListVC")as! ServiceListVC
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.popViewController(animated: true)
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

        let doneButton = UIBarButtonItem(title: languageChangeString(a_str: "Done") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.donePickerTime))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: languageChangeString(a_str: "Cancel") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.canclePickerTime))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        timeToolbar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeToolbar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.timeTF.inputView = timePicker
        self.timeTF.inputAccessoryView = timeToolbar
    
        
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

        let doneButton = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.donePickerDate))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(AtSalonViewController.canclePickerDate))
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
        formatter.dateFormat = "yyyy-MM-dd"
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
    
    @IBAction func amBtnAction(_ sender: Any) {
       
        
    }
    
    @IBAction func pmBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func nowBtnAction(_ sender: Any) {
        
        self.timeView.isHidden = true
        self.timeViewHeight.constant = 0
        self.submitBtn.isHidden = true
        
        self.nowBtn.backgroundColor = #colorLiteral(red: 0.631372549, green: 0.5647058824, blue: 0.5058823529, alpha: 1)
        self.scheduledBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)

        scheduledBtn.setTitleColor(UIColor.init(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        nowBtn.setTitleColor(UIColor.init(red: 234.0/255.0, green: 233.0/255.0, blue: 229.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        self.typeCheckString = "now"
       
        //self.scheduleView.isHidden = true
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1)
        {
        
     let now = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserScheduleViewController") as! UserScheduleViewController
        typeString = self.typeCheckString
            now.location = self.userLocation
            now.longitude = self.userLongitude
            now.latitude = self.userLatitude
        
        self.navigationController?.pushViewController(now, animated: true)
        }
        
       // self.timeViewHeight.constant = 0
      //  self.scheduleView.isHidden = false
        
//        self.timeImageView.isHidden = true
//        self.dateImageView.isHidden = true
//        self.timeTF.isHidden = true
//        self.dateTF.isHidden = true
//        self.timeBottomView.isHidden = true
//        self.dateBottomView.isHidden = true
//
        
//        self.timeStackView.isHidden = true
//        self.ampmStackView.isHidden = true
//        self.checkBoxStackView.isHidden = true
        //self.selectTimeHeaderLabel.isHidden = true
        //self.selectDateHeaderLabel.isHidden = true
       // self.submitBtn.isHidden = true
//        self.timeBtn1.isHidden = true
//        self.timeBtn2.isHidden = true
//        self.timeBtn3.isHidden = true
//        self.timeBtn4.isHidden = true
    }
    @IBAction func scheduleBtnAction(_ sender: Any) {
        
        self.scheduledBtn.backgroundColor = #colorLiteral(red: 0.631372549, green: 0.5647058824, blue: 0.5058823529, alpha: 1)
        self.nowBtn.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
     
        nowBtn.setTitleColor(UIColor.init(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0), for: UIControl.State.normal)
        scheduledBtn.setTitleColor(UIColor.init(red: 234.0/255.0, green: 233.0/255.0, blue: 229.0/255.0, alpha: 1.0), for: UIControl.State.normal)
       // self.scheduleView.isHidden = false
         self.submitBtn.isHidden = false
        self.typeCheckString = "schedule"
        self.timeView.isHidden = false
        self.timeViewHeight.constant = 100
       
        // self.scheduleView.isHidden = true
       // self.scheduledBtn.backgroundColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        //self.nowBtn.backgroundColor = UIColor.init(red: 234.0/255.0, green: 233.0/255.0, blue: 229.0/255.0, alpha: 1.0)
       
        
        //self.timeViewHeight.constant = 150
//        self.timeImageView.isHidden = false
//        self.dateImageView.isHidden = false
//        self.timeTF.isHidden = false
//        self.dateTF.isHidden = false
//        self.timeBottomView.isHidden = false
//        self.dateBottomView.isHidden = false
        
        
//        self.timeStackView.isHidden = false
//        self.ampmStackView.isHidden = false
//        self.checkBoxStackView.isHidden = false
        
        
//        self.selectTimeHeaderLabel.isHidden = false
//        self.selectDateHeaderLabel.isHidden = false
        
        
      //  self.submitBtn.isHidden = false
//        self.timeBtn1.isHidden = false
//        self.timeBtn2.isHidden = false
//        self.timeBtn3.isHidden = false
//        self.timeBtn4.isHidden = false
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
         if timeTF.text == "" && dateTF.text == ""
         {
            showToastForAlert(message: languageChangeString(a_str:"Please select Schedule Date and Time")!)
            return
        }
        else
         {

            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserScheduleViewController") as! UserScheduleViewController
             typeString = self.typeCheckString
        
        
       // UserDefaults.standard.set(self.timeTF.text ?? "" as String, forKey: "Stime")
       // UserDefaults.standard.set(self.dateTF.text ?? "" as String, forKey: "Sdate")
          
            self.navigationController?.pushViewController(vc, animated: true)
         }
       }
    
    
}
