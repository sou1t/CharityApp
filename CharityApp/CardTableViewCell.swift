//
//  CardTableViewCell.swift
//  CharityApp
//
//  Created by Виталий Волков on 07.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var CardNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var DeleteButton: UIButton!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
