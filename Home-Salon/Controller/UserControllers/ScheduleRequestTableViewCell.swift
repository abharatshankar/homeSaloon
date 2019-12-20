//
//  ScheduleRequestTableViewCell.swift
//  Home-Salon
//
//  Created by harshitha on 09/12/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class ScheduleRequestTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var schCollectionView: UICollectionView!
    
    var selectedCell = [IndexPath]()
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        schCollectionView.delegate = self
        schCollectionView.dataSource = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberOfEmployees+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == 0
        {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "time", for: indexPath) as! TimeAndEmployeeCollectionViewCell
            
            //print(timesArr[indexOfTime],indexOfTime)
            
            cell.timesLbl.text = timesArr[schCollectionView.tag][indexPath.row]
            cell.isUserInteractionEnabled = false
                //timesArr[indexOfTime]
           // print(cell.timesLbl.text)
            return cell
        }
        else
        {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workers", for: indexPath) as! TimeAndEmployeeCollectionViewCell
            
            print(indexPath.row)
            print(employeesArr[indexPath.row])
            //print(employeesArr[schCollectionView.tag][indexPath.row])
            
            if indexPath.row <= employeesArr[schCollectionView.tag][0]
            {
                cell.workerAvailImg.image = UIImage(named: "Group 3874-1")
                cell.isUserInteractionEnabled = false
                
            }
            else
            {
                cell.workerAvailImg.image = UIImage(named: "Rectangle 2921")
               
                cell.isUserInteractionEnabled = true
                
                if selectedCell.contains(indexPath) {
                    cell.workerAvailImg.image = UIImage(named: "Group 3884")
                }
                else {
                    cell.workerAvailImg.image = UIImage(named: "Rectangle 2921")
                }
                
                
                
//                if(cell.isSelected){
//                   cell.workerAvailImg.image = #imageLiteral(resourceName: "Completed")
//                }else{
//                    cell.workerAvailImg.image = #imageLiteral(resourceName: "uncheck")
//                }
               
                
            }
            
            return cell
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//       let cell = collectionView.cellForItem(at: indexPath) as! TimeAndEmployeeCollectionViewCell
//
//        if cell.isSelected {
//            cell.workerAvailImg.image = #imageLiteral(resourceName: "Completed")
//            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
//            return false
//        }
//        else{
//            cell.workerAvailImg.image = #imageLiteral(resourceName: "uncheck")
//        }
//
//        return true
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as? TimeAndEmployeeCollectionViewCell
       
        selectedCell.removeAll()
       // print([collectionView.tag][indexPath.section])
        selectedCell.append(indexPath)
       
        cell?.workerAvailImg.image = UIImage(named: "Group 3884")
        print(indexPath.section)
        print(indexPath)
        collectionView.allowsMultipleSelection = false

      
        //schCollectionView.deselectAllItems(animated: false)
        let slotTime = timesArr[schCollectionView.tag][indexPath.section]
        print(slotTime)

        let imageDataDict:[String: String] = ["slotTime": slotTime]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookTimePressed"), object: nil, userInfo: imageDataDict)

       // schCollectionView.reloadData()

    }




    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeAndEmployeeCollectionViewCell
        if selectedCell.contains(indexPath) {
            selectedCell.remove(at: selectedCell.index(of: indexPath)!)
            cell.workerAvailImg.image = UIImage(named: "Rectangle 2921")
        }
  
    
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 50, height:50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            
          self.deselectItem(at: indexPath, animated: animated)
        }
    }
}
