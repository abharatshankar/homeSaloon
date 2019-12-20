//
//  ViewController.swift
//  SPScreen
//
//  Created by volive solutions on 26/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire


struct SubCatageoriesData{
    
    var subcategory_id: String!
    var subcategory_name_en: String!
    var price: String!
    var service_id : String!
    var category_id : String!

    init(subcategory_id:String,subcategory_name_en:String,price:String,service_id:String,category_id:String) {
        
        self.subcategory_id  = subcategory_id
        self.subcategory_name_en  = subcategory_name_en
        self.price  = price
        self.service_id = service_id
        self.category_id = category_id
        
    }
}

class ListOfServicesVC: UIViewController {
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addNewServicesBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var listOfServicesCollectionView: UICollectionView!
    @IBOutlet weak var servicesNamesTableView: UITableView!
    
    @IBOutlet weak var assNewSerBtnHt: NSLayoutConstraint!
    @IBOutlet weak var addNewServiceView: UIView!
    
    @IBOutlet weak var addNewServiceViewHt: NSLayoutConstraint!
    var arrSectionData: NSArray = []
    
    var subCatageoriesArr:[SubCatageoriesData] = []
    
    var providerListData = [ServiceProviderListModel]()
    
    var subcatageoryId = [String]()
    var subcatageoryNamesArray = [String]()
    var allSubCatArray = [[String]]()
    var catId = ""
   
    
    var editServices:Bool = false
    
