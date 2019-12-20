//
//  ServiceProviderListModel.swift
//  Home-Salon
//
//  Created by harshitha on 18/09/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import Foundation

class ServiceProviderListModel{
    
    var category_id : String!
    var category_name_en : String!
    var category_image : String!
    
    var subcategory_id = [String]()
    var subcategory_name_en = [String]()
    var subcategoryPrice = [String]()
    
    init(providerListData : NSDictionary){
        if let category_name_en = providerListData["category_name_en"]{
            self.category_name_en = category_name_en as? String ?? ""
        }
        if let category_image = providerListData["category_image"]{
            self.category_image = category_image as? String ?? ""
        }
        if let category_id = providerListData["category_id"]{
            self.category_id = category_id as? String ?? ""
        }
        if let subCatDict = providerListData["services"] as? [[String:Any]]{
            subcategory_id = subCatDict.compactMap {$0["subcategory_id"] as? String }
            subcategory_name_en = subCatDict.compactMap {$0["subcategory_name_en"] as? String }
            subcategoryPrice = subCatDict.compactMap {$0["price"] as? String }
            
        }
    }
    
    
}

