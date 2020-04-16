//
//  Transaction.swift
//  try
//
//  Created by Junyi Zhang on 4/16/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import Foundation
import UIKit

class Transaction {
    var location: String
    var amount: String
    //var image: UIImage
    init(amount: String, location: String) {
        //self.image = image
        self.amount = amount
        self.location = location
    }
}
