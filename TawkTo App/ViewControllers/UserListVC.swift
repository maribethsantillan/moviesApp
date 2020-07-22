//
//  UserListVC.swift
//  TawkTo App
//
//  Created by Maribeth-Santillan on 7/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class UserListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataService = CoreDataService ()
    
    
    let service = APIService ()
    var defaults = UserDefaults.standard
    var favoriteArray = [Int]()
    var myNotes =  [[String: Any]] ()

    
    
    let cellSpacingHeight: CGFloat = 10
    
    let reachability = Reachability()
    
    var people: [NSManagedObject] = []
    
    var limit = 20
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: ReachabilityChangedNotification, object: reachability)
        
        do {
            
            try reachability!.startNotifier()
            
        } catch {
            print("Could not start notifier")
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GitUsers")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = ""
        
        self.hideKeyboardWhenTappedAround()
        
        
        DataManager.shared.userListVC = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        tableView.tableFooterView = UIView() //hide empty lines/separator
        
        favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        myNotes = defaults.array(forKey: "myNotes") as? [[String: Any]] ??  [[String: Any]] ()
    
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return people.count
        
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /* Set the spacing between sections */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let trackCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserListTableViewCell
   
        let person = people[indexPath.section]
        
        
        /* add border and color */
        trackCell.backgroundColor = UIColor.white
        trackCell.layer.borderColor = UIColor.black.cgColor
        trackCell.layer.borderWidth = 2
        trackCell.layer.cornerRadius = 3
        trackCell.clipsToBounds = true
        
        trackCell.userNameLabel?.text = person.value(forKeyPath: "userName") as? String
        
        let trackURL = person.value(forKeyPath: "avatarURL") as? String
        
        do {
            trackCell.avatarUrlImgView.loadImageUsingCache(withUrl: trackURL!)
            
        }
            
        catch{
            print(error)
        }
        
        trackCell.avatarUrlImgView.layer.cornerRadius = trackCell.avatarUrlImgView.frame.size.width / 2;
        trackCell.avatarUrlImgView.clipsToBounds = true
        
        trackCell.avatarContainerView.layer.cornerRadius =  trackCell.avatarContainerView.frame.size.width / 2;
        trackCell.avatarContainerView.clipsToBounds = true
        
        
        trackCell.detailsLabel.text =  person.value(forKeyPath: "details") as? String
        
        favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        myNotes = defaults.array(forKey: "myNotes") as? [[String: Any]] ??  [[String: Any]] ()

        
        let id = person.value(forKeyPath: "id") as? Int
      
        
        if(favoriteArray.contains(id!)) {
            trackCell.notesImgView.isHidden = false

        } else {
            trackCell.notesImgView.isHidden = true

        }

        
        /* Inverted bg colors here */
        if (indexPath.section % 4 == 0) {
            trackCell.avatarContainerView.backgroundColor =  UIColor.black
            
            trackCell.avatarContainerView.layer.borderWidth = 2
            trackCell.avatarContainerView.layer.borderColor = UIColor.white.cgColor
            
        }else{
            
            trackCell.avatarContainerView.backgroundColor =  UIColor.white
            
            trackCell.avatarContainerView.layer.borderWidth = 2
            trackCell.avatarContainerView.layer.borderColor = UIColor.black.cgColor
            
        }
        
        
        return trackCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let gitUser = people[indexPath.section]
        
        
        let vc: UserProfileDetailsVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileDetailsVC") as? UserProfileDetailsVC)!
        
        vc.userIDContent = gitUser.value(forKeyPath: "id") as? Int
        vc.userNameContent = gitUser.value(forKeyPath: "userName") as? String
        vc.avatarUrlContent = gitUser.value(forKeyPath: "avatarURL") as? String
        vc.userProfileURL = gitUser.value(forKeyPath: "profileURL") as? String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
    }
    
    
    func htpGetGitHubUserList () {
        
        let emptyParams = [String: String]()
        
        service.makeRequest(urlString: "https://api.github.com/users?since=0" , method: .GET, isWithHttpBody: .NO, parameters: emptyParams) { (data, resultCode) in
            
            
            
            if resultCode == 200 {
                
                
                if data.count != 0 {
                    
                    let responseBody = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [AnyObject]
                    print("responseBody ", responseBody)
                    
                    
                    for tracks in responseBody! {
                        
                        let id = tracks["id"] as! Int
                        let userName = tracks["login"] as! String
                        let avatarURL = tracks["avatar_url"] as! String
                        let type = tracks["type"] as! String
                        let profileURL = tracks["url"] as! String
                        
                        
                        
                        DispatchQueue.main.sync {
                          
                            self.saveUserToCoreData(p_id: id, p_name: userName, p_avatarURL: avatarURL, p_details: type, p_profileURL: profileURL, p_notes: "")
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    
    
    @objc func internetChanged(note: Notification){
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable{
            
            htpGetGitHubUserList ()
    
            
        } else {
            
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "Oops!", message:
                    "You don't have internet connection!", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    
    
    func saveUserToCoreData(p_id: Int? , p_name: String,  p_avatarURL: String,  p_details: String,   p_profileURL: String,   p_notes: String) {
        
        //core data
        let context = self.appDelegate.persistentContainer.viewContext
        
        
        let managedContext = self.appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GitUsers", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(p_id, forKeyPath: "id")
        person.setValue(p_name, forKeyPath: "userName")
        person.setValue(p_avatarURL, forKeyPath: "avatarURL")
        person.setValue(p_details, forKeyPath: "details")
        person.setValue(p_profileURL, forKeyPath: "profileURL")
        person.setValue(p_notes, forKeyPath: "notes")
        
        
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}



