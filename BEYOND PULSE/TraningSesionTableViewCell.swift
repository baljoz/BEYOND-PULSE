//
//  TraningSesionTableViewCell.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/20/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class TraningSesionTableViewCell: UITableViewCell {

    @IBOutlet weak var device: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var sessionConnectionView: UIView!
    @IBOutlet weak var connectionImage: UIImageView!

}
