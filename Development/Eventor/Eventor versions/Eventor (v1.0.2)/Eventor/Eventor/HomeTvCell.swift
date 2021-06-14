//
//  HomeTvCell.swift
//  Eventor
//
//  Created by Saleh on 04/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class HomeTvCell: UITableViewCell {

    
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var AttendenceType: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var dayMonthLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var EventManagerName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
