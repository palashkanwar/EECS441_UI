//
//  ChartViewController.swift
//  try
//
//  Created by Junyi Zhang on 4/20/20.
//  Copyright © 2020 Junyi Zhang. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet var pieView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupPieChart()
    }
    
    func setupPieChart() {
        pieView.chartDescription?.enabled = false
        pieView.drawHoleEnabled = false
        pieView.rotationAngle = 0
        //pieView.rotationEnabled = false
        //pieView.isUserInteractionEnabled = false
        
        //pieView.legend.enabled = false
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: 50.0, label: "Budget"))
        entries.append(PieChartDataEntry(value: 30.0, label: "Food"))
        entries.append(PieChartDataEntry(value: 20.0, label: "Entertainment"))
        entries.append(PieChartDataEntry(value: 10.0, label: "Grocery"))
        entries.append(PieChartDataEntry(value: 40.0, label: "Transportation"))
        entries.append(PieChartDataEntry(value: 40.0, label: "Travel"))
        entries.append(PieChartDataEntry(value: 40.0, label: "Education"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        let c1 = NSUIColor(hex: 0xA8E6CE)
        let c2 = NSUIColor(hex: 0xcdd9a1)
        let c3 = NSUIColor(hex: 0xb6cf89)
        let c4 = NSUIColor(hex: 0x62b177)
        let c5 = NSUIColor(hex: 0x58a089)
        let c6 = NSUIColor(hex: 0x41779e)
        let c7 = NSUIColor(hex: 0xDCEDC2)
    
        dataSet.colors = [c1, c7,c2, c3, c4, c5, c6]
        dataSet.drawValuesEnabled = false
        
        pieView.data = PieChartData(dataSet: dataSet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
