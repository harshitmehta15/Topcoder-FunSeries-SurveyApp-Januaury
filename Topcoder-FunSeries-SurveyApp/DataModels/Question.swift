//
//  Question.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 1/12/16.
//  Copyright © 2016 topcoder. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Question)
class Question: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func updateWithData(data: NSDictionary) {
        
        self.identifier = data["id"]?.stringValue
        self.question = data["question"] as? String
        self.surveyId = data["surveyId"]?.stringValue
    }
}
