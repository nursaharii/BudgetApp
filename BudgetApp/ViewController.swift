//
//  ViewController.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 5.10.2022.
//

import UIKit

class ViewController: UIViewController {
    let progressView = CircularProgressView(frame: CGRect(x: 3, y: 10, width: 200, height: 200), lineWidth: 15, rounded: true)
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
    var categoryData = ["Alışveriş","Yiyecek","Seyahat","Sağlık","Teknoloji","Eğlence","Spor","Eğitim","Konaklama"]
    
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
                
                
                if self.left > 0 {
                    self.dailyLeft.textColor = .systemGreen
                } else {
                    self.dailyLeft.textColor = .systemRed
                }
                self.dailyLeft.text = String(self.left)
                self.progressView.progress = Float(spentRate)
            }
        }
    }
    
    @IBAction func addSpent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddSpentVC") as! AddSpentViewController
        self.present(viewController,animated: true) {
            viewController.spentListener = {
                self.setBudgetValues()
            }
        }
    }
    
    @IBAction func goChartView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ShowChartVC") as! ShowChartViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @IBAction func removeAll(_ sender: Any) {
        let alert = UIAlertController(title: "Verileri Sil", message: "Tüm verileriniz silinecek devam etmek istiyor musunuz?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (sender: UIAlertAction) -> Void in
            self.removeValues()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (sender: UIAlertAction) -> Void in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true)
        
    }
    func setBudgetValues() {
        self.category.removeAll()
        self.spentMoneys.removeAll()
        
        if let spentMoneys = app.defaultsManager.getSpentMoney() {
            self.spent = spentMoneys.reduce(0, +)
        }
        self.left = (self.limit ?? 0) - self.spent
        if self.left > 0 {
            self.dailyLeft.textColor = .systemGreen
        } else {
            self.dailyLeft.textColor = .systemRed
        }
        
        self.dailyLeft.text = String(self.left).replacingOccurrences(of: ".", with: ",")
        self.dailySpent.text = String(self.spent).replacingOccurrences(of: ".", with: ",")
        let spentRate = 1 - (self.spent / (self.limit ?? 0))
        self.progressView.progress = Float(spentRate)
        
        if let selectedCategory = app.defaultsManager.getSelectedCategories() {
            self.category = selectedCategory
        }
        if let spentMoney = app.defaultsManager.getSpentMoney() {
            self.spentMoneys = spentMoney
        }
        tableView.reloadData()
    }
    
    func removeValues() {
        app.defaultsManager.removeLimit()
        app.defaultsManager.removeSpentMoney()
        app.defaultsManager.removeSelectedCategories()
        category = []
        spentMoneys = []
        left = 0
        spent = 0
        limit = 0
        dailyLeft.text = "0"
        dailySpent.text = "0"
        tableView.reloadData()
        progressView.progress = 1
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
            cell.category.textColor = UIColor.white
            cell.amount.text = String(spentMoneys[indexPath.row])
            cell.amount.textColor = UIColor.white
            for i in 0 ... 8 {
                if category[indexPath.row] == categoryData[i] {
                    cell.backgroundColor = UIColor.categoryColor[i]
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _,_, completionHandler in
            if !self.category.isEmpty {
                self.category.remove(at: indexPath.row)
                self.spentMoneys.remove(at: indexPath.row)
                app.defaultsManager.setSelectedCategories(categories: self.category)
                app.defaultsManager.setSpentMoney(moneys: self.spentMoneys)
                self.setBudgetValues()
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor.systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
