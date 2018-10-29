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
    
    @IBOutlet weak var viewModeButton: UIButton!
    @IBOutlet weak var albumTitleImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var thumbnailBackView: UIView!
    @IBOutlet weak var brandingImageView: UIImageView!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var pageSlider: UISlider!
    @IBOutlet weak var albumViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumTitleViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    var indexOfCellBeforeDragging = 0
    var pageCount = 0
    var currentPage = 0
    var tapRec : UITapGestureRecognizer?
    var isViewModeChange : Bool = true
   // MARK: - View Model
    
    var viewModel : MainViewProtocol? {
        didSet{
            
            self.viewModel?.reloadData = {[weak self] viewModel in
                do {
                  try  self?.updateUI(notification: nil)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
            
            self.viewModel!.statusDidChange = {[weak self] viewModel in
                OperationQueue.main.addOperation {
                    self?.updateStatus()
                }
            }
            
            self.viewModel!.showSearchAlert = {[weak self] viewModel in
                Utils.sharedInstance.showSearchAlert(topController: self,title: Constant.SearchAlert.title, messsage: Constant.SearchAlert.message, cancelButtonTitle: Constant.SearchAlert.buttonTitle)
            }
            
            self.viewModel!.showNoHelperFoundAlert = {[weak self] viewModel in
                Utils.sharedInstance.showSearchAlert(topController: self,title: nil, messsage: Constant.NoHelperFoundAlert.message, cancelButtonTitle: Constant.NoHelperFoundAlert.buttonTitle)
            }
            
            self.viewModel?.showChoiceAlert = { [weak self] viewModel in
                DispatchQueue.main.async
                {
                    Utils.sharedInstance.showAdminChoice(helperName: HelperListModel.sharedList.helperList[0].name, topController: self, callBack: {
                        result in
                        if result == 1 {
                            self?.viewModel?.startDownloadManager()
                        }
                        else if result == 2 {
                            self?.performSegue(withIdentifier: "settings", sender: self)
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
        self.viewModel = MainViewModel(connectionStatus: .off, viewMode : .slide)
        addNotifications()
        addLongPressGuesture()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        self.viewModel?.startUpThings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayoutItemSize()
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
        albumViewWidthConstraint.constant = 145
        albumTitleViewHeightConstraint.constant = 45
       }
        else
       {
        albumView.isHidden = true
        albumTitleLabel.isHidden = true
        albumTitleImageView.isHidden = true
        albumViewWidthConstraint.constant = 20
        albumTitleViewHeightConstraint.constant = 0
        }
        collectionViewLayout.minimumLineSpacing = 0
    }
    
    func addNotifications() {
        let notificationName = Notification.Name(Constant.NotificationIdentifier.downloadIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateUI), name: notificationName, object: nil)
    }
    
    
    @objc func updateUI(notification: NSNotification?) throws {
        DispatchQueue.main.async {
            if self.viewModel?.viewMode == .slide {
               self.pageCount = PartyImageModelList.shared.photoPartyModelList.count
                self.addTapGuesture()
            }
            else {
                let count  = (PartyImageModelList.shared.photoPartyModelList.count / 9)
                self.pageCount  = (PartyImageModelList.shared.photoPartyModelList.count % 9) > 0 ? count + 1 : count
                self.removeTapGuesture()
            }
           
            self.pageSlider.minimumValue = 0.0
            self.pageSlider.maximumValue = Float(self.pageCount - 1)
            //self.mainCollectionView.reloadData()
        
        if (PartyImageModelList.shared.photoPartyModelList.count == 1) || self.isViewModeChange == true {
            self.isViewModeChange = false
            self.mainCollectionView.reloadData()
        } else if (PartyImageModelList.shared.photoPartyModelList.count > 1)  {
            self.mainCollectionView.performBatchUpdates({
                let indexPath = IndexPath(row: PartyImageModelList.shared.photoPartyModelList.count - 1 , section: 0)
                self.mainCollectionView.insertItems(at: [indexPath])

            }, completion: nil)
        }
            self.slideToCurrentPage()
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
    @IBAction func viewModeButtonAction(_ sender: Any) {
        if let viewMode = self.viewModel?.viewMode {
        switch viewMode {
        case .library:
            viewModeButton.setImage(#imageLiteral(resourceName: "LibraryView"), for: .normal)
            self.viewModel?.viewMode = .slide
        case .slide:
            viewModeButton.setImage(#imageLiteral(resourceName: "SlideView"), for: .normal)
            self.viewModel?.viewMode = .library
            currentPage = (currentPage / 9)
            }
            isViewModeChange = true
        }
    }
    
    @IBAction func sliderValueChangeAction(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        currentPage = Int(slider.value)
        slideToCurrentPage()
    }
    
}
 
    // MARK: Guesture methods
 extension MainViewController {
    
    func addTapGuesture() {
            tapRec = UITapGestureRecognizer(target: self, action:  #selector(self.changeViewMode(sender:)))
            tapRec?.numberOfTapsRequired = 2
            tapRec?.cancelsTouchesInView = false
            mainCollectionView.addGestureRecognizer(tapRec!)

    }
    
    func addLongPressGuesture() {
        let longPressGuestutre = UILongPressGestureRecognizer(target: self, action: #selector(self.presentSettingsView(sender:)))
        //longPressGuestutre.minimumPressDuration = 1.0
        self.connectionImageView.addGestureRecognizer(longPressGuestutre)
    }
    
    @objc func changeViewMode(sender : UITapGestureRecognizer) {
        self.viewModeButtonAction(sender)
    }
    
    func removeTapGuesture() {
        if tapRec != nil {
            mainCollectionView.removeGestureRecognizer(tapRec!)
        }
    }
    
    @objc func presentSettingsView(sender : UILongPressGestureRecognizer) {
        performSegue(withIdentifier: "settings", sender: self)
    }
 }
