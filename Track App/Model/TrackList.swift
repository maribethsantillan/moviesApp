//
//  TrackList.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class TrackList : NSObject {
    
    let m_trackID : Int?
    let m_trackName : String?
    let m_trackUrl :  String?
    let m_trackGenre :  String?
    let m_trackPrice :  Double?
 
    let m_currency :  String?
    let m_description :  String?
    
    
    
    
    init(p_trackID: Int ,p_trackName: String, p_trackUrl: String, p_trackGenre: String, p_trackPrice: Double, p_currency: String, p_description: String) {
        
        self.m_trackID = p_trackID
        self.m_trackName = p_trackName
        self.m_trackUrl = p_trackUrl
        self.m_trackGenre = p_trackGenre
        self.m_trackPrice = p_trackPrice
        self.m_currency = p_currency
        self.m_description = p_description
        
    }
    
    
    
}

