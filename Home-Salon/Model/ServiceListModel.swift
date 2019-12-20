//
//  ServiceListModel.swift
//  Home-Salon
//
//  Created by harshitha on 09/09/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import Foundation

class ServiceListModel{
    
    var category_id : String!
    var category_name_en : String!
    var category_image : String!
    var subcategory_image = [String]()
    var subcategory_id = [String]()
    var subcategory_name_en = [String]()
    
    init(categoryData : NSDictionary){
        if let category_name_en = categoryData["category_name_en"]{
            self.category_name_en = category_name_en as? String ?? ""
        }
        if let category_image = categoryData["category_image"]{
            self.category_image = category_image as? String ?? ""
        }
        if let category_id = categoryData["category_id"]{
            self.category_id = category_id as? String ?? ""
        }
        if let catDict = categoryData["subcategory"] as? [[String:Any]]{
            subcategory_image = catDict.compactMap { $0["subcategory_image"] as? String }
            subcategory_id = catDict.compactMap {$0["subcategory_id"] as? String }
            subcategory_name_en = catDict.compactMap {$0["subcategory_name_en"] as? String }
        }
    }
}
