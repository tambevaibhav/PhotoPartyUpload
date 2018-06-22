//
//  MainViewProtocol.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 11/04/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation

enum ConnectionStatus
{
    case off
    case on
    case active
    case searching
}

protocol MainViewProtocol
{
    
    init(connectionStatus : ConnectionStatus) 
    var connectionStatus : ConnectionStatus {get set}
    var statusDidChange: ((MainViewProtocol) -> ())? { get set }
    var showSearchAlert: ((MainViewProtocol) -> ())? { get set }
    var showChoiceAlert: ((MainViewProtocol) -> ())? { get set }
    var showNoHelperFoundAlert: ((MainViewProtocol) -> ())? { get set }
    func startUpThings()
    
}
