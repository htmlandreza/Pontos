//
//  TimerTrackerViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class TimerTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userDetail: [ClockifyTimeEntries] = []
    var holidays: [BrazilianHoliday] = []
    var user: ClockifyUser!
    var times: ClockifyTimeEntries!
    
    // MARK: componentes da tela
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var timesTableView: UITableView!
    
    // MARK: variáveis que recebem valor da tela UserDatailViewController
    public var startDateInfoValue: String? = nil // tratado
    public var stopDateInfoValue: String? = nil
    public var emailValidUser: String? = nil
    public var keyValidUser: String? = nil
    public var nameValidUser: String? = nil
    public var idValidUser: String? = nil
    public var startValue: String? = nil // sem ser tratado
    public var stopValue: String? = nil
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        //label.textColor = UIColor(ciColor: .blue)
        return label
    }()
    
    // carga inicial
    override func viewDidLoad() {
        super.viewDidLoad()
        // carrega dados
        datesLabel.text = ("\(startDateInfoValue!) a \(stopDateInfoValue!)")
        nameLabel.text = nameValidUser!
        
        
        label.text = "Carregando pontos registrados..."
        
        loadTimes()
        loadHolidays()
    }
    
    // FIXME: Implementar lista de feriados
    func loadHolidays(){
        let fileURL = Bundle.main.url(forResource: "brazilianHolidays.json", withExtension: nil)!
        let jsonData = try! Data(contentsOf: fileURL)
        do {
            holidays = try JSONDecoder().decode([BrazilianHoliday].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: requisição - correspondente ao ClockifyTimeEntries
    func loadTimes(){
        print(emailValidUser!, keyValidUser!)
        
        let company = "5ab54394b079877ff6187947" // id da iBlue
        let headers = [
            "x-api-key": "\(keyValidUser!)", // usuário identificado APIKey
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
        ]
        //print(headers)
        
        // tratar os parâmetros de data - recebido da tela UserDetail
        let parameters = [
            "start": "\(startValue!)T00:00:00.000Z",
            "end": "\(stopValue!)T23:59:59.999Z"
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        // montando requisição
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.clockify.me/api/workspaces/\(company)/timeEntries/user/\(idValidUser!)/entriesInRange")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
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
                        print("Status Code da UsersTableViewController = \(httpStatus.statusCode)")
                        print("Requisição inicial com o dados locais. /nE-mail: \(self.emailValidUser) // Key: \(self.keyValidUser)")
                        do {
                            if let data = data{
                                self.userDetail = try! JSONDecoder().decode([ClockifyTimeEntries].self, from: data)
                                print (self.userDetail)
                                DispatchQueue.main.async {
                                    self.timesTableView.reloadData()
                                    let total = self.userDetail.count
                                    let dias = total / 2
                                    let horas = dias * 8
                                    
                                    self.daysLabel.text = String(dias) + " dias registrados"
                                    self.hoursLabel.text = String(horas) + " horas obrigatórias"
                                    
                                }
                            }
                        } catch let parseError as NSError {
                            print("Error with Json: \(parseError)")
                        }
                    } else {
                        // se status code != 200
                        print("Status Code do TimerTrackerViewController = \(httpStatus.statusCode)")
                        // TODO: incuir alerta
                        //self.homeAlert(title: "API Key inválida", message: "Identifique-se com e-mail e API Key válida.")
                    }
                }
            }
        })
        dataTask.resume()
    } // fecha loadTimes()
    
    // MARK: obrigatório - número de linhas por sessão
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = userDetail.count == 0 ? label : nil
        return userDetail.count
    }
    
    // MARK: obrigatório - alimenta a tabela
    // método chamado sempre quando for apresentar uma tabela, preparando
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tratando como uma UsersTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimerTrackerTableViewCell
        
        let user = userDetail[indexPath.row] // recuperando dados por usuário
        cell.prepare(with: user) // puxando do UsersTableViewCell
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {return true}
    
}
