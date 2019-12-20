//
//  ServieListTableViewCell.swift
//  HomeSalon_ServiceProvider_App
//
//  Created by Rajesh Kishanchand on 8/1/19.
//  Copyright © 2019 Volive Solutions. All rights reserved.
//

import UIKit

class ServieListTableViewCell: UITableViewCell {

    @IBOutlet var servicename_Label: UILabel!
    
    
    @IBOutlet weak var serviceSelectedOrNot: UIButton!
    @IBOutlet weak var expand_Img: UIImageView!
    @IBOutlet weak var subCatageoryPriceLbl: UILabel!
    
    @IBOutlet weak var subCatageoryNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setExpanded() {
        
        expand_Img.image = #imageLiteral(resourceName: "Group2342942")
    }
    func setCollapsed() {
        
        expand_Img.image = #imageLiteral(resourceName: "Group 2942")
    }
    


}
