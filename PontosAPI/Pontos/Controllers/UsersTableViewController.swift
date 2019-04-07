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
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        //label.textColor = UIColor(ciColor: .blue)
        return label
    }()
    
    
    // TODO: filtro da tela principal
    // let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Carregando funcionários..."
        
        // chamando API
        loadUsers()
    }
    
    // passar informações pra outra tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! UserDetailViewController // tela que vai apresentar
        let user = users[tableView.indexPathForSelectedRow!.row]
        viewController.user = user
    }    
    
    // MARK: requisição
    public func loadUsers(){
        
        // FIXME: Dados armazenados localmente
        // dados armazenados localmente - para o header da requisição
        let emailUser = ClockifyUserHeader.getEmailAndxAPIKey.email
        let keyUser = ClockifyUserHeader.getEmailAndxAPIKey.key
        
        if keyUser == "" {
            self.modalAlert(title: "Usuário não identificado", message: "Identifique-se com e-mail e API Key válida.")
            DispatchQueue.main.async {
                self.filterList()
            }
        }
            // usuário identificado
        else {
            let company = "5ab54394b079877ff6187947"
            let headers = [
               // "x-api-key": "\(keyUser)", // usuário identificado APIKey
                "x-api-key": "XJzUp/FcmBU8oozz", // apikey do gilmar
                "Content-Type": "application/json",
                "cache-control": "no-cache",
                "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/\(company)/users/")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,  timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("Erro: \(error!)")
                } else {
                    if let httpStatus = response as? HTTPURLResponse{
                        if httpStatus.statusCode == 200 {
                            print("Status Code da UsersTableViewController = \(httpStatus.statusCode)")
                            print("Requisição inicial com o dados locais. \nE-mail: \(emailUser!) // Key: \(keyUser!)")
                            do {
                                if let data = data{
                                    self.users = try! JSONDecoder().decode([ClockifyUser].self, from: data)
                                    // recarrega e ordena
                                    DispatchQueue.main.async {
                                        self.filterList()
                                        //self.tableView.reloadData();
                                    }
                                }
                            }
                            catch let parseError as NSError {
                                print("Error with Json: \(parseError)")
                            }
                        }
                        // se status code != 200
                        else {
                            print("Status Code do UsersTableViewController = \(httpStatus.statusCode)")
                            self.modalAlert(title: "Usuário não identificado", message: "Identifique-se com e-mail e API Key válida.")
                        } // fecha else
                    } // fecha httpurlresponse
                }
            }) // fecha dataTask
            dataTask.resume()
        }
    } // fecha loadUsers()
    
    // TODO: filtro
    func filterList() {
        users.sort() { $0.name < $1.name } // Ordena por nome
        self.tableView.reloadData(); // recarrega
    }
    
    // MARK: alerta
    func modalAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let Action = UIAlertAction(title: "Identifique-se", style: .default, handler: nil  )
        alert.addAction(Action)
        self.present(alert, animated: true){}
    }

    // MARK: obrigatório - número de linhas por sessão
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = users.count == 0 ? label : nil
        return users.count
    }
    
    // MARK: obrigatório - alimenta a tabela
    // método chamado sempre quando for apresentar uma tabela, preparando
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tratando como uma UsersTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        
        let user = users[indexPath.row] // recuperando dados por usuário
        cell.prepare(with: user) // puxando do UsersTableViewCell
        
        return cell
    }
    
    
    
    // FIXME: verificar este botão
    @IBAction func validAPIKey(_ sender: UIButton) {
        //openModal()
        let modalAPIKey = storyboard?.instantiateViewController(withIdentifier: "ApiKeyViewController") as! ApiKeyViewController
        modalAPIKey.modalPresentationStyle = .overCurrentContext
        modalAPIKey.reference = self
        present(modalAPIKey, animated: true, completion: nil)
        self.tableView.reloadData();
    }
    
    //FIXME: Não está atualizando na mesma hora
    func changeUserAPI(email: String?, key: String?){
        
        ClockifyUserHeader.saveEmailAndxAPIKey(email!, key!)
        
        print("Recebido: " + email!, key!)
        
    }
//
//    // MARK: modal
//    func openModal(){
//        let modalAPIKey = storyboard?.instantiateViewController(withIdentifier: "ApiKeyViewController") as! ApiKeyViewController
//        modalAPIKey.modalPresentationStyle = .overCurrentContext
//        modalAPIKey.reference = self
//
//        present(modalAPIKey, animated: true, completion: nil)
//
//    }
} // fim da classe UsersTableViewController

extension UsersTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {return true}}

