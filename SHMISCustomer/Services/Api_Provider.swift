//
//  Api_Provider.swift
//  BansalNews
//
//  Created by admin on 30/09/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

 @objc protocol DashBoardConnectionDeligate: NSObjectProtocol {
    func didFinishDashBoardConnection_Dictionary(_ responceData: NSMutableDictionary)
    func didFinishDashBoardConnection_Array(_ responceData: NSMutableArray)
    func didFinishDashBoardConnection_Logout(_ responceData: NSMutableArray)
}

var baseUrl = "http://202.88.244.166:3412/hmis_msm/web/app.php/api/v1/"

class Api_Provider: Operation{
    
    var clientID = "6172b24a9b0a4a62544fe7c1_54flor6u5e4os0gkk0swko8cgogsgwco4840ccws48s084owko"
    var clientSecret = "5h1pq0oajk00ws0w4wsgw4ss40cw8scw444sks88c04goksc4o"
    var window: UIWindow?

    var fetched_data = [[String: Any]]()
    weak var delegate: DashBoardConnectionDeligate?
    
    func fetchPostapi(api: NSString, parameters: Dictionary<String, Any>, isauth: Bool, method: String)  {
        
    
        
        let url = URL(string: "\(baseUrl)\(api)")!
         var request = URLRequest(url: url)
         
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.httpMethod = "POST"
        
        
        var  jsonData = NSData()
        
            // var dataString2 :String = ""
             do {
                 jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) as NSData
                 // you can now cast it with the right type
             } catch {
                 print(error.localizedDescription)
             }
            
            request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
            request.httpBody = jsonData as Data
            
        
          
        if isauth {
            let token = UserDefaults.standard.string(forKey: "accessToken")
            print("token: \(token)")
            request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Dictionary(_:)), with: ["status" : "error"], waitUntilDone: false)
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                if (response.statusCode == 401){
                    print("Refresh token...")
                    var parameters = Dictionary<String, Any>()
                    let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken")

                    let  authbaseurl = "http://202.88.244.166:3412/hmis_msm/web/app.php/"
                    
                    
                    parameters = ["refresh_token" : refreshToken!, "client_secret" : clientSecret, "client_id" : clientID, "grant_type" : "refresh_token"]
                    Api_Provider.callPost(url: URL(string: "\(authbaseurl)oauth/v2/token")!, params: parameters, finish: finishPost)
                }
                print("response = \(response)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("jsonObject: \(json)")
                if let arrayVersion = json as? NSArray {
                    (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Array(_:)), with: arrayVersion, waitUntilDone: false)
                }else if let dictionaryVersion = json as? NSDictionary {
                    // dictionaryVersion is guaranteed to be a non-`nil` NSDictionary
                    (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Dictionary(_:)), with: dictionaryVersion, waitUntilDone: false)
                }
                 
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()

    }
    
    
    func fetchapi(api: NSString, isauth: Bool) {
        
       
        let url = URL(string: "\(baseUrl)\(api)")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        if isauth {
            let token = UserDefaults.standard.string(forKey: "accessToken")
            request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Dictionary(_:)), with: ["status" : "error"], waitUntilDone: false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 401{
                        print("Refresh token...")
                        var parameters = Dictionary<String, Any>()
                        let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken")

                        let Authbaseurl = "http://202.88.244.166:3412/hmis_msm/web/app.php/"
                       
                        
                        parameters = ["refresh_token" : refreshToken!, "client_secret" : clientSecret, "client_id" : clientID, "grant_type" : "refresh_token"]
                        Api_Provider.callPost(url: URL(string: "\(Authbaseurl)oauth/v2/token")!, params: parameters, finish: finishPost)
                        
                    }else{
                        do {
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            print("jsonObject: \(json)")
                            if let arrayVersion = json as? NSArray {
                                (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Array(_:)), with: arrayVersion, waitUntilDone: false)
                            }else if let dictionaryVersion = json as? NSDictionary {
                                // dictionaryVersion is guaranteed to be a non-`nil` NSDictionary
                                (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Dictionary(_:)), with: dictionaryVersion, waitUntilDone: false)
                            }
                             
                        } catch {
                            print("JSON error: \(error.localizedDescription)")
                        }
                    }
            }
            
            

            
        }

        task.resume()
    
    }
    
    
    static func getPostString(parameters:[String:Any]) -> String
        {
            var data = [String]()
            for(key, value) in parameters
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }

    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let postString = self.getPostString(parameters: params)
            request.httpBody = postString.data(using: .utf8)

            var result:(message:String, data:Data?) = (message: "Fail", data: nil)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in

                if(error != nil)
                {
                    result.message = "Fail Error not null : \(error.debugDescription)"
                }
                else
                {
                    result.message = "Success"
                    result.data = data
                }
                
                print(result)

                finish(result)
            }
            task.resume()
        }
    
    func finishPost (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONSerialization.jsonObject(with: jsonData)
                print(parsedData)
                if let dictionaryVersion = parsedData as? NSDictionary {
                    if dictionaryVersion["error"] != nil {
                        if dictionaryVersion["error"] as! String == "invalid_request" || dictionaryVersion["error"] as! String == "invalid_grant"{
                            UserDefaults.standard.set(false, forKey: "islogin")
                            UserDefaults.standard.set("", forKey: "Username")
                            UserDefaults.standard.set("", forKey: "accessToken")
                            UserDefaults.standard.set("", forKey: "RefreshToken")
                            (self.delegate as? NSObject)?.performSelector(onMainThread: #selector(self.delegate?.didFinishDashBoardConnection_Logout(_:)), with: nil, waitUntilDone: false)
                            DispatchQueue.main.async {
                                
//                                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? Login {
//                                    if let navigator = self.window?.rootViewController?.navigationController {
//                                               navigator.pushViewController(viewController, animated: true)
//                                           }
//                                       }
                               }
                           
                                
                        }
                    }else{
                        if let dictionaryVersion = parsedData as? NSDictionary {
                           
                            var accesstoken = dictionaryVersion["access_token"] as! String
                            var refreshtoken = dictionaryVersion["refresh_token"] as! String
                            UserDefaults.standard.set(accesstoken, forKey: "accessToken")
                            UserDefaults.standard.set(refreshtoken, forKey: "RefreshToken")
                        }
                       
                      
                      
                    }
                   
                }
                
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    
    @objc func test1(_ x1: UIAlertController?) {
        x1?.dismiss(animated: true, completion: nil)
    }
    
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


