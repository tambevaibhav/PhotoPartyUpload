//
//  SettingsViewController.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 24/10/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var helperBackView: UIView!
    @IBOutlet weak var versionWebView: UIWebView!
    @IBOutlet weak var wifiInfoLabel: UILabel!
    @IBOutlet weak var activeEventNameLabel: UILabel!
    @IBOutlet weak var helperModeSementedControl: UISegmentedControl!
    @IBOutlet weak var helperNameTextField: UITextField!
    @IBOutlet weak var helperButton: UIButton!
    
    @IBOutlet weak var helperStateButton: UIButton!
    @IBOutlet weak var helperEventLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func helperButtonAction(_ sender: Any) {
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
