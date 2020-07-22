//
//  TrackDetailsVC.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserProfileDetailsVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var detailsUIView: UIView!
    @IBOutlet weak var notesTVConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    let service = APIService ()
    let coreDataService = CoreDataService ()
    
    
    var userIDContent : Int! = 0
    var userNameContent : String! = ""
    var avatarUrlContent : String! = ""
    
    var userProfileURL : String! = ""
    
    
    var favoriteArray: [AnyObject?] = []
    
    var defaults = UserDefaults.standard
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            
            var frame = self.notesTextView.frame
            frame.size.height = self.notesTextView.contentSize.height
            self.notesTextView.frame = frame
            self.notesTVConstraints.constant = self.notesTextView.contentSize.height
            self.notesTextView.invalidateIntrinsicContentSize()
            
            
        }
        
        favoriteBtn.roundedButton()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
        
        self.title = userNameContent
        
        notesTextView.delegate = self;
        
         self.followerLabel.text = ""
        self.followingLabel.text = ""
        
        detailsUIView.backgroundColor = UIColor.white
        detailsUIView.layer.borderColor = UIColor.black.cgColor
        detailsUIView.layer.borderWidth = 2
        detailsUIView.layer.cornerRadius = 3
        detailsUIView.clipsToBounds = true
        
        
        showDetailsUI ()
        
        httpGetProfileDetails (p_profileUrl: userProfileURL)
        
        
    }
    
    
    func showDetailsUI (){
        
        if(avatarUrlContent!.isEmpty){
            avatarImgView.image = nil
            
        } else {
            do {
                let url = URL(string: avatarUrlContent! )
                let data = try Data(contentsOf: url!)
                avatarImgView.image  = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        
        notesTextView.layer.borderColor = UIColor.black.cgColor
        notesTextView.layer.borderWidth = 2;
        notesTextView.layer.cornerRadius = 5.0;
        notesTextView.clipsToBounds = true
        
        
        if let notesDict = defaults.array(forKey: "myNotes") as? [[String: Any]] {
            
            let filteredData = notesDict.filter{
                let id = $0["id"] as! Int
                
                return id == userIDContent
            }
//            print("filteredData ", filteredData)
            
            
            for item in filteredData {
                print(item["user_name"]  as! String)
                print(item["id"] as! Int)
                print(item["notes"]   as! String)
                
                notesTextView.text = (item["notes"]   as! String)
                
            }
            
        }
        
    }
    
    
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        
        var favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        var myNotesArray = defaults.array(forKey: "myNotes") as? [[String: Any]] ??  [[String: Any]] ()
        
        
        favoriteArray.append(userIDContent)
        
        defaults.set(favoriteArray, forKey: "favoriteArray")
        
        let dictionary = [
            "id": userIDContent!,
            "user_name": userNameContent!,
            "notes": notesTextView.text!
            ] as [String : Any]
        
        myNotesArray.append(dictionary)
        defaults.set(myNotesArray, forKey: "myNotes")
 
        defaults.synchronize()
        
        
        let alertController = UIAlertController(title: "Notes Added!", message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            DataManager.shared.userListVC.tableView.reloadData()
            
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
        
    }
    
    
    
    
    func httpGetProfileDetails (p_profileUrl: String?) {
        
        let emptyParams = [String: String]()
        
        service.makeRequest(urlString: p_profileUrl! , method: .GET, isWithHttpBody: .NO, parameters: emptyParams) { (data, resultCode) in
            
            let responseBody = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! Dictionary<String, Any>
            
            
            if resultCode == 200 {
                
                if data.count != 0 {
                    
                    print("responseBody ", responseBody)
                    
                    let followers = responseBody["followers"] as? Int
                    let following = responseBody["following"] as? Int
                    let nameStr = responseBody["name"] as? String
                    let companyStr = responseBody["company"] as? String ?? ""
                    let blogStr = responseBody["blog"] as? String ?? ""
                    
                    
                    let followersStr = "\(String(describing: followers!))"
                    let followingsStr = "\(String(describing: following!))"
                    
                    
                    DispatchQueue.main.sync {
                        
                        self.followerLabel.text = "Followers : " + followersStr
                        self.followingLabel.text = "Following : " + followingsStr
                        
                        self.nameLabel.text = "Name : " + nameStr!
                        self.companyLabel.text = "Company : " + companyStr
                        self.blogLabel.text = "Blog : " + blogStr
                        
                        
                        
                    }
                    
                }
                
            }
        }
        
    }
    
}

