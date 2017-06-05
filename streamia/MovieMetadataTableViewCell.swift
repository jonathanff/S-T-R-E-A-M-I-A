//
//  MovieTitleTableViewCell.swift
//  streamia
//
//  Created by Jonathan Fuentes Flores on 6/4/17.
//  Copyright © 2017 appollo. All rights reserved.
//

import UIKit

class MovieMetadataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        restartUI()
    }
    
    override func prepareForReuse() {
        restartUI()
    }
    
    func restartUI() {
        titleLabel.text = ""
        yearLabel.text = ""
        classificationLabel.text = ""
        lengthLabel.text = ""
        synopsisLabel.text = ""
    }
}
