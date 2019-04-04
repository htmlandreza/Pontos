//
//  TimerTrackerViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class TimerTrackerTableViewController: UITableViewController {
    
    var userDetail: [ClockifyTimeEntries] = []
    
    //var users: [ClockifyUser] = []
    var user: ClockifyUser!
    
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
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
    
    // alimenta a tabela
    // método chamado sempre quando for apresentar uma tabela, preparando
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tratando como uma UsersTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        
        let user = userDetail[indexPath.row] // recuperando dados por usuário
        //cell.prepare(with: user) // puxando do UsersTableViewCell
        
        return cell
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
