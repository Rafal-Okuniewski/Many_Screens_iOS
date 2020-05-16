//
//  AboutPopupViewController.swift
//  ManyScreens
//
//  Created by Rafal_O on 12.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit

class AboutPopupViewController: UIViewController {

    @IBOutlet weak var sliderOpacity: UISlider!
    @IBAction func sliderOpacity(_ sender: UISlider) {
        let appDefaults = UserDefaults.standard
        appDefaults.setValue(sliderOpacity.value, forKey: "app_bg_dialog_opacity")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(self.sliderOpacity.value))
        appDefaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: [String:Any]())
        appSettings()
    }
    
    private func appSettings(){
        let appDefaults = UserDefaults.standard
        let appBgOpacity = appDefaults.float(forKey: "app_bg_dialog_opacity")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(appBgOpacity))
        self.sliderOpacity.value = appDefaults.float(forKey: "app_bg_dialog_opacity")
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
