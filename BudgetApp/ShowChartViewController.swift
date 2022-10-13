//
//  ShowChartViewController.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 13.10.2022.
//

import UIKit
import Charts

class ShowChartViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    
    var categoryData = ["Alışveriş","Yiyecek","Seyahat","Sağlık","Teknoloji","Eğlence","Spor","Eğitim","Konaklama"]
    var categories = [String]()
    var categoryValues = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var dataEntries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCategory = app.defaultsManager.getSelectedCategories() {
            categories = selectedCategory
        }
        if let spentMoney = app.defaultsManager.getSpentMoney() {
            for i in 0 ... 8 {
                let valArr = categories.enumerated().filter {$0.element.contains(categoryData[i])}.map{$0.offset}
                for val in valArr {
                    categoryValues[i] += spentMoney[val]
                }
            }
        }
        
        for i in 0..<categoryData.count {
            
            //if value is 0 not adding to array of dataEntries
            if categoryValues[i] != 0 {
                
                let dataEntry = PieChartDataEntry(value: categoryValues[i], label: categoryData[i], data: categoryData[i] as AnyObject)
                dataEntries.append(dataEntry)
            }
        }
        
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = UIColor.categoryColor
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        pieChart.data = chartData
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
