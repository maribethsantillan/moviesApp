//
//  TrackListVC.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class TrackListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let service = APIService ()
    var trackArrayData = Array<TrackList>()
    
    var defaults = UserDefaults.standard
    var favoriteArray = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        DataManager.shared.trackListVC = self

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView() //hide empty lines/separator
        
        favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
            
        htpGetTracks ()
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trackArrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let trackCell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackListTableViewCell

        let track = self.trackArrayData[indexPath.row]
        
        trackCell.trackNameLabel.text = track.m_trackName
        trackCell.genreNameLabel.text =  track.m_trackGenre!
        
        let trackURL = track.m_trackUrl
        
        if(trackURL!.isEmpty){
            trackCell.artworkUrlImgView.image = nil
            
        } else {
            do {
                let url = URL(string: trackURL! )
                let data = try Data(contentsOf: url!)
                trackCell.artworkUrlImgView.image  = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        
        let amountStr : String = String(describing: formatNumber(track.m_trackPrice!) ?? "0")
        trackCell.trackPricelabel.text = track.m_currency! + " " +  amountStr
        
        favoriteArray = defaults.array(forKey: "favoriteArray")  as? [Int] ?? [Int]()
        
        if(favoriteArray.contains(track.m_trackID!)) {
            trackCell.favoriteImgView.isHidden = false
            
        } else {
            trackCell.favoriteImgView.isHidden = true
            
        }
        
        return trackCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let billing = self.trackArrayData[indexPath.row]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsController = storyboard.instantiateViewController(withIdentifier: "TrackDetailsVC") as! TrackDetailsVC
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: detailsController)
        
        detailsController.trackIDContent = billing.m_trackID
        detailsController.trackNameContent = billing.m_trackName
        detailsController.trackPhotoUrlContent = billing.m_trackUrl
        detailsController.trackDescriptionContent = billing.m_description
        
        self.present(navBarOnModal, animated: true, completion: nil)
        
    }
    
    
    
    
    func htpGetTracks () {
        
        let emptyParams = [String: String]()
        
        service.makeRequest(urlString: "https://itunes.apple.com/search?term=star&country=au&media=movie" , method: .GET, isWithHttpBody: .NO, parameters: emptyParams) { (data, resultCode) in
            
                    
            
            if resultCode == 200 {
                let responseBody = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! Dictionary<String, Any>
                
                if data.count != 0 {
                    
                    let trackresults = responseBody["results"] as!  [[String:AnyObject]]
                    
                    //                        print ("results is" , trackresults)
                    
                    for tracks in trackresults {
                        
                        let trackId = tracks["trackId"] as! Int
                        let artworkUrl100 = tracks["artworkUrl100"] as! String
                        let trackName = tracks["trackName"] as! String
                        let trackGenre = tracks["primaryGenreName"] as! String
                        let trackPrice = tracks["trackPrice"] as! Double
                        let currency = tracks["currency"] as! String
                        let longDescription = tracks["longDescription"] as! String
                        
                        
                        DispatchQueue.main.sync {
                            
                            self.trackArrayData.append(TrackList(p_trackID: trackId, p_trackName: trackName, p_trackUrl: artworkUrl100, p_trackGenre: trackGenre, p_trackPrice: trackPrice, p_currency: currency, p_description: longDescription ))
                            
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        
    }
    
}



