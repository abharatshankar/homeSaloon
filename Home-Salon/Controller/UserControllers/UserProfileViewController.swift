//
//  UserProfileViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SDWebImage

class UserProfileViewController: UIViewController {
   
    var checkString : String?
    
     let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
    
    
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var savedCardSt: UILabel!
    @IBOutlet weak var confirmPassSt: UILabel!
    @IBOutlet weak var passwordSt: UILabel!
    @IBOutlet weak var changePassSt: UILabel!
    @IBOutlet weak var emailSt: UILabel!
    @IBOutlet weak var mobileSt: UILabel!
    @IBOutlet weak var nameSt: UILabel!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var cardsCollection: UICollectionView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userPhoneTF: UITextField!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
  
    
   // card details
    var card_numberArray = [String]()
    var card_typeArray = [String]()
    var name_on_cardArray = [String]()
    var expiry_dateArray = [String]()
    var card_idArray = [String]()
    var cvvArray = [String]()
   
    // user data
    var name = ""
    var email = ""
    var phone = ""
    var userImage = ""
    var checkValue = 1
    
     var picker = UIImagePickerController()
   
    var pickedImage = UIImage()
    
    @IBOutlet weak var userImageBtn: UIButton!
   
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = languageChangeString(a_str:"Profile")
        
        picker.delegate = self
        self.userImageBtn.isHidden = true
        self.userNameTF.isUserInteractionEnabled = false
        self.userEmailTF.isUserInteractionEnabled = false
        self.userPhoneTF.isUserInteractionEnabled = false
        self.passwordTF.isUserInteractionEnabled = false
        self.confirmPasswordTF.isUserInteractionEnabled = false
        
        self.passwordTF.isSecureTextEntry = true
        self.confirmPasswordTF.isSecureTextEntry = true
        self.nameSt.text = languageChangeString(a_str: "Name")
        self.emailSt.text = languageChangeString(a_str: "Email")
        self.mobileSt.text = languageChangeString(a_str: "Mobile Number")
        self.changePassSt.text = languageChangeString(a_str: "Change Password")
        self.passwordSt.text = languageChangeString(a_str: "Password")
        self.confirmPassSt.text = languageChangeString(a_str: "Confirm Password")
        self.savedCardSt.text = languageChangeString(a_str: "Saved Cards")
       
