//
//  UserDetailViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: ClockifyUser!
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var stopTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusNow = user.status
        
        // carregar a outra tela, de acordo com a seleção
        nameLabel.text = user.name
        emailLabel.text = ("E-mail: " + user.email)
        statusLabel.text = ("Status: " + statusUser(status: statusNow))
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func statusUser(status: String) -> String {
        switch user.status {
        case "ACTIVE" : return "Ativo"
        case "PENDING_EMAIL_VERIFICATION": return "Verificação de e-mail pendente"
        default: return "Desativo"
        }
    }
    
    //yyyy-MM-ddThh:mm:ssZ
    /*
    public func loadTimes(){
        let headers = [
            "x-api-key": "XJzUp/FcmBU8oozz",
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
        ]
        
        let parameters = [
            "start": "2019-02-01T00:00:00.000Z",
            "end": "2019-02-28T23:59:59.999Z"
            ] as [String : Any]
        
        //let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/5ab54394b079877ff6187947/timeEntries/user/5ac3e260b07987197abef231/entriesInRange")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                do {
                    if let data = data{
                        self.users = try! JSONDecoder().decode([ClockifyUser].self, from: data)
                        
                        /* // requisição
                         let allObjects = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                         
                         for object in allObjects! {
                         
                         let id = object["id"] as! String
                         let email = object["email"] as! String
                         let name = object["name"] as! String
                         let status = object["status"] as! String
                         
                         let user = ClockifyUser.init(id: id, email: email, name: name, status: status)
                         self.users.append(user)
                         
                         } */
                        
                        DispatchQueue.main.async {
                            // recarrega
                            self.filterList()
                            //self.tableView.reloadData()
                        }
                        
                        
                    }
                } catch let parseError as NSError {
                    print("Error with Json: \(parseError)")
                }
            }
        })
        dataTask.resume()
    } */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

