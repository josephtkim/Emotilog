//
//  TableViewControllerTableViewCell.swift
//  Journal
//
//  Created by Isaac Kim on 6/10/17.
//  Copyright © 2017 kimbros. All rights reserved.
//

import UIKit

class TableViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
