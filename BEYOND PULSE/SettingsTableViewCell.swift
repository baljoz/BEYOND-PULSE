//
//  SettingsTableViewCell.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/3/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var launge: UILabel!
    @IBOutlet weak var dataSyncAndNotification: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