        self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str:"Edit")
        
        
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId != ""
        {
          userProfile()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.passwordTF.text = UserDefaults.standard.object(forKey: "password") as? String
        self.confirmPasswordTF.text = UserDefaults.standard.object(forKey: "password") as? String
        
       
       
    }

    @IBAction func backBtnAction(_ sender: Any) {
        if self.checkString == "Side"{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func editBtnTap(_ sender: Any){
        
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId == ""
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self.logInAlert()
            }
        }
            
        else
        {
        
          if checkValue == 1{
           
            self.editBtn.title = languageChangeString(a_str:"Save")
            //self.navigationItem.rightBarButtonItem?.title = "Save"
            self.userImageBtn.isHidden = false
            self.userNameTF.isUserInteractionEnabled = true
            self.userEmailTF.isUserInteractionEnabled = false
            self.userPhoneTF.isUserInteractionEnabled = false
            self.passwordTF.isUserInteractionEnabled = true
            self.confirmPasswordTF.isUserInteractionEnabled = true
          
            self.userNameTF.becomeFirstResponder()
            
            checkValue = 2
            
          
        }
        else{
            
            self.userImageBtn.isHidden = true
            self.userNameTF.isUserInteractionEnabled = false
            self.userEmailTF.isUserInteractionEnabled = false
            self.userPhoneTF.isUserInteractionEnabled = false
            self.passwordTF.isUserInteractionEnabled = false
            self.confirmPasswordTF.isUserInteractionEnabled = false
            
            self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str:"Edit")
            checkValue = 1
            if Reachability.isConnectedToNetwork() {
                
               
                postAProduct()
                
            }else
            {
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                
            }
            
        }
        
    }
}
    
    
    @IBAction func imageUploadAction(_ sender: Any) {
        let alert = UIAlertController(title:languageChangeString(a_str:"Choose Image"), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title:languageChangeString(a_str:"Camera"), style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title:languageChangeString(a_str:"Gallery"), style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
   

    func userProfile()
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
                    
                    //print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if self.card_idArray.count > 0 || self.card_numberArray.count > 0 ||
                        self.name_on_cardArray.count > 0 || self.card_typeArray.count > 0 || self.cvvArray.count > 0 || self.expiry_dateArray.count > 0
                        {
                             self.card_typeArray.removeAll()
                             self.card_idArray.removeAll()
                             self.card_numberArray.removeAll()
                             self.name_on_cardArray.removeAll()
                             self.cvvArray.removeAll()
                             self.expiry_dateArray.removeAll()
                        }
                        
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
                                self.userImage = base_path+display_pic
                            }
                            if let payment_cards = userDetailsData["payment_cards"] as? [[String:Any]]
                            {
                                for i in 0..<payment_cards.count
                                {
                                    if let card_id = payment_cards[i]["card_id"] as? String
                                    {
                                        self.card_idArray.append(card_id)
                                    }
                                    if let card_type = payment_cards[i]["card_type"] as? String
                                    {
                                        self.card_typeArray.append(card_type)
                                    }
                                    if let name = payment_cards[i]["name"] as? String
                                    {
                                        self.name_on_cardArray.append(name)
                                    }
                                    if let card_number = payment_cards[i]["card_number"] as? String
                                    {
                                        self.card_numberArray.append(card_number)
                                    }
                                    if let expiry = payment_cards[i]["expiry"] as? String
                                    {
                                        self.expiry_dateArray.append(expiry)
                                    }
                                    if let cvv = payment_cards[i]["cvv"] as? String
                                    {
                                        self.cvvArray.append(cvv)
                                    }
                                   
                                }
                            }
                            
                        }
                        print(self.card_typeArray)
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                            self.userNameTF.text = self.name
                            self.userEmailTF.text = self.email
                            self.userPhoneTF.text = self.phone
                        
                        self.userImg.layer.borderWidth = 1
                        self.userImg.clipsToBounds = true
                        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
                        self.userImg.layer.masksToBounds = true
                        
                          self.userImg.sd_setImage(with: URL (string: self.userImage), placeholderImage:
                            UIImage(named: ""))
                        
                       //  self.cardsCollection.reloadData()
                            
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
    
    
    
    @IBAction func addCardsBtnTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCardDetailsVC") as! EditCardDetailsVC
        vc.checkStr = "addCard"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
 
    
}


extension UserProfileViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picsCell", for: indexPath) as! PicturesCollectionViewCell
        if indexPath.row == 1{
            cell.picImageView.image = UIImage.init(named: "Group 2381")
        }else{
            cell.picImageView.image = UIImage.init(named: "Group 2383")
        }
        return cell
    }
}
extension UserProfileViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0,height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



