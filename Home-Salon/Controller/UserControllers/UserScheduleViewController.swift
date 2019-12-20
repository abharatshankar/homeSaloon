//
//  ScheduleViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

var banners:[bannerData] = []
var services:[serviceListData] = []

var typeString = ""
var ownerIdsArray = ""
var totalStrAmount = ""
var totalAmount = [String]()


class UserScheduleViewController: UIViewController {
    
    var location = ""
    var longitude = ""
    var latitude = ""
    
    var filterSubCatId = ""
    var arrSelectedRows = [Int]()
    var arrSelectedRows1 = [String]()
    var arrSelectedCost = [String]()
    var timer:Timer!
    
   
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var listTableView: UITableView!
    
    let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
         self.sendBtn.setTitle(languageChangeString(a_str: "SEND REQUEST"), for: UIControl.State.normal)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func providerList(){


        if filterApplied == false
        {
            location = UserDefaults.standard.object(forKey: "location") as? String ?? ""
            longitude = UserDefaults.standard.object(forKey: "longitude") as? String ?? ""
            latitude = UserDefaults.standard.object(forKey: "latitude") as? String ?? ""

            serviceListPostCall()
            self.pageControl.numberOfPages = banners.count
        }
        else
        {
            self.bannerCollectionView.reloadData()
            self.listTableView.reloadData()
            self.pageControl.numberOfPages = banners.count
        }

    }
    
    
   
    func createUI(){
        
       self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(UserScheduleViewController.autoScrollImageSlider), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
        
        if typeString == "now"{
            self.navigationItem.title = languageChangeString(a_str:"NOW")
            self.sendBtn.isHidden = false
        }else{
            self.navigationItem.title = languageChangeString(a_str:"SCHEDULE")
            self.sendBtn.isHidden = true
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(navigate), name: NSNotification.Name(rawValue: "navigate"), object: nil)
    }
    
    
    @objc func navigate(){
        
        let acceptance = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcceptanceViewController") as! AcceptanceViewController
        self.navigationController?.pushViewController(acceptance, animated: true)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        arrSelectedRows.removeAll()
        arrSelectedRows1.removeAll()
        
        NotificationCenter.default.addObserver(self, selector: #selector(providerList), name: NSNotification.Name(rawValue: "providerList"), object: nil)
       
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""

                if userId == ""
                {
                    self.logInAlert()
                }

        else
        {
        
         createUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(likeBtn(_:)), name: NSNotification.Name(rawValue: "addToWishlist"), object: nil)
       
        if filterApplied == false
        {
            location = UserDefaults.standard.object(forKey: "location") as? String ?? ""
            longitude = UserDefaults.standard.object(forKey: "longitude") as? String ?? ""
            latitude = UserDefaults.standard.object(forKey: "latitude") as? String ?? ""
            
            serviceListPostCall()
            self.pageControl.numberOfPages = banners.count
        }
        else
        {
            self.bannerCollectionView.reloadData()
            self.listTableView.reloadData()
             self.pageControl.numberOfPages = banners.count
        }
        
           
            
      }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func likeBtn(_ notification: Notification)
    {
       
        serviceListPostCall()
        
    }
    
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK:- AUTO SCROLLING ADV
    @objc func autoScrollImageSlider() {
        
        DispatchQueue.main.async {
            if banners.count > 0
            {
            let visibleItems = self.bannerCollectionView.indexPathsForVisibleItems
            
            if visibleItems.count > 0 {
                
                var currentItemIndex: IndexPath? = visibleItems[0]
                
                if currentItemIndex?.item == banners.count-1
                {
                    //self.imagesBannerArray.count - 1 {
                    let nexItem = IndexPath(item: 0, section: 0)
                    
                    self.bannerCollectionView.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                    
                } else {
                    
                    let nexItem = IndexPath(item: (currentItemIndex?.item ?? 0) + 1, section: 0)
                    
                    self.bannerCollectionView.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                }
            }
        }
        
    }
    }
    

    @IBAction func filterBtnAction(_ sender: Any) {
        
        let filters = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        self.navigationController?.pushViewController(filters, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if filterApplied == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController1")as! UserHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AtSalonViewController")as! AtSalonViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func favouriteBtnTap(_ sender: Any) {
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyFavoritesVC")as! MyFavoritesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
       
        let stringArray = arrSelectedRows1.map { String($0) }
       ownerIdsArray = stringArray.joined(separator: ",")
        
        let stringArray1 = totalAmount.map { String($0) }
        totalStrAmount = stringArray1.joined(separator: ",")
        
        
//        let array = arrSelectedRows.map {String($0)}
//        ownerIdsArray = array.minimalDescription
//        print(ownerIdsArray)
//
//
//        let array1 = totalAmount.map {String($0)}
//        totalStrAmount = array1.minimalDescription
//
       
        //nowRequestServiceCall(date: currentDate, time: today)
        
        
        if typeString == "now"{
            let popUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPopUpViewController") as! DetailsPopUpViewController
            if filterApplied == true
            {
                popUp.subCatId = filterSubCatId
            }
            
            popUp.location = location
            popUp.longitude = longitude
            popUp.latitude = latitude
            
            UserDefaults.standard.set(typeString, forKey: "typeOfService")
            self.present(popUp, animated: true, completion: nil)
        }

//        }else{
//            let userRequests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
//            userRequests.checkString = ""
//            self.navigationController?.pushViewController(userRequests, animated: true)
//        }
        
    }
    
   
    
}

extension UserScheduleViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        
        details.typeCheckString = typeString
        details.ownerId = services[indexPath.row].user_id
        details.location = location
        details.longitude = longitude
        details.latitude = latitude
        details.totalPriceOfService = services[indexPath.row].price
        
        UserDefaults.standard.set(typeString, forKey: "typeOfService")
        self.navigationController?.pushViewController(details, animated: true)
    }
}

