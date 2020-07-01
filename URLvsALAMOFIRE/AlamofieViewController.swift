//
//  AlamofieViewController.swift
//  URLvsALAMOFIRE
//
//  Created by Магомед Абдуразаков on 28/09/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit
import Alamofire


class AlamofieViewController: UIViewController {
    
    
    //MARK: Public properties
    
    var models = [Model]()
    let url = "https://restcountries.eu/rest/v2/all"
    let site = URL(string: "https://restcountries.eu/rest/v2/all")
    
    //MARK: Overriden method
    
    override func viewDidLoad() {
        super.viewDidLoad()
                alamofire()
                jsonDecoderr()
        postRequest()
        

    }
    
    
    //MARK: Public methods
    
    func alamofire() {
        request(url).validate().responseJSON {data in
            switch data.result {
            case .success(let value):
                var models: [Model] = []
                guard   let dict = value as? [[String:Any]] else {return}
                for dictObject in dict {
                    guard   let name = dictObject["name"] as? String else {return}
                    guard let capital = dictObject["capital"] as? String else {return}
                    let model = Model(name: name, capital: capital)
                    models.append(model)
                }
                print(models)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func jsonDecoderr() {
        URLSession.shared.dataTask(with: site!) {data, response, error in
            guard let data = data  else {return}
            let decoder = JSONDecoder()
            guard let value = try? decoder.decode([Model].self, from: data) else {print("ne katit")
                return}
            for model in value {
                self.models.append(model)
            }
            print(self.models.count)
            print(self.models[1].name)
            
        }.resume()
        
        
    }
    
    func postRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return }
        let parametres = ["ss" : "dd", "dd" : "dd"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametres, options: []) else {return}
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, resp,dd) in
            
            if let response = resp {
                print(response)
            }
            
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch{
                print("Error")
            }
        }.resume()
        
        
        
    }
    
    

    
}

