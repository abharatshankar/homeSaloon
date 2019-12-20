//
//  AcceptanceViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 01/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class AcceptanceViewController: UIViewController {

    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var providerAcceptanceSt: UILabel!
    
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false

    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        providerAcceptanceSt.text = languageChangeString(a_str: "Please wait for service provider acceptance")
        
        runTimer()
    }
    

    func runTimer() {
        
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:#selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current .add(timer, forMode: RunLoop.Mode.common)
        
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        //let new = String(format:"%02i:%02i:%02i",hours ,minutes, seconds)
        return String(format:"%02i:%02i:%02i", hours,minutes, seconds)
    }
    
    @objc func updateTimer()
    {
        seconds = seconds-1
         timerLbl.text = timeString(time: TimeInterval(seconds))
        
        if seconds == 00 {
            DispatchQueue.main.async {
               
                self.stopTimer()
                
                DispatchQueue.main.async {
                    
                    self.showToastForAlert(message: "Your request has been not accepted Please try again")
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                    {
                
                let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController1") as! UserHomeViewController
                self.navigationController?.pushViewController(details, animated: true)
                    }
                
                }
//                let userHome =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController")
//                userOrOwnerType = "1"
//                self.present(userHome, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func stopTimer()
    {
        if timer != nil {
            timer.invalidate()
            timer = Timer()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
         NotificationCenter.default.addObserver(self, selector: #selector(orderAccept(_:)), name: NSNotification.Name(rawValue: "messageSent"), object: nil)
    }
    
    @objc func orderAccept(_ notification: Notification)
    {
        stopTimer()
        
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
         details.checkString = "Side"
        self.navigationController?.pushViewController(details, animated: true)
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        let userRequests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
        userRequests.checkString = ""
        self.navigationController?.pushViewController(userRequests, animated: true)
    }
    

}