     let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
//    var servicesImagesArray = [#imageLiteral(resourceName: "Group 3875"),#imageLiteral(resourceName: "Group 3866"),#imageLiteral(resourceName: "Group 3867"),#imageLiteral(resourceName: "Group 3868"),#imageLiteral(resourceName: "Group 3869")]
//    var serviceNamesArray = ["Hair","Body Massage","Pedicure","waxing","Makeup"]
//    var nameOfServicesTypesArray = ["Hair","Hair Styling"]
//    var subServicesNamesArray = [["Hair cut","wash","conditioning","styling","Fringe cut"],["Blowdry","Flat Iron","Curling","Toppik application"]]
    
    

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
         self.navigationItem.title = languageChangeString(a_str:"List of Services")
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.shadowRadius = 10
        editBtn.title = languageChangeString(a_str:"Edit")
        self.addNewServicesBtn.setTitle(languageChangeString(a_str: "ADD NEW SERVICE"), for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteBtn(_:)), name: NSNotification.Name(rawValue: "deleteService"), object: nil)
       
        serviceProviderList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       // self.listOfServicesCollectionView(collectionView(listOfServicesCollectionView), didDeselectItemAt: IndexPath(row: 0, section: 0))
        
       // self.listOfServicesCollectionView(self.listOfServicesCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
    }
    
    @objc func deleteBtn(_ notification: Notification)
    {
        
        subCatageories(id: catId)
        
    }
    

    @IBAction func AddNewService_Button_Action(_ sender: UIButton) {
        
        let storeBoard = UIStoryboard(name: "Main", bundle: nil)
        let gotoVC = storeBoard.instantiateViewController(withIdentifier: "AddNewServiceVC") as! AddNewServiceVC
        
        self.navigationController?.pushViewController(gotoVC, animated: false)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        if editServices == true{
             editBtn.title = languageChangeString(a_str:"Edit")
            editServices = false
             self.servicesNamesTableView.reloadData()
        }else{
            self.servicesNamesTableView.reloadData()
            editServices = true
            editBtn.title = languageChangeString(a_str:"Save")
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
    }
    
    
    func serviceProviderList()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let providerListUrl = "\(base_path)services/provider_service_list"
            
            //        https://www.volive.in/spsalon/services/provider_service_list
            //        api_key:2382019
            //        lang:en
            //        user_id
          
            let parameters: Dictionary<String, Any> = ["lang" :language,"api_key":APIKEY,"user_id":userId]
            
            print(parameters)
            
            Alamofire.request(providerListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
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
                            
                            self.providerListData = [ServiceProviderListModel]()
                            
                            
                            if let providerServiceList = responseData?["Services list"] as? Dictionary<String, AnyObject>
                            {
                               
                              
                                if let catResponse = providerServiceList["categories"] as? [[String:Any]]
                                {
                                    self.arrSectionData = catResponse as NSArray
                                        
                                    for list in catResponse {
                                            
                                    let object = ServiceProviderListModel(providerListData: list as NSDictionary)
                                            
                                        self.providerListData.append(object)
                                            
                                        self.allSubCatArray = [object.subcategory_id + object.subcategory_name_en]
                                            
                                            
                                        for list in self.allSubCatArray{
                                                self.subcatageoryId = list
                                                self.subcatageoryNamesArray = list
                                            }
                                            
                                            
                                        }
                                        if catResponse.count > 0
                                        {
                                            if self.catId == ""
                                            {
                                                 self.catId  = self.providerListData[0].category_id ?? ""
                                                 self.subCatageories(id:self.catId)
                                            }
                                           if self.catId != ""
                                            {
                                                self.subCatageories(id:self.catId)
                                            }
                                            
                                        }
                                    }
                                
                                
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.listOfServicesCollectionView.reloadData()
                                let indexPath:IndexPath = IndexPath(row: 0, section: 0)
                                self.listOfServicesCollectionView?.selectItem(at: indexPath, animated: false, scrollPosition:.left)
                                self.servicesNamesTableView.reloadData()
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
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
    
    
    // subcatageories service call
    
    func subCatageories(id:String)
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let providerListUrl = "\(base_path)services/provider_service_category?"
            
           //https://www.volive.in/spsalon/services/provider_service_category?api_key=2382019&lang=en&user_id=16&category_id=2
         
           let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang" :language,"api_key":APIKEY,"user_id":userId,"category_id":id]
            
            print(parameters)
            
            Alamofire.request(providerListUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        self.subCatageoriesArr.removeAll()
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                           if let providerCatList = responseData?["data"] as? [Dictionary<String, AnyObject>]
                            {
                              
                                if (providerCatList.count)>0{
                                    
                                    for i in providerCatList{
                                        
                                        let newData =  SubCatageoriesData(subcategory_id: (i["subcategory_id"] as! String), subcategory_name_en: (i["subcategory_name_en"]as! String), price: (i["price"]as! String), service_id: (i["service_id"]as! String), category_id: (i["category_id"]as! String))
                                        
                                        self.subCatageoriesArr.append(newData)
                                    }
                                    
                                 }
                                
                            }
                                    
                          DispatchQueue.main.async {
                              self.listOfServicesCollectionView.reloadData()
                                self.servicesNamesTableView.reloadData()
                            
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.async {
                                self.servicesNamesTableView.reloadData()
                            }
                            
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
    
}

extension ListOfServicesVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // print(providerListData)
       return providerListData.count
        
  }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = listOfServicesCollectionView.dequeueReusableCell(withReuseIdentifier: "ListOfServicesCell", for: indexPath) as! ListOfServicesCell
        
        if providerListData[indexPath.row].category_id == catId
        {
            cell.isSelected = true
            cell.backView.backgroundColor = UIColor.gray
        }
        else
        {
            cell.isSelected = false
            cell.backView.backgroundColor = UIColor.white
        }
//        if (indexPath.row == 0){
//           listOfServicesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
//            catId = providerListData[indexPath.row].category_id
//            print(catId)
//            cell.backView.backgroundColor = UIColor.gray
//            subCatageories(id: catId)
//         }
//        else{
//
//            cell.backView.backgroundColor = UIColor.white
//
//        }
        
         cell.serviceName_lbl.text = providerListData[indexPath.row].category_name_en
         let img = base_path+providerListData[indexPath.row].category_image
         cell.serviceImageView.sd_setImage(with:URL(string:img))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       let cell = listOfServicesCollectionView.dequeueReusableCell(withReuseIdentifier: "ListOfServicesCell", for: indexPath) as! ListOfServicesCell
        
        cell.isSelected = true
        cell.backView.backgroundColor = .gray
        
        catId = providerListData[indexPath.row].category_id
       // providerListData[indexPath.row].category_name_en
        print(catId)
        subCatageories(id: catId)
        
          self.listOfServicesCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfServicesCell", for: indexPath) as! ListOfServicesCell
             cell.isSelected = false
            cell.backView.backgroundColor = UIColor.white
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        //let cell = listOfServicesCollectionView.cellForItem(at: indexPath as IndexPath)
//       
//        listOfServicesCollectionView.deselectItem(at: indexPath, animated: true)
//    }
    
 }


extension ListOfServicesVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

             return subCatageoriesArr.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = servicesNamesTableView.dequeueReusableCell(withIdentifier: "EditListServiceCell", for: indexPath) as! EditListServiceCell
        cell.serviceName_lbl.text = subCatageoriesArr[indexPath.row].subcategory_name_en
        cell.servicePrice_lbl.text = "\(subCatageoriesArr[indexPath.row].price ?? "")" + " " + "SAR"

        if editServices == true{
         cell.updatingView.isHidden = false
            addNewServiceViewHt.constant = 0
            assNewSerBtnHt.constant = 0
        }
        else
        {
          cell.updatingView.isHidden = true
            addNewServiceViewHt.constant = 100
            assNewSerBtnHt.constant = 50
        }
      
        cell.editBtn.setTitle(languageChangeString(a_str: "Edit"), for: UIControl.State.normal)
        cell.deleteBtn.setTitle(languageChangeString(a_str: "Delete"), for: UIControl.State.normal)
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(updateService(sender:)), for: UIControl.Event.touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteService(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
        
     }

    @objc func updateService(sender:UIButton)
    {
        let storeBoard = UIStoryboard(name: "Main", bundle: nil)
        let gotoVC = storeBoard.instantiateViewController(withIdentifier: "AddNewServiceVC") as! AddNewServiceVC
        gotoVC.serviceIdUpdate = subCatageoriesArr[sender.tag].service_id
        gotoVC.catIdUpdate = subCatageoriesArr[sender.tag].category_id
//        gotoVC.subCatString = subCatageoriesArr[sender.tag].subcategory_name_en
//        gotoVC.subCatIdString = subCatageoriesArr[sender.tag].subcategory_id
//        gotoVC.price = subCatageoriesArr[sender.tag].price
        gotoVC.serviceType = "update"
        self.navigationController?.pushViewController(gotoVC, animated: false)
        
    }
    
    @objc func deleteService(sender:UIButton)
    {
        
        let deteleId = subCatageoriesArr[sender.tag].service_id ?? ""
        let id = subCatageoriesArr[sender.tag].category_id ?? ""
        print(id)
        deleteCall(id:deteleId,cat:id)
    }
    
    
    func deleteCall(id:String,cat:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let sub_catageories = "\(base_path)services/delete_service"
            
            ///    https://www.volive.in/spsalon/services/delete_service
         
            //    api_key:2382019
            //    lang:en
            //    user_id
            //    service_id
            
            let parameters: Dictionary<String, Any> = ["user_id":userId,
                 "lang" :language,"api_key":APIKEY,"service_id":id]
            
            print(parameters)
            
            Alamofire.request(sub_catageories, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                   
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                        //self.editServices = false
                        //self.editBtn.title = "Edit"
                        self.catId = cat
                        
                        DispatchQueue.main.async {
                            
                           // self.showToastForAlert(message: message)
                            
                              NotificationCenter.default.post(name: NSNotification.Name("deleteService"), object: nil)
                           
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
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if editServices == true{
            return 110
         }else{
            return 60
        }
    }


}