extension UserScheduleViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalonListTableViewCell", for: indexPath) as! SalonListTableViewCell
        
        if typeString == "now"{
            cell.checkImageView.isHidden = false
            
            cell.checkImageView.tag = indexPath.row
            cell.checkImageView.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
            
            let rowid = indexPath.row
            let found = arrSelectedRows.contains(rowid)
            if found
            {
                 cell.checkImageView.setImage(UIImage(named:"check"), for: .normal)
            }
            else
            {
                cell.checkImageView.setImage(UIImage(named:"uncheck"), for: .normal)

            }
            
            
            
//            if let id = Int(services[indexPath.row].user_id)
//            {
//
//                if arrSelectedRows.contains(id){
//                    cell.checkImageView.setImage(UIImage(named:"check"), for: .normal)
//
////                    if let id = services[indexPath.row].price
////                    {
////                        totalAmount.append(id)
////
////                    }
//                }else{
//
//                    cell.checkImageView.setImage(UIImage(named:"uncheck"), for: .normal)
////                    if arrSelectedRows.count > 0
////                    {
////                    if let id = services[indexPath.row].price
////                    {
////                        totalAmount.remove(at: totalAmount.index(of: id) ?? 0)
////
////                    }
////                    }
//
//                }
//                cell.checkImageView.tag = id
//                cell.checkImageView.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
//
//           }
            
            //ell.checkImageView.tag = indexPath.row
            //cell.priceLabel.isHidden = false
            cell.priceLabel.text = services[indexPath.row].price + " " + "SAR"
        }else{
            cell.checkImageView.isHidden = true
             cell.priceLabel.text = services[indexPath.row].price + " " + "SAR"
            //cell.priceLabel.isHidden = true
        }
        if services[indexPath.row].promoted == "1"
        {
            cell.promotedLabel.isHidden = false
        }
        else{
            cell.promotedLabel.isHidden = true
        }
        if services[indexPath.row].whishlist == "1"
        {
            cell.wishListBtn.setImage(UIImage(named:"favorite-heart-button-1"), for: UIControl.State.normal)
        }
        else{
            cell.wishListBtn.setImage(UIImage(named:"favorite-heart-button"), for: UIControl.State.normal)
        }
        cell.nameLbl.text = services[indexPath.row].name
        
        cell.ratingLbl.text = String(services[indexPath.row].ratings)
        
        let imgStr = base_path+services[indexPath.row].display_pic
        cell.salonImg.sd_setImage(with: URL (string: imgStr), placeholderImage:
            UIImage(named:"Group 3873"))
        cell.wishListBtn.tag = indexPath.row
        cell.wishListBtn.addTarget(self, action: #selector(articleLikeBtnTap(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    @objc func checkBoxSelection(_ sender:UIButton)
    {
//        if self.arrSelectedRows.contains(sender.tag){
//            self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: sender.tag)!)
//
//        }else{
//            self.arrSelectedRows.append(sender.tag)
//
//        }
//        self.listTableView.reloadData()
        
        
        
                if self.arrSelectedRows.contains(sender.tag){
                    self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: sender.tag)!)

                    self.arrSelectedRows1.remove(at: self.arrSelectedRows1.index(of: services[sender.tag].user_id)!)
                    totalAmount.remove(at:totalAmount.index(of: services[sender.tag].price)!)


                }else{
                    self.arrSelectedRows.append(sender.tag)
                       self.arrSelectedRows1.append(services[sender.tag].user_id)
                        totalAmount.append(services[sender.tag].price)
                }
        print(totalAmount)
        print(arrSelectedRows1)
        
                self.listTableView.reloadData()
       
    }
    
    
    @objc func articleLikeBtnTap(sender:UIButton)
    {
        let id = services[sender.tag].user_id ?? ""
       
        addToWishListPostCall(id:id)
    }
    
}


