//
//  MainCollectionView.swift
//  PhotoPartyUpload
//
//  Created by iT Gurus Software on 30/08/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PartyImageModelList.shared.photoPartyModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.libraryCellIdentifier, for: indexPath) as? LibraryCollectionViewCell
        if let cell = cell {
            cell.updateCell(imageDto: PartyImageModelList.shared.photoPartyModelList[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height/3)
    }
    
}
