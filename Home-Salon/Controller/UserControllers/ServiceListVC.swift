//
//  ServiceListVC.swift
//  HomeSalon_ServiceProvider_App
//
//  Created by Rajesh Kishanchand on 8/1/19.
//  Copyright © 2019 Volive Solutions. All rights reserved.
//

import UIKit
import Alamofire

struct Section {
    var name: String!
    var imagename: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String,imagesName:String, items: [String]) {
        self.name = name
        self.items = items
        self.collapsed = false
        self.imagename = imagesName
    }
}

  var stringArray = String()
  var arrSelected = [String]()

  //var arrSelected1 = [String]()

class ServiceListVC: UIViewController {
    
    var location = ""
    var longitude = ""
    var latitude = ""

   //var arrSelectedRows = [Int]()
    
    @IBOutlet var submit_button: UIButton!
    
    @IBOutlet var serviceList_Tableview: UITableView!
    
    var sections = [Section]()
    
    var ServiceListData = [ServiceListModel]()
    
    var subcatageoryId = [String]()
    var subcatageoryNamesArray = [String]()
    var subcatageoryImageArray = [String]()
    var allSubCatArray = [[String]]()
    
    private var sectionIsExpanded = [Bool]()
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = languageChangeString(a_str:"Service")
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        submit_button.layer.cornerRadius = 25
        self.submit_button.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        
        // Do any additional setup after loading the view.
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserDefaults.standard.removeObject(forKey: "Stime")
        UserDefaults.standard.removeObject(forKey: "Sdate")
        
        filterApplied = false
        serviceListCall()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController1")as! UserHomeViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
          self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Back Button
    @objc func showLeftView(sender: AnyObject?) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        let array = arrSelected.map {String($0)}
        stringArray = array.minimalDescription
        print(stringArray)
        
       if array.count > 0
        {
            if arrSelected.count > 3
            {
                showToastForAlert(message: languageChangeString(a_str: "You can select upto 3 services only")!)
                return
            }
          let atSalon = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AtSalonViewController") as! AtSalonViewController
            atSalon.userLocation = location
            atSalon.userLongitude = longitude
            atSalon.userLatitude = latitude
            
         self.navigationController?.pushViewController(atSalon, animated: true)
        }
        else{
            showToastForAlert(message: languageChangeString(a_str: "Please select any service")!)
        }
    }
}


extension ServiceListVC:UITableViewDataSource,UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        return ServiceListData.count
    }
    
   
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // First will always be header
        return sectionIsExpanded[section] ? (1+ServiceListData[section].subcategory_id.count) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceHeaderViewTableViewCell", for: indexPath) as! ServiceHeaderViewTableViewCell
            
            cell.serviceName_Label.text = ServiceListData[indexPath.section].category_name_en
            
            let imageLink = base_path+ServiceListData[indexPath.section].category_image
            cell.serviceImg_ImageView.sd_setImage(with: URL(string:imageLink))
       
          if sectionIsExpanded[indexPath.section] {
            
                cell.setExpanded()
            
            } else {
                cell.setCollapsed()
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubServiceListTableViewCell", for: indexPath) as! SubServiceListTableViewCell
            cell.subServiceName_Label.text = ServiceListData[indexPath.section].subcategory_name_en[indexPath.row - 1]
         
            
//            if let id = Int(ServiceListData[indexPath.section].subcategory_id[indexPath.row-1])
//            {
//                if arrSelected.contains(id){
//                    cell.btnselectedOrNot.setImage(UIImage(named:"check_box_check"), for: .normal)
//
//                }else{
//                    cell.btnselectedOrNot.setImage(UIImage(named:"Group 3712"), for: .normal)
//                }
//                cell.btnselectedOrNot.tag = id
//                cell.btnselectedOrNot.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
//
//            }
            
            cell.btnselectedOrNot.mk_addTapHandler { (btn) in
                //print("You can use here also directly : \(indexPath.row)")
                self.checkBoxSelection(btn: btn, indexpath: indexPath)
                
            }
            
            let rowid = ServiceListData[indexPath.section].subcategory_id[indexPath.row-1]
            let found = arrSelected.contains(rowid)
            if found
            {
                cell.btnselectedOrNot.setImage(UIImage(named:"check_box_check"), for: .normal)
            }
            else
            {
                cell.btnselectedOrNot.setImage(UIImage(named:"Group 3712"), for: .normal)
                
            }
            
            
            return cell
        }
    }
    
    @objc func checkBoxSelection(btn:UIButton , indexpath :IndexPath)
    {
        
      
        if arrSelected.contains(ServiceListData[indexpath.section].subcategory_id[indexpath.row-1])
        {
            arrSelected.remove(at: arrSelected.index(of:ServiceListData[indexpath.section].subcategory_id[indexpath.row-1])!)
            
           
        }
        else
        {
            arrSelected.append(ServiceListData[indexpath.section].subcategory_id[indexpath.row-1])
          
            
        }
        
        self.serviceList_Tableview.reloadData()
        
        
       
    }
    
    
    