extension UserScheduleViewController : UICollectionViewDataSource,UICollectionViewDelegate{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        
        let img = base_path+banners[indexPath.row].banner_image
        
        cell.bannerImg.sd_setImage(with: URL (string:img), placeholderImage:
            UIImage(named:""))
        
        cell.bannerName.text = banners[indexPath.row].title_en
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
       
            
            self.pageControl.currentPage = indexPath.row
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//           let yourWidth = bannerCollectionView.bounds.width
//           return CGSize(width: yourWidth, height: 170)
//
//    }
    
   
    
    
    func serviceListPostCall()
    {
        //internet connection
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        if Reachability.isConnectedToNetwork()
        {
        
         let serviceListUrl = "\(base_path)services/service_list"
            
            //"https://www.volive.in/spsalon/services/service_list"
        
        
        let parameters: Dictionary<String, Any> =
            ["lang":language,"api_key":APIKEY,"service_type":selectedOptionId,"subcategory_id":stringArray,"location":location,"longitude":longitude,"latitude":latitude,
        "user_id":userId,"category_id":"","min_price":"","max_price":"","rating":"","popularity":"","lowtohigh":"","hightolow":""
            ]
           
           print(parameters)
        
        Alamofire.request(serviceListUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
            case .success(_):
                
                guard let data = response.data, response.result.error == nil else { return }
                
                do {
                    
                    let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                    
                    let status = responseData?["status"] as! Int
                    let message = responseData?["message"] as! String
                    
                     print(responseData)
                    
                     banners.removeAll()
                     services.removeAll()
                    
                    if status == 1 || status == 0
                    {
                        
                        if status == 0
                        {
                            self.showToastForAlert(message: message)
                        }
                        
                        if let bannersDataArr = responseData?["banners"] as? [[String:Any]]
                        {
                           
                            if (bannersDataArr.count)>0{
                                
                             banners.removeAll()
                               
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
                        
                       
                        
                        DispatchQueue.main.async {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            if services.count == 0
                            {
                                self.showToastForAlert(message: message)
                            }
                            self.bannerCollectionView.reloadData()
                            self.listTableView.reloadData()
                        }
                        self.pageControl.numberOfPages = banners.count
                          //print(self.banners)
                          //print(self.services)
                        
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
    
    

    
    // add to wishList
    
    func addToWishListPostCall(id:String)
    {
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let wishListUrl = "\(base_path)services/add_whishlist"
            
            //    https://www.volive.in/spsalon/services/add_whishlist
            //    Add whishlist (POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    owner_id
            //    user_id
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "owner_id":id,"user_id":userId
            ]
            
            print(parameters)
            
            Alamofire.request(wishListUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        self.showToastForAlert(message: message)
                          NotificationCenter.default.post(name: NSNotification.Name("addToWishlist"), object: nil)
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
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

struct bannerData{
    
    var banner_id: String!
    var sort_order: String!
    var banner_image: String!
    var title_en: String!
    
    init(banner_id : String , sort_order : String, banner_image:String ,title_en:String ) {
        
        
        self.banner_id  = banner_id
        self.sort_order  = sort_order
        self.banner_image  = banner_image
        self.title_en  = title_en
        
    }
    
}

struct serviceListData{
    
    var display_pic: String!
    var ratings: Int!
    var promoted: String!
    var name: String!
    var price: String!
    var whishlist: String!
    var user_id:String!
    
    init(display_pic:String,ratings:Int,promoted:String,name:String,price:String,whishlist:String,user_id:String) {
        
        
        self.display_pic  = display_pic
        self.ratings  = ratings
        self.promoted  = promoted
        self.name  = name
        self.price  = price
        self.whishlist = whishlist
        self.user_id = user_id
        
    }
    
}

extension Date {
    
    func today(format : String = "dd-MM-yyyy") -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}




extension UserScheduleViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width - 10, height: frameSize.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
