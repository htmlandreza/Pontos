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
    var userDetail: [ClockifyTimeEntries] = []
    
    // dados armazenados localmente - para o header da requisição
    let emailUser = ClockifyUserHeader.getEmailAndxAPIKey.email!
    let keyUser = ClockifyUserHeader.getEmailAndxAPIKey.key!
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var stopDatePicker: UIDatePicker!
    //@IBOutlet weak var startTextField: UITextField!
    //@IBOutlet weak var stopTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusNow = user.status
        
        // carregar dados da outra tela, de acordo com a seleção
        nameLabel.text = user.name
        emailLabel.text = ("E-mail: " + user.email)
        statusLabel.text = ("Status: " + statusUser(status: statusNow))

        // chama a requisição correspondente ao ClockifyTimeEntries
        loadTimes()
    }

    // trata o resultado do Status
    func statusUser(status: String) -> String {
        // trata o resultado do user.status
        switch user.status {
        case "ACTIVE" : return "Ativo"
        case "PENDING_EMAIL_VERIFICATION": return "Verificação de e-mail pendente"
        default: return "Desativo"
        }
    }
    
    // carrega a requisição correspondente ao ClockifyTimeEntries
    public func loadTimes(){
        // usuário identificado != usuário selecionado
        if user.email != emailUser {
           // validEmail()
            homeAlert(title: "E-mail do usuário não corresponde", message: "O e-mail do usuário identificado não é correspondente ao e-mail do usuário selecionado. Só é permitido consultar o próprio usuário que foi identificado. Volte ao início e identifique-se.")
        }
        // usuário identificado == usuário selecionado
        else {
            let iBlueCode = "5ab54394b079877ff6187947"
            let headers = [
                "x-api-key": "\(keyUser)", // usuário identificado APIKey
                "Content-Type": "application/json",
                "cache-control": "no-cache",
                "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
            ]
            //print(headers)
            
            // tratar os parâmetros de data
            let parameters = [
                "start": "2019-02-01T00:00:00.000Z",
                "end": "2019-02-28T23:59:59.999Z"
                ] as [String : Any]
            
            let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            
            // montando requisição
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/\(iBlueCode)/timeEntries/user/\(user.id)/entriesInRange")! as URL,
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
                            //print("Errou")
                            self.homeAlert(title: "API Key inválida", message: "Identifique-se com e-mail e API Key válida.")
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    // alerta com volta para o início
    func homeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let Action = UIAlertAction(title: "Alterar identificação", style: .default, handler: { _ -> Void in
            // let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let home = self.storyboard?.instantiateViewController(withIdentifier: "UsersTableViewController") as! UsersTableViewController
            let nextViewController = home
            //modalAPIKey.modalPresentationStyle = .overCurrentContext
            self.present(nextViewController, animated: true, completion: nil)
        })
        alert.addAction(Action)
        self.present(alert, animated: true){}
    }
}

