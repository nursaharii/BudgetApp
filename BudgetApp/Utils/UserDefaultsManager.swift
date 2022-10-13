//
//  UserDefaults.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 12.10.2022.
//

import Foundation

class UserDefaultsManager {
    let defaults = UserDefaults.standard
    
    public func setLimit(limit: Double?) {
        defaults.set(limit,forKey: "dailyLimit")
    }
    public func removeLimit() {
        defaults.set(nil,forKey: "dailyLimit")
    }
    
    public func getLimit() -> Double? {
        return defaults.value(forKey: "dailyLimit") as? Double
    }
    
    public func setSelectedCategories(categories: [String]?) {
        defaults.set(categories,forKey: "selectedCategory")
    }
    
    public func removeSelectedCategories() {
        defaults.set(nil,forKey: "selectedCategory")
    }
    
    public func removeSelectedCategories(categories: [String]?) {
        defaults.set(categories,forKey: "selectedCategory")
    }
    
    public func getSelectedCategories() -> [String]?{
        defaults.value(forKey: "selectedCategory") as? [String]
    }
    
    public func setSpentMoney(moneys: [Double]?) {
        defaults.set(moneys,forKey: "spentMoney")
    }
    
    public func removeSpentMoney()  {
        defaults.set(nil,forKey: "spentMoney")
    }
    
    public func removeSpentMoney(moneys: [Double]?)  {
        defaults.set(nil,forKey: "spentMoney")
    }
    
    public func getSpentMoney() -> [Double]?{
        defaults.value(forKey: "spentMoney") as? [Double]
    }
}
