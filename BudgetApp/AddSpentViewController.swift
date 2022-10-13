//
//  AddSpentViewController.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 12.10.2022.
//

import UIKit

class AddSpentViewController: UIViewController {
    
    @IBOutlet weak var spentTextfield: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var navBar: UINavigationBar!
    typealias SpentListener = () -> Void
    var spentListener: SpentListener?
    var selectedCategory: String?
    var spentMoney: String?
    var pickerData = ["Alışveriş","Yiyecek","Seyahat","Sağlık","Teknoloji","Eğlence","Spor","Eğitim","Konaklama"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.barTintColor = UIColor(red: 182.0 / 255.0, green: 94.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        pickerView.addShadow()
        noteTextView.borderColor = UIColor(red: 182.0 / 255.0, green:94.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.5)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        spentMoney = spentTextfield.text
        guard let selectedCategory = selectedCategory else { return }
        guard let spentMoney = Double(spentMoney ?? "0.0") else { return }
        
        if var selectedCategories = app.defaultsManager.getSelectedCategories() {
            selectedCategories.append(selectedCategory)
            app.defaultsManager.setSelectedCategories(categories: selectedCategories)
        } else {
            app.defaultsManager.setSelectedCategories(categories: [selectedCategory])
        }
        
        if var spentMoneys = app.defaultsManager.getSpentMoney() {
            spentMoneys.append(spentMoney)
            app.defaultsManager.setSpentMoney(moneys: spentMoneys)
        } else {
            app.defaultsManager.setSpentMoney(moneys: [spentMoney])
        }
        self.spentListener?()
        self.dismiss(animated: true)
    }
}

extension AddSpentViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = pickerData[row]
    }
}
