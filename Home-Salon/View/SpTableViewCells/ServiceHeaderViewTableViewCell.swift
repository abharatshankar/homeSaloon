//
//  ServiceHeaderViewTableViewCell.swift
//  HomeSalon_ServiceProvider_App
//
//  Created by Rajesh Kishanchand on 8/1/19.
//  Copyright © 2019 Volive Solutions. All rights reserved.
//

import UIKit


class ServiceHeaderViewTableViewCell: UITableViewCell {
   
    @IBOutlet var expend_Img: UIImageView!
    @IBOutlet var serviceName_Label: UILabel!
    @IBOutlet var serviceImg_ImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Call tapHeader when tapping on this header
        //
        
        
        // Initialization code
    }

    func setExpanded() {
        
         expend_Img.image = #imageLiteral(resourceName: "Group2342942")
    }
    func setCollapsed() {
        
        expend_Img.image = #imageLiteral(resourceName: "Group 2942")
    }
    

}
