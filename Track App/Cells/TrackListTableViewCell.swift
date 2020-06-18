//
//  TrackListTableViewCell.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit

class TrackListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artworkUrlImgView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    
    @IBOutlet weak var trackPricelabel: UILabel!
    @IBOutlet weak var favoriteImgView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
