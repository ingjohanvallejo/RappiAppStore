//
//  Services.swift
//  Rappi
//
//  Created by Johan Vallejo on 17/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Services {
    
    let url = "https://itunes.apple.com/us/rss/topfreeapplications/limit=50/json"

    /**
     Consulta al WS para traer la información de las Apps
     
     - parameters:
     - completionHandler: Diccionario con las diferentes Apps
     */
    func getAppInformation(completionHandler: @escaping ([[String : String]]?) -> Void) {

        if let urlService = URL(string: self.url) {
            Alamofire.request(urlService, method: .get).validate().responseJSON() { (response) in
                switch response.result {
                case .failure(let error):
                    print(error)
                    completionHandler(nil)
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let entries = json["feed"]["entry"].arrayValue
                        var result = [[String : String]]()
                        
                        for entry in entries {
                            var app = [String : String]()
                            app["id"] = entry["id"]["attributes"]["im:id"].stringValue
                            app["name"] = entry["im:name"]["label"].stringValue
                            app["price"] = entry["im:price"]["attributes"]["amount"].stringValue
                            app["summary"] = entry["summary"]["label"].stringValue
                            app["image"] = entry["im:image"][0]["label"].stringValue.replacingOccurrences(of: "53x53", with: "500x500")
                            app["artist"] = entry["im:artist"]["label"].stringValue
                            app["categoryId"] = entry["category"]["attributes"]["im:id"].stringValue
                            result.append(app)
                        }
                        completionHandler(result)
                        
                    }
                }
            }
        }
    }

    func getCategories(completionHandler: @escaping ([[String:String]]?) -> Void) {

        if let urlService = URL(string: self.url) {
            Alamofire.request(urlService, method: .get).validate().responseJSON() { response in
                switch response.result {
                case .failure(let error):
                    print(error)
                    completionHandler(nil)
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let entries = json["feed"]["entry"].arrayValue
                        var result = [[String:String]]()
                        var categoriesIds = [String]()

                        for entry in entries {
                            let id = entry["category"]["attributes"]["im:id"].stringValue

                            if !categoriesIds.contains(id) {
                                var resultCategory = [String:String]()
                                resultCategory["id"] = id
                                resultCategory["name"] = entry["category"]["attributes"]["label"].stringValue
                                categoriesIds.append(id)
                                result.append(resultCategory)
                            }
                        }
                        completionHandler(result)
                    }
                }
            }
        }
    }
}
