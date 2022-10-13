//
//  SetLimitViewController.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 12.10.2022.
//

import UIKit

class SetLimitViewController: UIViewController {
 
    @IBOutlet weak var limitTextField: UITextField!
    typealias LimitListener = () -> Void
    var limitListener: LimitListener?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        limitTextField.setLeftPadding(15)
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        if let limit = limitTextField.text {
            app.defaultsManager.setLimit(limit: Double(limit))
            self.limitListener?()
            self.dismiss(animated: true)
        }
    }
    
}
