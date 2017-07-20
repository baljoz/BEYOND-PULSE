//
//  PlayerTableViewCell.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/14/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var connectionImage: UIImageView!
    @IBOutlet weak var playerConection: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var maxHR: UILabel!
    @IBOutlet weak var connectionView: UIView!
}
