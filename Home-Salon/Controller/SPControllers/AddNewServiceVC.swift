
//  AddNewServiceVC.swift
//  SPScreen
//
//  Created by volive solutions on 26/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire

class AddNewServiceVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var selectCatSt: UILabel!
    @IBOutlet weak var category_View: UIView!
    @IBOutlet weak var cancel_Btn: UIButton!
    @IBOutlet weak var save_Btn: UIButton!
    @IBOutlet weak var subCategorie_View: UIView!
    @IBOutlet weak var price_View: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var subcategoryTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var subCatSt: UILabel!
    
    @IBOutlet weak var servicePriceSt: UILabel!
    
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
    var price = ""
    
    var serviceIdUpdate = ""
     var catIdUpdate = ""
    
    var subCategory_idArray = [String]()
    var subCategoryNameArray = [String]()
    var subCatString : String! = ""
    var subCatIdString : String! = ""
    var serviceType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = languageChangeString(a_str:"ADD NEW SERVICE")
        
        categoryTF.delegate = self
        subcategoryTF.delegate = self
        
        category_View.setBorder(radius: 4, color: UIColor.lightGray)
        subCategorie_View.setBorder(radius: 4, color: UIColor.lightGray)
        price_View.setBorder(radius: 4, color: UIColor.lightGray)

        save_Btn.setBorder(radius: 25, color: UIColor.clear)
        cancel_Btn.setBorder(radius: 25, color: #colorLiteral(red: 0.6192678809, green: 0.5514480472, blue: 0.4977337122, alpha: 1))
        
        self.selectCatSt.text = languageChangeString(a_str: "Select category")
        self.subCatSt.text = languageChangeString(a_str: "Subcategories")
        self.servicePriceSt.text = languageChangeString(a_str: "Service price")
        self.save_Btn.setTitle(languageChangeString(a_str: "SAVE"), for: UIControl.State.normal)
        self.cancel_Btn.setTitle(languageChangeString(a_str: "CANCLE"), for: UIControl.State.normal)
        
        if language == "ar"
        {
            self.categoryTF.textAlignment = .right
            self.categoryTF.setPadding(left: -10, right: -10)
            self.subcategoryTF.textAlignment = .right
            self.subcategoryTF.setPadding(left: -10, right: -10)
            self.priceTF.textAlignment = .right
            self.priceTF.setPadding(left: -10, right: -10)
            
            
            
        }
        else if language == "en"{
            
            self.categoryTF.textAlignment = .left
            self.categoryTF.setPadding(left: 10, right: 10)
            self.subcategoryTF.textAlignment = .left
            self.subcategoryTF.setPadding(left: 10, right: 10)
            self.priceTF.textAlignment = .left
            self.priceTF.setPadding(left: 10, right: 10)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        //self.navigationController?.popViewController(animated: true)
        
          let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListOfServicesVC") as! ListOfServicesVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
       if self.serviceType == "update"
       {
          self.editServiceData()
        
        self.navigationItem.title = languageChangeString(a_str:"Edit service")
        }
    }
    
    
    @IBAction func cancelBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListOfServicesVC") as! ListOfServicesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        addNewServiceCall()

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
        toolBar.barTintColor = #colorLiteral(red: 0.3413005471, green: 0.3760688007, blue: 0.4844334126, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
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
                self.subcategoryTF.text = self.subCatString
                
                subCatIdString = subCategory_idArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
                if subCatString.count > 0{
                    self.subcategoryTF.text = self.subCatString ?? ""
                }else{
                    self.subcategoryTF.text = subCategoryNameArray[0]
                }
                self.view.endEditing(true)
                subcategoryTF.resignFirstResponder()
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
            
            if (subcategoryTF.text?.count)! > 0 {
                self.view.endEditing(true)
                subcategoryTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                subcategoryTF.text = ""
                subcategoryTF.resignFirstResponder()
            }
            subcategoryTF.resignFirstResponder()
            
            print("subcatageory cancel")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == self.categoryTF)
        {
            textfieldCheckValue = 1
            catageoriesData()
            self.subcategoryTF.text = ""
            self.pickUp(self.categoryTF)
        }
        else if (textField == subcategoryTF) {
            textfieldCheckValue = 2
            if catIdString == ""{
                showToastForAlert (message: languageChangeString(a_str:"Please Select Category")!)
                self.subcategoryTF.resignFirstResponder()
            }
            else{
                subCatageoriesData()
                self.pickUp(self.subcategoryTF)
                }
            }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == self.categoryTF)
        {
            return true
        }
        else if (textField == subcategoryTF) {
            
            if catIdString == ""{
                
                return false
                
            }
            else{
                subCategory_idArray.removeAll()
                subCategoryNameArray.removeAll()
                
                return true
                
            }
            
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
            //            Sub categories list (POST method)
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
                        self.subcategoryTF.resignFirstResponder()
                        self.showToastForAlert(message: message)
                        
                        
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            subcategoryTF.resignFirstResponder()
            
        }
        
    }
    
    

    func addNewServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let addService = "\(base_path)services/add_service"
        
