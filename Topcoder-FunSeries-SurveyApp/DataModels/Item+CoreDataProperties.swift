//
//  Item+CoreDataProperties.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 1/12/16.
//  Copyright © 2016 topcoder. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var desc: String?
    @NSManaged var identifier: String?
    @NSManaged var isdeleted: NSNumber?
    @NSManaged var title: String?

}
