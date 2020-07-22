//
//  UserList.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class UserList : NSObject {
    
    let m_id : Int?
    let m_userName : String?
    let m_avatarURL :  String?
    let m_type :  String?
    let m_profileURL :  String?

    
    init(p_id: Int ,p_userName: String, m_avatarURL: String, p_type: String, p_profileURL: String) {
        
        self.m_id = p_id
        self.m_userName = p_userName
        self.m_avatarURL = m_avatarURL
        self.m_type = p_type
        self.m_profileURL = p_profileURL

        
    }
    
    
    
}
