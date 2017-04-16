//
//  RailTableViewCell.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 4/16/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit

class RailTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib.init(nibName: String(describing: PosterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PosterCollectionViewCell.self))
    }
}
