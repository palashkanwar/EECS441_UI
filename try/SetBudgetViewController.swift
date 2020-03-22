//
//  SetBudgetViewController.swift
//  try
//
//  Created by Junyi Zhang on 3/11/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit

class SetBudgetViewController: UIViewController {

    @IBOutlet weak var budgetTxt: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var EndDateTxt: UITextField!
    @IBOutlet weak var warninglabel2: UILabel!
    var datePicker = UIDatePicker()
    var formatter = DateFormatter()
    var toolbar = UIToolbar()
    var budgetValue = ""
    var endDateValue = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EndDateTxt.textAlignment = .center
        
        // toolbar
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        EndDateTxt.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        EndDateTxt.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
        
        // add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
       

    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @objc func donePressed(){
        // formatter
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MM/dd/yyyy"
        if EndDateTxt.isFirstResponder {
            EndDateTxt.text = formatter.string(from: datePicker.date)
            endDateValue = datePicker.date
        }
        self.view.endEditing(true)
        
    }
    
    @IBAction func SubmitClicked(_ sender: Any) {
        if budgetTxt.text == nil {
            warningLabel.text = "Please enter a valid number."
        }
        if EndDateTxt.text == nil {
            warninglabel2.text = "Please pick an ending date."
        } else if let budgetDoubleValue = Double(budgetTxt.text!) {
            if budgetDoubleValue <= 0 {
                warningLabel.text = "Budget should be larger than 0."
            } else {
                warningLabel.text = ""
                warninglabel2.text = ""
                performSegue(withIdentifier: "submitBudgetValue", sender: self)
            }
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "submitBudgetValue" {
            var vc = segue.destination as! MoneyTrackViewController
            guard var budgetDoubleValue = Double(self.budgetValue) else {return}
            vc.budgetValue = budgetDoubleValue
            vc.endDateValue = self.endDateValue
        }
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