//extension UserProfileViewController : UICollectionViewDataSource,UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return card_idArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCards", for: indexPath) as! PicturesCollectionViewCell
//      cell.nameLabel.text = name_on_cardArray[indexPath.row]
//      cell.cardNoLabel.text = card_numberArray[indexPath.row]
//      cell.dateLabel.text = expiry_dateArray[indexPath.row]
//      cell.editBtn.tag = indexPath.row
//      cell.deleteBtn.tag = indexPath.row
//      cell.editBtn.addTarget(self, action:#selector(editBtnAction(sender:)), for:UIControl.Event.touchUpInside)
//      cell.deleteBtn.addTarget(self, action:#selector(deleteBtnAction(sender:)), for:UIControl.Event.touchUpInside)
//        return cell
//    }
//
//    @objc func editBtnAction(sender:UIButton){
//
//        let editCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCardDetailsVC") as! EditCardDetailsVC
//        editCard.cardIdStr = card_idArray[sender.tag]
//        editCard.cardTypeStr = card_typeArray[sender.tag]
//        editCard.nameOnCardStr = name_on_cardArray[sender.tag]
//        editCard.cardNumberStr = card_numberArray[sender.tag]
//        editCard.cardExpiryDateStr = expiry_dateArray[sender.tag]
//        editCard.cardCVVStr = cvvArray[sender.tag]
//        self.navigationController?.pushViewController(editCard, animated: false)
//
//    }
//    @objc func deleteBtnAction(sender:UIButton){
//
//        let cardid = card_idArray[sender.tag]
//
//
//        if Reachability.isConnectedToNetwork() {
//            deleteCardsServiceCall(cardId: cardid)
//        }else
//        {
//            showToastForAlert (message:"Please ensure you have proper internet connection")
//
//        }
//    }
//
//    //MARK:DELETE CARDS SERVICE CALL
//    func deleteCardsServiceCall(cardId:String)
//    {
//        MobileFixServices.sharedInstance.loader(view: self.view)
//
//        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
//
////
////        https://www.volive.in/spsalon/services/delete_user_cards
////        Delete User added cards (POST method)
////
////        api_key:2382019
////        lang:en
////        user_id:
////        card_id
//
//        let deleteCard = "\(base_path)services/delete_user_cards"
//        let params: Dictionary<String, Any> = [ "card_id" :cardId, "lang" : language,"api_key":APIKEY,"user_id":myuserID]
//
//        print(params)
//
//        Alamofire.request(deleteCard, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
//            if let responseData = response.result.value as? Dictionary<String, Any>{
//                print(responseData)
//
//                let status = responseData["status"] as! Int
//                let message = responseData["message"] as! String
//
//                if status == 1
//                {
//                    DispatchQueue.main.async {
//                        MobileFixServices.sharedInstance.dissMissLoader()
//                        self.userProfile()
//                        self.showToastForAlert(message: message)
//                    }
//                }
//                else
//                {
//                    MobileFixServices.sharedInstance.dissMissLoader()
//                    self.userProfile()
//                    self.showToastForAlert(message: message)
//                }
//            }
//        }
//    }
//
//
//
//}
//extension UserProfileViewController : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150.0,height: 120.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//}



extension UserProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            showToastForAlert(message: languageChangeString(a_str:"You don't have camera")!)
           
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        self.userImg.image = image
        
        pickedImage = image
        self.userImg.layer.borderWidth = 1
        self.userImg.layer.masksToBounds = false
        self.userImg.layer.cornerRadius = self.userImg.frame.height/2
        self.userImg.clipsToBounds = true
        picker.dismiss(animated: true, completion: nil)
      
      
       // self.postAProduct(lang:"en" , myPicture: image)
    }
    
    func alertController (title: String,msg: String) {
        
        let alert = UIAlertController.init(title:title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: languageChangeString(a_str:"Ok"), style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func postAProduct()
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.passwordTF.text == self.confirmPasswordTF.text
            {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            
            let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"name":userNameTF.text ?? "","phone":userPhoneTF.text ?? "","user_id":myuserID,"user_type":"1","new_password":self.passwordTF.text ?? "","confirm_password":self.confirmPasswordTF.text ?? ""]
            
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
           
            let  url = "https://www.volive.in/spsalon/services/update_profile"
            print(url)
            
            var imageData1 = Data()
            
               
                
            if let imgData = self.userImg.image?.jpegData(compressionQuality: 0.1)
            {
                imageData1 = imgData
            }
            print(imageData1)
            Alamofire.upload(multipartFormData: { multipartFormData in
               
                // import image to request
                
                multipartFormData.append(imageData1, withName: "display_pic", fileName: "file.jpg", mimeType: "image/jpeg")
                
                
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, to: url,method:.post,
               
               encodingCompletion:
                { (result) in
                    print(result)
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON{ response in
                            
                            print("response data is :\(response)")
                            
                            
                            
                            if let responseData = response.result.value as? Dictionary <String,Any>{
                                
                                
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
                                            self.userImage = base_path+display_pic
                                             UserDefaults.standard.set(self.userImage as Any, forKey: "pic")
                                        }
                                        
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.showToastForAlert(message: message)
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                       
                                    //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                        
                                        self.userNameTF.text = self.name
                                        self.userEmailTF.text = self.email
                                        self.userPhoneTF.text = self.phone
                                        self.userImg.sd_setImage(with: URL (string: self.userImage), placeholderImage:
                                            UIImage(named: ""))
                                      
                                        UserDefaults.standard.set(self.passwordTF.text, forKey: "password")
                                        
                                        UserDefaults.standard.set(self.name, forKey: "userName")
                                        
                                      //  }
                                        
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
            self.confirmPasswordTF.text = UserDefaults.standard.object(forKey: "password") as? String
         }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
}

