//
//  ServicesTableViewCell.swift
//  SPScreen
//
//  Created by volive solutions on 26/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var servicePrice_lbl: UILabel!
    @IBOutlet weak var serviceName_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
