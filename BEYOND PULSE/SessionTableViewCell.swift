//
//  SessionTableViewCell.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/6/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imagePlayer: UIImageView!
    @IBOutlet weak var positionPlayer: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var connectionImage: UIImageView!
    @IBOutlet weak var connectionPlayer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var sessionConnectionView: UIView!
    @IBOutlet weak var heartRateLabel: UILabel!

}
