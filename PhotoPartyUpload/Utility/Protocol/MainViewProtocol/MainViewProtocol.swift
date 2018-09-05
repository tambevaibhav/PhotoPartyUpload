//
//  MainViewProtocol.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 11/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit

enum ConnectionStatus
{
    case off
    case on
    case active
    case searching
}

enum ViewMode {
    case slide
    case library
}

protocol MainViewProtocol
{
    
    init(connectionStatus : ConnectionStatus , viewMode: ViewMode)
    var viewMode : ViewMode {get set}
    var connectionStatus : ConnectionStatus {get set}
    var statusDidChange: ((MainViewProtocol) -> ())? { get set }
    var showSearchAlert: ((MainViewProtocol) -> ())? { get set }
    var showChoiceAlert: ((MainViewProtocol) -> ())? { get set }
    var reloadData: ((MainViewProtocol) -> ())? { get set }
    var showNoHelperFoundAlert: ((MainViewProtocol) -> ())? { get set }
    var connectionImageArray : [UIImage] {get set}
    func startUpThings()
    func startDownloadManager()
}
