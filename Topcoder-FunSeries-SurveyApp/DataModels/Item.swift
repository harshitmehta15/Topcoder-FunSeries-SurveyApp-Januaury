//
//  Item.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 11/29/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func updateWithData(data: NSDictionary) {
        
        self.identifier = data["id"]?.stringValue
        self.title = data["title"] as? String
        self.desc = data["description"] as? String
    }

}