//            https://www.volive.in/spsalon/services/add_service
//            Add Service (POST method)
//
//            api_key:2382019
//            lang:en
//            category_id:
//            subcategory_id:
//            user_id:
//            price:
//            service_id (for update service)
            
            let parameters: Dictionary<String, Any> = ["category_id" : catIdString ?? ""
            ,"subcategory_id":subCatIdString ?? "","user_id":userId,"price":priceTF.text ?? "",
                "lang" :"en","api_key":APIKEY,"service_id":serviceIdUpdate]
            
            print(parameters)
            
            Alamofire.request(addService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                        
                        DispatchQueue.main.async {
                            self.showToastForAlert(message: message)
                           DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListOfServicesVC") as! ListOfServicesVC
                            if self.serviceType == "update"
                            {
                                VC.catId = self.catIdUpdate
                            }
//                            else
//                            {
//                                VC.catId = self.catIdString ?? ""
//                            }
                            
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                            }
                        }
                        
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        
                        
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        }
    }
    
    
    func editServiceData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let serviceUrl = "\(base_path)services/edit_service_data"
            
            
            //    https://www.volive.in/spsalon/services/edit_service_data
            //    Service Provider Module
            //
            //    To get service form data during service update(POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    service_id:1
            
            let parameters: Dictionary<String, Any> = [
                 "lang" :language,"api_key":APIKEY,"service_id":serviceIdUpdate]
            
            print(parameters)
            
            Alamofire.request(serviceUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    
                    if status == 1
                    {
                         if let servicesData = responseData["Service Data"] as? Dictionary<String, AnyObject>
                         {
                            if let category_name = servicesData["category_name"] as? String
                            {
                                self.catString = category_name
                            }
                            if let subcategory_name = servicesData["subcategory_name"] as? String
                            {
                                self.subCatString = subcategory_name
                            }
                            if let price = servicesData["price"] as? String
                            {
                                self.price = price
                            }
                            if let subcategory_id = servicesData["subcategory_id"] as? String
                            {
                                self.subCatIdString = subcategory_id
                            }
                            if let category_id = servicesData["category_id"] as? String
                            {
                                self.catIdString = category_id
                            }
                            
                        }
                    
                        DispatchQueue.main.async {
                           
                            
                            self.subcategoryTF.text = self.subCatString
                            self.priceTF.text = self.price
                            self.categoryTF.text = self.catString
                        }
                        
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        
                        
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        }
    }
    
}

extension UIView{
    
    func setBorder(radius:CGFloat, color:UIColor = UIColor.clear) -> UIView{
        let roundView:UIView = self
        roundView.layer.cornerRadius = CGFloat(radius)
        roundView.layer.borderWidth = 1
        roundView.layer.borderColor = color.cgColor
        roundView.clipsToBounds = true
        return roundView
    }
}
extension AddNewServiceVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
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
            subcategoryTF.text =  subCategoryNameArray[row]
            self.subCatString = subCategoryNameArray[row]
            subCatIdString = subCategory_idArray[row]
            
        }
    }
}
