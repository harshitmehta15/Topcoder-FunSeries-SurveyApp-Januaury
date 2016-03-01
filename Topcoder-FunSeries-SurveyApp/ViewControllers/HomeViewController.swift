//
//  ViewController.swift
//  Topcoder-FunSeries-SurveyApp
//
//  Created by Burhanuddin Sunelwala on 28/10/15.
//  Copyright (c) 2015 topcoder. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate {
    
    var dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
    var fetchedResultsController: NSFetchedResultsController!

    @IBOutlet var surveyTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeFetchedResultsController()
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.bounds), height: 44.0))
        searchBar.delegate = self
        
        surveyTable.tableHeaderView = searchBar
        
        let surveyItem: NSData? = NSData(contentsOfURL: NSURL(string: "http://www.mocky.io/v2/560920cc9665b96e1e69bb46")!)
        if let data = surveyItem {
            parseSurveyItem(data)
        }
        
        let questionItem: NSData? = NSData(contentsOfURL: NSURL(string: "https://demo2394932.mockable.io/wizard")!)
        if let questionsData = questionItem {
            parseQuestions(questionsData)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        dataController.save()
    }
    
    //MARK: SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        let predicate: NSPredicate
        if searchText.characters.count == 0 {
            
            predicate = NSPredicate(format: "isdeleted == %@", argumentArray: [NSNumber(bool: false)])
        } else {
            
            predicate = NSPredicate(format: "title CONTAINS[c] %@ AND isdeleted == %@", argumentArray: [searchText, NSNumber(bool: false)])
        }
        
        self.fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        surveyTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func parseSurveyItem(inputData: NSData) {
        
        let data: NSArray = (try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! [NSDictionary]
        
        for serverItem in data {
            
            let tempItem = serverItem as! NSDictionary
            let fetchRequest = NSFetchRequest(entityName: "Item")
            let predicate = NSPredicate(format: "identifier == %@", argumentArray: [tempItem["id"]!.stringValue])
            fetchRequest.predicate = predicate
            do {
                let fetchResults = try self.dataController.managedObjectContext.executeFetchRequest(fetchRequest) as? [Item]
                if fetchResults?.count == 0 {
                    
                    let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: self.dataController.managedObjectContext) as! Item
                    item.isdeleted = NSNumber(bool: false)
                    item.updateWithData(tempItem)
                }
            }
            catch {}
        }
    }
    
    func parseQuestions(inputData: NSData) {
        
        let questionsData: NSArray = (try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! [NSDictionary]
        
        for questionDic in questionsData {
            
            let fetchRequest = NSFetchRequest(entityName: "Question")
            let predicate = NSPredicate(format: "identifier == %@", argumentArray: [questionDic["id"]!!.stringValue])
            fetchRequest.predicate = predicate
            do {
                let fetchResults = try self.dataController.managedObjectContext.executeFetchRequest(fetchRequest) as? [Question]
                if fetchResults?.count == 0 {
                    
                    let question = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: self.dataController.managedObjectContext) as? Question
                    question?.updateWithData(questionDic as! NSDictionary)
                }
            }
            catch {}
        }
    }
    
    //MARK: TableView DataSource
    func numberOfSectionsInTableView(SurveyTable: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(SurveyTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sections: [NSFetchedResultsSectionInfo] = (self.fetchedResultsController.sections )!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        cell.textLabel?.text = item.title
    }
    
    func tableView(SurveyTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell1 = SurveyTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        self.configureCell(cell1, indexPath: indexPath)
        return cell1
    }
    
    //MARK: TableView Delegate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        item.isdeleted = NSNumber(bool: true)
        dataController.save()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("ShowDetailViewController", sender: indexPath)
    }
    
    //MARK: Segue Delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetailViewController" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = sender as! NSIndexPath
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            detailViewController.item = item
            detailViewController.detailText = item.desc
        }
    }
    
    //MARK: NSFetchedResultsController
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest(entityName: "Item")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "isdeleted == %@", argumentArray: [NSNumber(bool: false)])
        request.predicate = predicate
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.dataController.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.surveyTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.surveyTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.surveyTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

        switch type {
        case .Insert:
            self.surveyTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.surveyTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update: break
//            self.configureCell(self.surveyTable.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            self.surveyTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.surveyTable.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.surveyTable.endUpdates()
    }

}
