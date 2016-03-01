//
//  Question+CoreDataProperties.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 1/13/16.
//  Copyright © 2016 topcoder. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var identifier: String?
    @NSManaged var question: String?
    @NSManaged var surveyId: String?
    @NSManaged var answer: String?

}
