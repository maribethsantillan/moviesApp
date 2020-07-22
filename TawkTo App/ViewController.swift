//
//  ViewController.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class ViewController: UIViewController {
    
    let service = APIService ()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        htpGetTracks ()
    }

    
    func htpGetTracks () {
        
        let emptyParams = [String: String]()

        service.makeRequest(urlString: "https://itunes.apple.com/search?term=star&country=au&media=movie" , method: .GET, isWithHttpBody: .NO, parameters: emptyParams) { (data, resultCode) in
            
            
            print("resultCode ", resultCode)
            
            
            if resultCode == 200 {
                    let responseBody = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! Dictionary<String, Any>
                    
                    print ("responseBody is" , responseBody)
                    if data.count != 0 {
                        
                        let results = responseBody["results"] as! NSArray

                        
                        
                    
                        
                        
                    }
                }
            
            
//            if resultCode == 200 {
//
//                 if data.count != 0 {
//                let responseBody = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [AnyObject]
//                print("responseBody ", responseBody)
//
////                    let results = responseBody?["results"] as? String
//
//
//                    for trackList in responseBody! {
//
//                        let results = trackList["results"] as! String
//
//
//                    }
//
//
//
//                }
//            }
            
        }
            
    }

}

