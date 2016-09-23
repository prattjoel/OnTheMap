//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Joel on 9/22/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import UIKit

class StudentsTableViewController: UITableViewController {
    
//    var studentCollection = StudentInformationStore.sharedInstance.studentInformationCollection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("the number of students is: \(StudentInformationStore.sharedInstance.studentInformationCollection.count)")
        return StudentInformationStore.sharedInstance.studentInformationCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath)
        let item = StudentInformationStore.sharedInstance.studentInformationCollection[indexPath.row]
        
        cell.textLabel?.text = "\(item.firstName) \(item.lastName)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = StudentInformationStore.sharedInstance.studentInformationCollection[indexPath.row]
        if let urlString = item.mediaURL {
            print(urlString)
            let app = UIApplication.sharedApplication()
            
//            let url = NSURL(string: urlString)
            if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
                let url = NSURL(string: urlString)
                app.openURL(url!)
            } else {
                let urlStringWithScheme = "http://\(urlString)"
                let url = NSURL(string: urlStringWithScheme)
                app.openURL(url!)
            }
            
        } else {
            print("no url provided")
        }
    }
    
}
