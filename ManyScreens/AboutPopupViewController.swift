//
//  AboutPopupViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 12.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit

class AboutPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
