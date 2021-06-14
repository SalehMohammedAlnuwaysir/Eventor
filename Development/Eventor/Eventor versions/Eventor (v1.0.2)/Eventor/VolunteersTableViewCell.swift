//
//  VolunteersTableViewCell.swift
//  Eventor
//
//  Created by Saleh on 19/07/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class VolunteerTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var volunteerName: UILabel!
    
    @IBOutlet weak var acceptBtn: RoundedBtn!
    @IBOutlet weak var rejectBtn: RoundedBtn!
    @IBOutlet weak var rateBtn: RoundedBtn!
    
    var VolID: String!
    
    var cellDelegate: TableViewNew?
    var index: IndexPath?
    var whichTableView = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (whichTableView == 0) {
            acceptBtn.isHidden = false
            rejectBtn.isHidden = false
            rateBtn.isHidden = true

        } else if (whichTableView == 1) {
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            rateBtn.isHidden = false
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

protocol TableViewNew {
    func acceptVolunteer(index: Int)
    func rejectVolunteer(index: Int)
    func rateVolunteer(index: Int)
}
