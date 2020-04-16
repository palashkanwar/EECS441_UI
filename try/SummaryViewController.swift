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

class summaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(transactions.count)
        return self.transactions.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactions[indexPath.row]
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
        print(transaction.location)
        cell.setTransaction(transaction: transaction)

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
            for transaction in snapshot.children.allObjects as![DataSnapshot] {
                let transactionObject = transaction.value as? [String:String]
                let amount = "$" + String((transactionObject?["amount"])!)
                let location = String((transactionObject?["location"])!)
                let tran_object = Transaction(amount: amount, location: location)
                self.transactions.append(tran_object)
                self.tableView.reloadData()

            }
        }
            
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

        
}
