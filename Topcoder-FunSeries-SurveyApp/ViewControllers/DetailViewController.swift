//
//  DetailViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 12/22/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextView: UITextView!
    var detailText: String?
    var item : Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTextView.text = detailText
    }
    
    //MARK: Segue Delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LaunchSurvey" {
            let surveyViewController = segue.destinationViewController as! SurveyViewController
            surveyViewController.item = item
        }
    }
}
