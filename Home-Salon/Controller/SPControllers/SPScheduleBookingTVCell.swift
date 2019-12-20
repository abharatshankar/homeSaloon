//
//  SPScheduleBookingTVCell.swift
//  Home-Salon
//
//  Created by harshitha on 10/12/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire


class SPScheduleBookingTVCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var schTimingCollection: UICollectionView!
   
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        schTimingCollection.delegate = self
        schTimingCollection.dataSource = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return spEmployees+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "time1", for: indexPath) as! TimeAndEmployeeCollectionViewCell
            cell.timesLbl.text = sptimesArr[schTimingCollection.tag][indexPath.row]
            
            return cell
        }
        else
        {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workers1", for: indexPath) as! TimeAndEmployeeCollectionViewCell
            
            
//            if indexPath.row <= spemployeesArr[schTimingCollection.tag][0]
//            {
//                cell.workerAvailImg.image = #imageLiteral(resourceName: "Group 2364")
//            }
//            else
//            {
//                cell.workerAvailImg.image = #imageLiteral(resourceName: "uncheck")
//            }
            
            if indexPath.row <= spemployeesArr[schTimingCollection.tag][0]
            {
                var id = dictMain[schTimingCollection.tag][indexPath.row-1]
                print(id)
                let name = dictName[schTimingCollection.tag][indexPath.row-1]
                print(name)
                
                let color = dictColor[schTimingCollection.tag][indexPath.row-1]
                print(color)
                if id != ""
                {
                    id = "Order Id" + ":" + id
                }
                cell.orderIdLbl.text = id
                cell.nameLbl.text = name
                if color == ""
                {
                    cell.workerAvailImg.backgroundColor = #colorLiteral(red: 0.4151776433, green: 0.4554072618, blue: 0.5596991777, alpha: 1)
                }
                else
                {
                 cell.workerAvailImg.backgroundColor = hexStringToUIColor(hex: color)
                }
                
                cell.isUserInteractionEnabled = false
                
                //cell.workerAvailImg.backgroundColor = hexStringToUIColor(hex: <#T##String#>)
            }
            else
            {
                cell.nameLbl.text = ""
                cell.orderIdLbl.text = ""
                //cell.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                cell.workerAvailImg.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.isUserInteractionEnabled = true
                //cell.workerAvailImg.image = #imageLiteral(resourceName: "uncheck")
                
            }
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let slotTime = sptimesArr[self.schTimingCollection.tag][indexPath.section]
        print(slotTime)

        let imageDataDict:[String: String] = ["slotTime": slotTime]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "slotTimePressed"), object: nil, userInfo: imageDataDict)
        
        
    }
    
  
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
          return CGSize(width: 50, height:60)
        }
        else
        {
            return CGSize(width: 60, height:60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
