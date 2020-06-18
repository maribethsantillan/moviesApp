//
//  APIService.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case POST
    case GET
    case DELETE
    case PUT
    case PATCH
    
}

enum WithHeader {
    case YES
    case NO
    
    var bool: Bool {
        switch self {
        case .YES:
            return true
        default:
            return false
        }
    }
}

enum WithHttpBody {
    case YES
    case NO
    
    var bool: Bool {
        switch self {
        case .YES:
            return true
        default:
            return false
        }
    }
}


class APIService : NSObject {
    
    //******************  NO HEADER OR TOKEN  ********************//
    func makeRequest(urlString: String,
                     method: RequestMethod,
                     isWithHttpBody : WithHttpBody,
                     parameters: Dictionary<String, String>,
                     completion: @escaping (_ data : Data , _ response: Int?) -> ()){
        
        var url =  NSURL(string: urlString)!
        var urlRequest = NSMutableURLRequest(url: url as URL)
        
        
        var jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if(isWithHttpBody == .YES){
            urlRequest.httpBody = jsonData
        } else {
            
        }
        
        
        
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, err) in
            guard let data = data else {
                return
            }
            
            
            
            
            do {
                
                let httpStatus = response as? HTTPURLResponse
                
                //                print("httpStatus=", httpStatus)
                
                completion (data ,httpStatus?.statusCode)
                
            } catch {
                print(error.localizedDescription)
                
            }
        
        }.resume()
        
        
    }
    
    
    
    
}
