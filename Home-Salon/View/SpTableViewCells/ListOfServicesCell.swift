//
//  ListOfServicesCell.swift
//  SPScreen
//
//  Created by volive solutions on 26/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class ListOfServicesCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceName_lbl: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override var isSelected: Bool {
        didSet {
           
            self.backView.backgroundColor = isSelected ? UIColor.gray : UIColor.white
        }
    }
    
    
}
