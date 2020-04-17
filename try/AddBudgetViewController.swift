//
//  AddBudgetViewController.swift
//  try
//
//  Created by Junyi Zhang on 4/15/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit
import FirebaseDatabase
class AddBudgetViewController: UIViewController {


    @IBOutlet weak var addBudgetTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func submitBtn(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("claudia").childByAutoId().setValue(["amount":self.addBudgetTxt.text, "location":"", "receipt_url":"", "attribute":"+"] as [String:Any])
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        // push data
        
    }
    
}
