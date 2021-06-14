//
//  WelcomeVC.swift
//  Eventor
//
//  Created by Saleh on 19/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIApplication.shared.statusBarView?.backgroundColor = hexStringToUIColor("#fe5427")
    }


}
