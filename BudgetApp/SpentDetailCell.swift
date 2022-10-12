//
//  SpentDetailCell.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 12.10.2022.
//

import UIKit

class SpentDetailCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var category: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
