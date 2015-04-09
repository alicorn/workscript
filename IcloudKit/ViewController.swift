//
//  ViewController.swift
//  IcloudKit
//
//  Created by Michel Streblow on 4/8/15.
//  Copyright (c) 2015 pegasus studios. All rights reserved.
//

import UIKit
import CloudKit

var feedResults = [nameList]()

class nameList {
    
    var record: CKRecord
    var name: String
    
    init(record: CKRecord) {
        
        self.record = record
        self.name = record.objectForKey("name") as! String
        
        
    }
}

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var nameText: UITextField!
    var tableView: UITableView!


    var record: CKRecord = CKRecord(recordType: "test")
   
    
    let items = ["Hello 1", "Hello 2", "Hello 3", "Hallo 4"]
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
       
        let record = feedResults[indexPath.row]
        cell.textLabel?.text = record.name
        
        //cell.textLabel?.text = "\(self.items[indexPath.row])"
        
        
        return cell
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func buttonSave(sender: AnyObject) {
        
        // Create record to save tasks
        
        // Save task description for key: taskKey
        record.setObject(self.nameText.text, forKey: "name")
        
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
        database.saveRecord(record, completionHandler: recordSaved)
        println("DONE \(database)")
        
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}