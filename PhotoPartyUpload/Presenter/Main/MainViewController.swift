 //
//  MainViewController.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 09/02/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumTitleImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var thumbnailBackView: UIView!
    @IBOutlet weak var brandingImageView: UIImageView!
    @IBOutlet weak var connectionImageView: UIImageView!
    
   // MARK: - View Model
    
    var viewModel : MainViewProtocol? {
        didSet{
            self.viewModel!.statusDidChange = {[unowned self] viewModel in
                OperationQueue.main.addOperation {
                    self.updateStatus()
                }
            }
            
            self.viewModel!.showSearchAlert = {[unowned self] viewModel in
                Utils.sharedInstance.showSearchAlert(topController: self,title: Constant.SearchAlert.title, messsage: Constant.SearchAlert.message, cancelButtonTitle: Constant.SearchAlert.buttonTitle)
            }
            
            self.viewModel!.showNoHelperFoundAlert = {[unowned self] viewModel in
                Utils.sharedInstance.showSearchAlert(topController: self,title: nil, messsage: Constant.NoHelperFoundAlert.message, cancelButtonTitle: Constant.NoHelperFoundAlert.buttonTitle)
            }
            
            self.viewModel?.showChoiceAlert = { [unowned self] viewModel in
                DispatchQueue.main.async
                {
                    Utils.sharedInstance.showAdminChoice(helperName: HelperListModel.sharedList.helperList[0].name, topController: self, callBack: {
                        result in
                        if result == 1
                        {
                            UserDefaults.standard.set(HelperListModel.sharedList.helperList[0].url, forKey: "helperUrl")
                            self.viewModel?.connectionStatus = .active
                        }
                        
                    })
                }
            }
        }
    }
    
 
  // MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewModel = MainViewModel(connectionStatus: .off)
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        self.viewModel?.startUpThings()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI()
    {
       if UserSettings.sharedInstance.getUserSettings()?.isAlbumMode == true
       {
        albumView.isHidden = false
        albumTitleLabel.isHidden = false
        albumTitleImageView.isHidden = false
       }
        else
       {
        albumView.isHidden = true
        albumTitleLabel.isHidden = true
        albumTitleImageView.isHidden = true
        }
    }
    
   // MARK: Other Methods
    func updateStatus()
    {
        self.connectionImageView.stopAnimating()
        
        switch self.viewModel!.connectionStatus
        {
        case .on:
            self.connectionImageView.image = UIImage(named: "Connection_on")
        case .off:
            self.connectionImageView.image = UIImage(named: "Connection_off")
        case .active:
            self.connectionImageView.image = UIImage(named: "Connection_active")
        case .searching:
            self.connectionImageView.animationImages = self.viewModel!.connectionImageArray
            self.connectionImageView.animationDuration = 1.0
            self.connectionImageView.startAnimating()
        }
    }

       // MARK: Button Actions
    @IBAction func viewModeButtonAction(_ sender: Any)
    {
        
    }
   

}
