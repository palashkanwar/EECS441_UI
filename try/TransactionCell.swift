//
//  TransactionCell.swift
//  try
//
//  Created by Junyi Zhang on 4/16/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var receiptView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func setTransaction(transaction: Transaction) {
        amountLabel.text = transaction.amount
        print(transaction.location)
        locationLabel.text = transaction.location
    }
    
}
