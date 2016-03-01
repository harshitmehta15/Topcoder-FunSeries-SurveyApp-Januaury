//
//  SurveyViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 1/11/16.
//  Copyright © 2016 topcoder. All rights reserved.
//

import UIKit
import CoreData

class SurveyViewController : UIViewController {
    
    var dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
    var item : Item?
    var questions : [Question]?
    var pageNumberLabel = UILabel()
    var questionIndex = 0
    

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerTitleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var pageNumberBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var previousBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageNumberLabel.font = UIFont.systemFontOfSize(14.0);
        pageNumberLabel.textColor = UIColor.whiteColor()
        
        pageNumberBarButtonItem.customView = pageNumberLabel
        
        answerTextView.layer.borderWidth = 1.0
        answerTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        answerTextView.layer.cornerRadius = 3.0
        
        let fetchRequest = NSFetchRequest(entityName: "Question")
        let predicate = NSPredicate(format: "surveyId == %@", argumentArray: [(item?.identifier)!])
        fetchRequest.predicate = predicate
        
        do {
            questions = try self.dataController.managedObjectContext.executeFetchRequest(fetchRequest) as? [Question]
            if questions?.count > 0 {
                self.updateQuestion()
            } else {
                pageNumberLabel.text = "No questions found for this item."
                pageNumberLabel.sizeToFit()
                nextBarButtonItem.enabled = false
                questionTitleLabel.hidden = true
                questionLabel.hidden = true
                answerTitleLabel.hidden = true
                answerTextView.hidden = true   
            }
            
            previousBarButtonItem.enabled = false
            
        } catch {
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if questions?.count > 0 {
            self.saveAnswer()
        }
        dataController.save()
    }
    
    @IBAction func previousBarButtonItemClicked(sender: UIBarButtonItem) {
        
        self.saveAnswer()
        if questionIndex == questions!.count - 1 {
            
            nextBarButtonItem.title = nil
            nextBarButtonItem.image = UIImage(named: "Icon-Right")
        }
        
        if questionIndex > 0 {
            
            --questionIndex
            self.updateQuestion()
            
            if questionIndex == 0 {
                previousBarButtonItem.enabled = false
            }
        }
    }
    
    @IBAction func nextBarButtonItemClicked(sender: UIBarButtonItem) {
        
        self.saveAnswer()
        if questionIndex < questions!.count - 1 {
            
            ++questionIndex
            self.updateQuestion()
            
            if questionIndex == questions!.count - 1 {
                nextBarButtonItem.title = "Finish"
                nextBarButtonItem.image = nil
            } else {
                nextBarButtonItem.title = nil
                nextBarButtonItem.image = UIImage(named: "Icon-Right")
            }
        } else {
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        if questionIndex > 0 {
            previousBarButtonItem.enabled = true
        }
    }
    
    func updateQuestion() {
        
        questionLabel.text = questions![questionIndex].question
        answerTextView.text = questions![questionIndex].answer
        pageNumberLabel.text = "\(questionIndex+1) / \(questions!.count)"
        pageNumberLabel.sizeToFit()
    }
    
    func saveAnswer() {
        
        questions![questionIndex].answer = answerTextView.text
        answerTextView.text = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        answerTextView.endEditing(true)
    }
}