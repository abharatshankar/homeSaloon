//
//  EditListServiceCell.swift
//  SPScreen
//
//  Created by volive solutions on 26/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class EditListServiceCell: UITableViewCell {

    @IBOutlet weak var updatingView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var servicePrice_lbl: UILabel!
    @IBOutlet weak var serviceName_lbl: UILabel!
   
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // self.deleteView.layer.cornerRadius = 15
        
       // self.deleteView.layer.borderWidth = 1
        //self.deleteView.layer.borderColor = UIColor.black.cgColor
        //self.editView.layer.cornerRadius = 15
        
        //self.editView.layer.borderWidth = 1
       // self.editView.layer.borderColor = UIColor.black.cgColor
        
        //deleteView.layer.masksToBounds = true
       // editView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
