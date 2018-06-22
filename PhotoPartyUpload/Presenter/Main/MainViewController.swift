 //
//  MainViewController.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 09/02/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumTitleImaView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var thumbnailBackView: UIView!
    @IBOutlet weak var brandingImageView: UIImageView!
    @IBOutlet weak var connectionImageView: UIImageView!
    
    
    

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
                self.viewModel?.connectionStatus = .active

                DispatchQueue.main.async {

                  Utils.sharedInstance.showAdminChoice(helperName: HelperListModel.sharedList.helperList[0].name, topController: self)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel(connectionStatus: .off)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.viewModel?.startUpThings()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateStatus()
    {
        self.connectionImageView.stopAnimating()
        
        switch self.viewModel!.connectionStatus  {
        case .on:
            self.connectionImageView.image = UIImage(named: "Connection_on")
        case .off:
            self.connectionImageView.image = UIImage(named: "Connection_off")
        case .active:
            self.connectionImageView.image = UIImage(named: "Connection_active")
        case .searching:
            var imageArray = [UIImage]()
            
            for i in 0...22
            {
                let imageName = String(format: "connection_search00%02d",i)
                let path = Bundle.main.path(forResource: imageName, ofType: "png")
                if let image = UIImage(named: path!)
                {
                    imageArray.append(image)
                }
            }
            
            self.connectionImageView.animationImages = imageArray
            self.connectionImageView.animationDuration = 1.0
            self.connectionImageView.startAnimating()
        }
    }

    
    @IBAction func viewModeButtonAction(_ sender: Any)
    {
    }
   

}
