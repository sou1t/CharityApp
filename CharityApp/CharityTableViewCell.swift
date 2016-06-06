//
//  CharityTableViewCell.swift
//  CharityApp
//
//  Created by Виталий Волков on 06.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class CharityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CharityImage: UIImageView!
    @IBOutlet weak var CharityProgress: UIProgressView!
    @IBOutlet weak var NumberOfGet: UILabel!
    @IBOutlet weak var NumberOfPeople: UILabel!
    @IBOutlet weak var DaysToEnd: UILabel!
    @IBOutlet weak var Percentage: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var CharityDescription: UILabel!
    @IBOutlet weak var PersonName: UILabel!
    @IBOutlet weak var CharityName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func Help(sender: AnyObject) {
        
    }
}
