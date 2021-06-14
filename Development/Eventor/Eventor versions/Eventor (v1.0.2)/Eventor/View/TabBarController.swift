//
//  TabBarController.swift
//  Eventor
//
//  Created by Saleh on 02/08/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if currnetUser.uType == userGeneral.getEMStrFormat(){
            self.tabBar.items![0].image = UIImage(named: "MyEvents")
            self.tabBar.items![0].selectedImage = UIImage(named: "MyEvents")
            self.tabBar.items![0].title = "My events"
        }
    }
}


