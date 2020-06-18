//
//  TrackDetailsVC.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class TrackDetailsVC: UIViewController {
    
    @IBOutlet weak var trackUrlImgView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var descTVConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    var trackIDContent : Int! = 0
    var trackNameContent : String! = ""
    var trackPhotoUrlContent : String! = ""
    var trackDescriptionContent : String! = ""
    
    var favoriteArray: [AnyObject?] = []
    
    var defaults = UserDefaults.standard
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            
            var frame = self.descriptionTextView.frame
            frame.size.height = self.descriptionTextView.contentSize.height
            self.descriptionTextView.frame = frame
            self.descTVConstraints.constant = self.descriptionTextView.contentSize.height
            self.descriptionTextView.invalidateIntrinsicContentSize()
            
            
        }
        
        favoriteBtn.roundedButton()

        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = trackNameContent
        
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
        
        showDetailsUI ()
        
        
    }
    
    @objc func donePressed(){
        
        DataManager.shared.trackListVC.tableView.reloadData()

        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
        /*SWIPING DOWN*/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.trackListVC.tableView.reloadData()

    }
    
    
    func showDetailsUI (){
        
        if(trackPhotoUrlContent!.isEmpty){
            trackUrlImgView.image = nil
            
        } else {
            do {
                let url = URL(string: trackPhotoUrlContent! )
                let data = try Data(contentsOf: url!)
                trackUrlImgView.image  = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        descriptionTextView.text = trackDescriptionContent
        
        
        let array = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        print("this is array ", array)
        
        if(array.contains(trackIDContent)) {
            favoriteBtn.setTitle("Remove to favorites", for: .normal)
            favoriteBtn.backgroundColor = UIColor.red
        }else {
            favoriteBtn.setTitle("Add to favorites", for: .normal)
            favoriteBtn.backgroundColor = hexStringToUIColor(hex: "32CD32")
        }
        
        
    }
    
    
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        
        var favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        
        
        
        if(favoriteArray.contains(trackIDContent)) {
            //Remove functionality
            
            if let index = favoriteArray.firstIndex(of: trackIDContent) {
                favoriteArray.remove(at: index)
                defaults.set(favoriteArray, forKey: "favoriteArray")
                defaults.synchronize()
                
            }
            
            favoriteBtn.setTitle("Add to favorites", for: .normal)
            favoriteBtn.backgroundColor = hexStringToUIColor(hex: "32CD32")
//            print("array removed!", favoriteArray)
            
        }else {
            //Add functionality
            
            favoriteArray.append(trackIDContent)
            
            defaults.set(favoriteArray, forKey: "favoriteArray")
            defaults.synchronize()
            
            favoriteBtn.setTitle("Remove to favorites", for: .normal)
            favoriteBtn.backgroundColor = UIColor.red
            
            
//            print("array added!", favoriteArray)
            
        }
        
        
    }
    
    
}