//  @objc func checkBoxSelection(_ sender:UIButton)
//  {
////    if arrSelectedRows.count >= 3
////    {
////       if self.arrSelectedRows.contains(sender.tag){
////            self.arrSelectedRows.remove(at: self.arrSelectedRows.index(of: sender.tag)!)
////        }
////        else
////        {
////            //self.arrSelectedRows.append(sender.tag)
////             showToastForAlert(message: "you can select upto 3 services only")
////        }
////
////    }
////    else
////    {
//        if arrSelected.contains(sender.tag)
//        {
//          arrSelected.remove(at: arrSelected.index(of: sender.tag)!)
//        }
//         else
//         {
//           arrSelected.append(sender.tag)
//        }
//
//    //}
//    self.serviceList_Tableview.reloadData()
//
//  }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
           return 65
        }else{
            return 45
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Expand/hide the section if tapped its header
        if indexPath.row == 0 {
            
            sectionIsExpanded[indexPath.section] = !sectionIsExpanded[indexPath.section]
            
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
        
      
    }
    
    
    func serviceListCall()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            //    https://www.volive.in/spsalon/services/choose_service
            //    Category and Subcategory data (GET method)
            //
            //    api_key:2382019
            //    lang:en
        
            
            let catageories = "\(base_path)services/choose_service?"
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language]
            
            Alamofire.request(catageories, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>
                {
                   
                    
                    //print(responseData)
                    let status = responseData["status"] as? Int
                    let message = responseData["message"] as? String
                    if status == 1
                    {
                        self.ServiceListData = [ServiceListModel]()
                       
                        
                        if let response1 = responseData["Services"] as? Dictionary<String, Any>
                        {
                            if let catResponse = response1["categories"] as? [[String:Any]]
                            {
                               
                                for list in catResponse {
                                    
                                let object = ServiceListModel(categoryData: list as NSDictionary)
                                   
                                    self.ServiceListData.append(object)
                                
                                self.allSubCatArray = [object.subcategory_id + object.subcategory_image + object.subcategory_name_en]
                                    
                                    
                                for list in self.allSubCatArray{
                                    self.subcatageoryId = list
                                    self.subcatageoryImageArray = list
                                    self.subcatageoryNamesArray = list
                                   }
                                    self.sectionIsExpanded.append(false)
                                   
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                             MobileFixServices.sharedInstance.dissMissLoader()
                            self.serviceList_Tableview.reloadData()
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
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            
        }
        
    }
    
}

extension Array {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: ",")
    }
}


//"REQUEST"="طلبات";
//"COMPLETE"="مكتملة";
//"SCHEDULE"="الجدول";
//"PENDING"="قيد العمل";
//"Requests"="الطلبات";
//"Service"="الخدمة";
//"Service Type"="نوع الخدمة";
//"Visit Date & Times"="وقت و تاريخ الزيارة";
//"Cost"="القيمة";
//"Address"="العنوان";
//"Description"="الوصف";
//"ACCEPT"="قبول";
//"REJECT"="رفض";
//"View Details"="عرض التفاصيل";
//"REJECT REQUEST"="رفض الطلب";
//"Reasons for Rejection"="سبب الرفض";
//"SUBMIT"="التالي";
//"Please select reason to reject the request"="الرجاء اختيار سبب الرفض";
//"Done"="تم";
//"Cancel"="الغاء";
//"Please ensure you have proper internet connection"="الرجاء التأكد من اتصال الإنترنت";
//"Details"="التفاصيل";
//"HomeService"="خدمة منزلية";
//"At the Salon"="في الصالون ";
//"HomeService & At the Salon"="مكتمل";
//"Completed"="رفض";
//"REJECT"="مدفوع";
//"PAID"="مدفوع";
//"COMPLETE WORK"="أكتمل العمل;
//"START WORKING"="بدأ العمل ";
//"Order ID"="رقم الطلب";
//"Visit Date&Times"="وقت و تاريخ الزيارة ";
//"Order NO"="رقم الطلب";
//"Payment Status"="حالة الدفع";
//"START WORKING"="بدأ العمل";
//"List of Services"="الخدمات";
//"Edit"="تحرير";
//"Save"="حفظ";
//"ADD NEW SERVICE"="إضافة خدمة جديدة";
//"Delete"="حذف";
//"Please Select Category"="الرجاء اختيار فئة";
//"ADD NEW SERVICE"="إضافة خدمة جديدة";
//"Select category"="اختر الفئة";
//"Subcategories"="اختر الفئة الفرعية";
//"Service price"="سعر الخدمة";
//"CANCLE"="الغاء";
//"SCHEDULE"="جدول";
//"Profile"="الملف الشخصي";
//"Available"="متاح";
//"UnAvailable"="غير متاح";
//"Name"="الاسم";
//"Email"="البريد الإلكتروني";
//"Mobile Number"="رقم الهاتف";
//"Change Password"="تغيير كلمة المرور";
//"Password"="كلمة المرور";
//"Confirm Password"="تأكيد كلمة المرور";
//"Available Time"="أوقات العمل";
//"Monday"="الإثنين";
//"Tuesday"="الثلاثاء";
//"Wednesday"="الأربعاء";
//"Thursday"="الخميس";
//"Friday"="الجمعة";
//"Saturday"="السبت";
//"Sunday"="الأحد";
//"IBAN Number"="رقم ال IBAN";
//"Pictures"="الصور";
//"ADD"="اضف";
//"Home Salon"="خدمات منزلية";
//"Upload Banner"="رفع البانر";
//"Title"="العنوان";
//"Closing time should be greater than opening time"="وقت الإغلاق يجب أن يكون بعد وقت الفتح";
//"Please enter all timings"="الرجاء إدخال جميع الأوقات";
//"Choose Image"="اختر الصورة";
//"Camera"="كاميرا";
//"Gallery"="الأستوديو";
//"Cancel"="الغاء";
//"You don't have camera"="الكاميرا غير متاحة";
//"Ok"="موافق";
//"password and confirm password are different"="تأكيد كلمة المرور  مختلف عن كلمة المرور";
//"Error"="خطأ";
//"Enable photo permissions in settings"="الرجاء السماح بالوصول للصور من الإعدادات";
//"Settings"="الإعدادات";
//"HOME"="الصفحةالرئيسية";
//"List of Services"="الخدمات";
//"NOTIFICATIONS"="التنبيهات";
//"MY PROFILE"="حسابي";
//"TERMS AND CONDITIONS"="الشروط والأحكام";
//"SIGN OUT"="تسجيل الخروج";
//"Change"="تغيير";
//"ORDERS"="الطلبات";
//"CONTACT US"="اتصل بنا";
//"Login"="تسجيل الدخول";
//"Create Account"="التسجيل";
//"Forgot Password"="نسيت كلمة المرور";
//"E-mail Address"="البريد الإلكتروني";
//"Verification"="التأكيد";
//"Verify your mobile"="تأكيد رقم الجوال";
//"Enter your OTP CODE here"="نأمل ادخال الرمز المرسل الى جوالك";
//"VERIFY"="تأكيد";
//"Didn't receive the code?"="لم تقم بإستلام الرمز ؟";
//"Resend code"="إعادة ارسال الرمز";
//"Choose your option"="الرجاء اختيار نوع الخدمة";
//"Select your location"="الرجاء تحديد موقعك";
//"Description"="الوصف";
//"Our Services"="خدماتنا";
//"Availability"="ساعات العمل";
//"Select Time"="الرجاء اختيار الوقت";
//"Select Date"="الرجاء اختيار التاريخ";
//"Time"="الوقت";
//"Date"="التاريخ";
//"SEND REQUEST"="إرسال الطلب";
//"Services"="الخدمات";
//"You can select upto 3 services only"="يمكن إختيار ثلاث خدمات بحد أقصى";
//"Please select any service"="الرجاء اختيار الخدمة";
//"Location Services Disabled!"="خدمة الموقع معطلة";
//"Please enable Location Based Services for better results! We promise to keep your location private"="الرجاء السماح بالوصول للموقع من الاعدادات لنتائج أفضل";
//"Cancel"="الغاء";
//"BOOKING DETAILS"="تفاصيل الحجز";
//"Booking services"="الخدمات";
//"SEND REQUEST"="إرسال الطلب";
//"TotalPrice"="السعر الكلية";
//"Choose your option"="الرجاء اختيار نوع الخدمة";
//"NOW"="الآن";
//"SCHEDULED"="خدمة مجدولة";
//"SUBMIT"="التالي";
//"Filters"="تصفية";
//"Reset"="مسح";
//"Category"="الفئة";
//"Subcategory"="الفئة الفرعية";
//"Price Range"="السعر";
//"Min"="الحد الأدنى";
//"Max"="الحد الأعلى";
//"Location"="الموقع";
//"Ratings"="التقييم";
//"5 Rating"="تقييم 5";
//"4 & UP"="تقييم أعلى من 4";
//"3 & UP"="تقييم أعلى من 3";
//"2 & UP"="تقييم أعلى من 2";
//"1 & UP"="تقييم أعلى من 1";
//"Sort By"="اظهار حسب";
//"Popularity"="الأكثر شهرة";
//"Price from Low to High"="السعر من الأدنى للأعلى";
//"Price from Hight to Low"="السعر من الأعلى للأدنى";
//"APPLY FILTER"="تطبيق";
//"My Favorites"="مفضلاتي";
//"Open now"="مفتوح الأن";
//"Order No"="رقم الطلب";
//"Customer Name"="اسم العميل";
//"Invoice No"="رقم الفاتورة";
//"Date"="التاريخ";
//"Service Details"="تفاصيل الخدمة";
//"Discount coupon codes"="استخدام قسيمة شراء";
//"Enter your coupon code"="ادخل رقم القسيمة";
//"APPLY"="تطبيق";
//"Details"="التفاصيل";
//"Sub Total"="المجموع الفرعي";
//"Coupon"="قسيمة الشراء";
//"Total Amount"="المجموع الكلي";
//"PAYMENT OPTION"="خيار الدفع";
//"Successful"="تم الدفع بنجاح";
//"THANK YOU!"="شكرا لك";
//"Your payment was completed and confirmation sent to email"="تمت عملية الدفع بنجاح وتم ارسال التأكيد للإيميل";
//"Give us a compliment"="رأيك يهمنا";
//"Write a thank you note"="اترك تعليقك هنا";
//"Service Provider"="مقدم الخدمة";
//"Service"="الخدمة";
//"Service Type"="نوع الخدمة";
//"Scheduled Date & Time"="وقت وتاريخ الموعد";
//"Cost"="التكلفة";
//"Order Status"="حالة الطلب";
//"VIEW INVOICE"="الفاتورة";
//"Address"="العنوان";
//"Date & Time"="الوقت والتاريخ";
//"PAY"="الدفع";
//"SP Status"="حالة مقدم الخدمة";
//"View Details"="عرض التفاصيل";
//"GIVE RATING"="قيمنا";
//"Payment"="الدفع";
//"Pay With Card"="الدفع بالبطاقة";
//"Pay by Cash"="الدفع نقدا";
//"ENTER YOUR CARD DETAILS"="الرجاء ادخال تفاصيل البطاقة";
//"Card Type"="نوع البطاقة";
//"Name on Card"="اسم حامل البطاقة";
//"Card Number"="رقم البطاقة ";
//"Card Expiry"="تاريخ الانتهاء";
//"CVV"="رمز التحقق (CVV)";
//"Secure Credit Card Payment"="مدفوعات البطاقات الإئتمانية  الامنة";
//"PAY NOW"="إتمام الدفع";
//"Profile"="الملف الشخصي";
//"ADD"="أضف";
//"Saved Cards"="بطاقاتي";
//"Home Salon"="خدمة منزلية";
//"SIGN IN"="تسجيل الدخول";
//"GUEST USER"="الدخول كزائر";
//"USER"="مستخدم";
//"Service Provider"="مقدم خدمة";
//"E-mail"="البريد الالكتروني";
//"Password"="كلمة المرور";
//"Forgot Your Password?"="نسيت كلمة المرور ؟";
//"Facebook"="فيسبوك";
//"Google"="قوقل";
//"Don't have an account?"="ليس لديك حساب ؟";
//"Sign up"="سجل الان";
//"Please Enter All Fields"="الرجاء ادخال جميع المعلومات";
//"Please enter valid email"="يرجى إدخال عنوان بريد الكتروني صالح";
////"Please ensure you have proper internet connection"="الرجائ التأكد من اتصالك بالإنترنت";
//"E-mail Address"="البريد الإلكتروني";
//"Phone number"="رقم الجوال";
//"Create password"="انشاء كلمة مرور";
//"Confirm Password"="تأكيد كلمة المرو";
//"I agree to the"="أوافق على";
//"TERMS AND CONDITIONS"="الشروط والأحكام";
//"Password and confirm password are didnot match"="كلمة المرور وتأكيد كلمة المرور غير متطابقة";
//"Please Agree Terms And Conditions"="الرجاء الموافقة على الشروط والاحكام";
//"Both"="كلاهما";
//"Home Services"="خدمة منزلية";
//"Salon"="صالون";
//"Number of providers"="عدد الموضفات";
//"Already have an account?"="لديك حساب بالفعل ؟";
//"Sign in Now!"="سجل الدخول الأن";
//". Use Current Location"="استخدام الموقع الحالي";
//"SET LOCATION"="حدد الموقع";
//"Write your instructions......"="ملاحظات";
//"Write your order instructions"="أضف ملاحظة";
//"Good"="جيد";
//"Excellent"="ممتاز";
//"Average"="متوسط";
//"Please wait for service provider acceptance"="طلبك تحت التأكيد";
//"Your request has been not accepted , try scheduled"="لم يتم قبول الطلب ، جرب الخدمة المجدولة";
//"Your account is under verification,Please wait for admin approval"="حسابك تحت التأكيد ، انتظر موافقة الAdmin";
//"Please select Schedule Time"="الرجاء اختيار الوقت";
//"Please select Schedule Date and Time"="الرجاء اختيار الوقت والتاريخ";
