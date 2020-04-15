//
//  AddBudgetViewController.swift
//  try
//
//  Created by Junyi Zhang on 4/15/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit
class AddBudgetViewController: UIViewController {


    @IBOutlet weak var addBudgetTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
