//
//  UserListTableViewCell.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class UserListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarUrlImgView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var notesImgView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
}
