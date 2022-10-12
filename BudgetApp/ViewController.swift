//
//  ViewController.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 5.10.2022.
//

import UIKit

class ViewController: UIViewController {
    let progressView = CircularProgressView(frame: CGRect(x: 7, y: 7, width: 200, height: 200), lineWidth: 15, rounded: true)
    @IBOutlet weak var viewForProgress: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dailySpent: UILabel!
    @IBOutlet weak var dailyLeft: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var spent : Double = 0
    var limit : Double?
    var left = 0.0
    var spentMoneys = [Double]()
    var category = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCategory = app.defaultsManager.getSelectedCategories() {
            category = selectedCategory
        }
        if let spentMoney = app.defaultsManager.getSpentMoney() {
            spentMoneys = spentMoney
        }
        
        infoView.rounded()
        progressView.progressColor = .blue
        progressView.trackColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        viewForProgress.addSubview(progressView)
        infoView.addShadow()
        
        if let spentMoneys = app.defaultsManager.getSpentMoney() {
            self.spent = spentMoneys.reduce(0, +)
        }
        limit = app.defaultsManager.getLimit()
        
        if let dailylimit = limit{
            left = (dailylimit) - spent
            let spentRate = 1 - (spent / dailylimit)
            if left > 0 {
                dailyLeft.textColor = .systemGreen
            } else {
                dailyLeft.textColor = .systemRed
            }
            progressView.progress = Float(spentRate)
            dailyLeft.text = String(left).replacingOccurrences(of: ".", with: ",")
            dailySpent.text = String(spent).replacingOccurrences(of: ".", with: ",")
            
        } else {
            dailyLeft.text = String(0.0).replacingOccurrences(of: ".", with: ",")
            dailySpent.text = String(spent).replacingOccurrences(of: ".", with: ",")
            progressView.progress = 1
        }
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.barTintColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.tableViewHeight.constant = newSize.height
                print(newSize.height)
            }
        }
    }
    
    
    @IBAction func setLimit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetLimitVC") as! SetLimitViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController,animated: true) {
            viewController.limitListener = {
                
                self.limit = app.defaultsManager.getLimit()
                self.left = (self.limit ?? 0) - self.spent
                let spentRate = 1 - (self.spent / (self.limit ?? 0))
                self.progressView.progress = Float(spentRate)
                
                if self.left > 0 {
                    self.dailyLeft.textColor = .systemGreen
                } else {
                    self.dailyLeft.textColor = .systemRed
                }
                self.dailyLeft.text = String(self.left)
            }
        }
    }
    
    @IBAction func addSpent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddSpentVC") as! AddSpentViewController
        self.present(viewController,animated: true) {
            viewController.spentListener = {
                if let spentMoneys = app.defaultsManager.getSpentMoney() {
                    self.spent = spentMoneys.reduce(0, +)
                }
                self.left = (self.limit ?? 0) - self.spent
                if self.left > 0 {
                    self.dailyLeft.textColor = .systemGreen
                } else {
                    self.dailyLeft.textColor = .systemRed
                }
                
                self.limit = app.defaultsManager.getLimit()
                self.dailyLeft.text = String(self.left).replacingOccurrences(of: ".", with: ",")
                self.dailySpent.text = String(self.spent).replacingOccurrences(of: ".", with: ",")
                let spentRate = 1 - (self.spent / (self.limit ?? 0))
                self.progressView.progress = Float(spentRate)
                
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpentDetailCell",for: indexPath) as? SpentDetailCell {
            cell.selectionStyle = .none
            cell.category.text = category[indexPath.row]
            cell.amount.text = String(spentMoneys[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
