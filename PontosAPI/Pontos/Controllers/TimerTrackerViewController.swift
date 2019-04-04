//
//  TimerTrackerViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class TimerTrackerViewController: UITableViewController {
    
    var userDetail: [ClockifyTimeEntries] = []
    
    //var users: [ClockifyUser] = []
    var user: ClockifyUser!
    
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // tablew view times
    @IBOutlet weak var datesTimeLabel: UILabel!
    @IBOutlet weak var descriptionTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var timesTableView: UITableView!
    
    
    
    public var startDateInfoValue: String? = nil // tratado
    public var stopDateInfoValue: String? = nil
    public var emailValidUser: String? = nil
    public var keyValidUser: String? = nil
    public var nameValidUser: String? = nil
    public var idValidUser: String? = nil
    public var startValue: String? = nil // sem ser tratado
    public var stopValue: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // carrega dados
        datesLabel.text = ("\(startDateInfoValue!) a \(stopDateInfoValue!)")
        nameLabel.text = nameValidUser!
        
        loadTimes()
    }
    
    func prepare(with user: ClockifyUser){
        // itens da cell
        //nameLabel.text = (user.name)
        //print(emailValidUser, keyValidUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTimes(){
        
        print(emailValidUser!, keyValidUser!)
       
        let company = "5ab54394b079877ff6187947"
        let headers = [
            "x-api-key": "\(keyValidUser!)", // usuário identificado APIKey
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
        ]
        //print(headers)
        
        // tratar os parâmetros de data
        let parameters = [
            "start": "\(startValue!)T00:00:00.000Z",
            "end": "\(stopValue!)T23:59:59.999Z"
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        // montando requisição
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/\(company)/timeEntries/user/\(idValidUser!)/entriesInRange")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        //print (request)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse.debugDescription)
                
                if let httpStatus = response as? HTTPURLResponse{
                    // retorno da requisição com todos os parâmetros tratados do usuário identificado
                    if httpStatus.statusCode == 200 {
                        do {
                            if let data = data{
                                self.userDetail = try! JSONDecoder().decode([ClockifyTimeEntries].self, from: data)
                                print (self.userDetail)
                            }
                        } catch let parseError as NSError {
                            print("Error with Json: \(parseError)")
                        }
                    } else {
                        print("Status Code do TimerTrackerViewController = \(httpStatus.statusCode)")
                        //self.homeAlert(title: "API Key inválida", message: "Identifique-se com e-mail e API Key válida.")
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    

}

