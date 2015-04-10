//
//  ViewController.swift
//  IcloudKit
//
//  Created by Michel Streblow on 4/8/15.
//  Copyright (c) 2015 pegasus studios. All rights reserved.
//
import Foundation
import UIKit
import CloudKit


class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var nameText: UITextField!
    var tableView: UITableView!
    
    var recorda: CKRecord = CKRecord(recordType: "test")
    
    
    
    // Crete an array to store the tasks
    var tasks: NSMutableArray = NSMutableArray()
    // Create a CKRecord for the items in our database we will be retreiving and storing
    var items: [CKRecord] = []
    
    // Function to load all tasks in the UITableView and database
    func loadTasks() {
        
        // Create the query to load the tasks
        let truePredicate = NSPredicate(value: true)
        var query = CKQuery(recordType: "test", predicate: truePredicate)
        var queryOperation = CKQueryOperation(query: query)
        
        println("Start fetch")

        
        // Fetch the items for the record
        func fetched(record: CKRecord!) {
            items.append(record)
            println("abc")
        }
        
        queryOperation.recordFetchedBlock = fetched
        
        // Finish fetching the items for the record
       func fetchFinished(cursor: CKQueryCursor?, error: NSError?) {
            
            if error != nil {
                println("\(error) \(error)")
            } else {
                println("End fetch")
            }
            
            // Print items array contents
            println("\(items)  \(tasks.count)")
            
            // Add contents of the item array to the tasks array
            tasks.addObjectsFromArray(items)
            
            // Reload the UITableView with the retreived contents
            self.tableView?.reloadData()
        }
        
        
        queryOperation.queryCompletionBlock = fetchFinished
        
        // Create the database you will retreive information from
        var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
        database.addOperation(queryOperation)
        

        
        
    }
    
    // Function to delete all tasks in the UITableView and database
    func deleteTasks() {
        
        // Create the query to load the tasks
        var query = CKQuery(recordType: "test", predicate: nil)
        var queryOperation = CKQueryOperation(query: query)
        println("Begin deleting tasks")
        
        // Fetch the items for the record
        func fetched(record: CKRecord!) {
            items.append(record)
        }
        
        queryOperation.recordFetchedBlock = fetched
        
        
        // Finish fetching the items for the record
        func fetchFinished(cursor: CKQueryCursor?, error: NSError?) {
            
            if error != nil {
                println(error)
            }
            
            println("All tasks have been deleted")
            
            // Print items array contents
            println(items)
            
            // Iterate through the array content ids
            var ids : [CKRecordID] = []
            for i in items {
                ids.append(i.recordID)
            }
            
            // Create the database where you will delete your data from
            var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
            
            // Reload the UITableView with the retreived contents
            self.tableView!.reloadData()
            
        }
        
        queryOperation.queryCompletionBlock = fetchFinished
        
        // Create the database where you will retreive your new data from
        var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
        database.addOperation(queryOperation)
    }
    
    // MARK: UITableView Delegate Methods
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        println(tasks)
        
        var task: CKRecord = tasks[indexPath.row] as! CKRecord
        
        // Set the main cell label for the key we retreived: taskKey. This can be optional.
        if let text = task.objectForKey("name") as? String {
            cell.textLabel?.text = text
        }
        
        return cell as UITableViewCell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Deselect the row using an animation.
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Reload the row using an animation.
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    
    // MARK: Lifecycle
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        
        loadTasks()
        self.tableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Create delete button to delete all tasks
        var deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteTasks"))
        self.navigationItem.leftBarButtonItem = deleteButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func buttonSave(sender: AnyObject) {
        
        // Create record to save tasks
        
        // Save task description for key: taskKey
        recorda.setObject(self.nameText.text, forKey: "name")
        
        // Create the private database for the user to save their data to
        var database: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // Save the data to the database for the record: task
        func recordSaved(record: CKRecord?, error: NSError?) {
            
            if (error != nil) {
                // handle it
                println(error)
            }
        }
        
        // Save data to the database for the record: task
        database.saveRecord(recorda, completionHandler: recordSaved)
        println("DONE \(database)")
        
    }
    
    

    

 

}