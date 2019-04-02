//
//  UsersTableViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var users: [ClockifyUser] = []
    // var projects: [Projects]
    
    // filtro
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search
        /*
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        */
        
        //loadUsers()
        loadUsers()
    }
    
    // passar informações pra outra tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! UserDetailViewController // tela que vai apresentar
        let user = users[tableView.indexPathForSelectedRow!.row]
        viewController.user = user
        
    }
    
    public func loadUsers(){
        let headers = [
            "x-api-key": "XJzUp/FcmBU8oozz",
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/5ab54394b079877ff6187947/users/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,  timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
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
    }
    
    func filterList() { // should probably be called sort and not filter
        users.sort() { $0.name < $1.name } // sort the fruit by name
        self.tableView.reloadData(); // notify the table view the data has changed
    }
    
    /*
     // puxando do json local
    func loadUsers() {
        let fileURL = Bundle.main.url(forResource: "users.json", withExtension: nil)!
        let jsonData = try! Data(contentsOf: fileURL)
        do {
            users = try! JSONDecoder().decode([ClockifyUser].self, from: jsonData)
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*
     // quantidade de sessães da tableView
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    
    // número de linhas por sessão
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    // alimenta a tabela
    // método chamado sempre quando for apresentar uma tabela, preparando
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tratando como uma UsersTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        
        let user = users[indexPath.row] // recuperando dados por usuário
        cell.prepare(with: user) // puxando do UsersTableViewCell
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

/*
extension UsersTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        service()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        service(filtering: searchBar.text)
        tableView.reloadData()
    }
}
*/
