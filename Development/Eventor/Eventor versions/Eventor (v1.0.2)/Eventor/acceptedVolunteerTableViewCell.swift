//
//  acceptedVolunteerTableViewCell.swift
//  Eventor
//
//  Created by Saleh on 22/07/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class acceptedVolunteersTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var volunteerName: UILabel!
    
    var VolID: String!
    
    var cellDelegate: TableViewNew?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
    }
    @IBAction func rejectBtnPressed(_ sender: Any) {
    }
}

protocol TableViewNew {
    func acceptVolunteer(index: Int)
    func rejectVolunteer(index: Int)
}
