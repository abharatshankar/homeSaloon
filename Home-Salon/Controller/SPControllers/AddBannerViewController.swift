//
//  AddBannerViewController.swift
//  Home-Salon
//
//  Created by harshitha on 07/12/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class AddBannerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {


    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var uploadBannerSt: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bannerImgView: UIImageView!
    
    var bannerImage = UIImage()
    var picker = UIImagePickerController()
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        uploadBannerSt.text = languageChangeString(a_str: "Upload Banner")
        titleTF.placeholder = languageChangeString(a_str: "Title")
        submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        
        if language == "ar"
        {
            
            self.titleTF.textAlignment = .right
            self.titleTF.setPadding(left: -10, right: -10)
           
        }
        else if language == "en"{
            
            self.titleTF.textAlignment = .left
            self.titleTF.setPadding(left: 10, right: 10)
         
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnTap(_ sender: Any)
    {
       navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageBtnTap(_ sender: Any)
    {
        checkPhotoLibraryPermission()
    }
    

    @IBAction func submitBtnTap(_ sender: Any)
    {
        postAProduct1(myPicture: bannerImage)
    }
    
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                
                self.openGallery()
                
            }
            break
        //handle authorized status
        case .denied, .restricted :
            self.checkAuthorisation()
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    
                    print("permission  granted")
                    DispatchQueue.main.async {
                        print("permission already accepted")
                        
                        self.openGallery()
                        
                        
                    }
                    break
                // as above
                case .denied, .restricted:
                    // as above
                    self.checkAuthorisation()
                    break
                case .notDetermined:
                    self.checkAuthorisation()
                    break
                    // won't happen but still
                }
            }
        }
    }
    
    
    
    func checkAuthorisation(){
        
        DispatchQueue.main.async {
            MobileFixServices.sharedInstance.dissMissLoader()
            let alertController = UIAlertController(title:self.languageChangeString(a_str:"Error"), message:self.languageChangeString(a_str:"Enable photo permissions in settings"), preferredStyle: .alert)
            let settingsAction = UIAlertAction(title:self.languageChangeString(a_str:"Settings"), style: .default) { (alertAction) in
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    
                    //UIApplication.shared.openURL(appSettings as URL)
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
            }
            alertController.addAction(settingsAction)
            // If user cancels, do nothing, next time Pick Video is called, they will be asked again to give permission
            let cancelAction = UIAlertAction(title:self.languageChangeString(a_str:"Cancel"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            // Run GUI stuff on main thread
            
            self.present(alertController, animated: true, completion: nil)
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
            self.bannerImage = image
            self.bannerImgView.image = image
        
        
    
        // self.postAProduct(lang:"en" , myPicture: image)
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
            
            let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"user_id":myuserID,"title_ar":"2","title_en":self.titleTF.text ?? ""]
            
            print(parameters)
            
            let  url = "\(base_path)services/add_spbanner"
        
            print(url)
            
            var imageData1 = Data()
            
            
            if let imgData = bannerImage.jpegData(compressionQuality: 0.5)
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
                              
                                if status == 1{
                                    
                                    
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    
                                    self.showToastForAlert(message: message)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                                    {
                                    
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SPProfileViewController") as! SPProfileViewController
                                    self.navigationController?.pushViewController(vc, animated: false)
                                    
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
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
}
