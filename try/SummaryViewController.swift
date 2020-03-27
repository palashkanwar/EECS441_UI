//
//  SummaryViewController.swift
//  try
//
//  Created by Zhenyang gong on 3/23/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var tableView: UITableView!
    // Data model: These strings will be the data for the table view cells
    // var animals: [String] = ["$4 at courtyard", "$2 at north campus", "$32 at home"]
    var pastdata = [String]()
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
 
    // don't forget to hook this up from the storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastdata.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!

        // set the text from the data model
        cell.textLabel?.text = self.pastdata[indexPath.row]
        print(self.pastdata[indexPath.row])
        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    // pass in data from DB 
    func loadData() {
        
        let ref = Database.database().reference()
        
        ref.child("claudia").observe(DataEventType.value) { (snapshot) in
            //print(snapshot)
            
            for transaction in snapshot.children.allObjects as![DataSnapshot] {
                let transactionObject = transaction.value as? [String:String]
                let amount = String((transactionObject?["amount"])!)
                let location = String((transactionObject?["location"])!)
                let message = "$" + amount + " at " + location
                self.pastdata.append(message)
                //print(self.pastdata)
                self.tableView.reloadData()
            }
        }
            
    }
        
}
