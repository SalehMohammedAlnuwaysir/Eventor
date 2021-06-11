//
//  UsersForAdminCell.swift
//  Eventor
//
//  Created by Saud Alkahtani on 03/08/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class UsersForAdminCell: UITableViewCell {
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var subLbl:UILabel!
    @IBOutlet weak var btn:UIButton!
    
    override func awakeFromNib() {
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
