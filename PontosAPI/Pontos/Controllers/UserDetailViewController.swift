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
    
    // FIXME: dados armazenados localmente
    // dados armazenados localmente - para o header da requisição
    let emailUser = ClockifyUserHeader.getEmailAndxAPIKey.email!
    let keyUser = ClockifyUserHeader.getEmailAndxAPIKey.key!
  
    // MARK: componentes do Usuários
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: componentes da View - consulta dos pontos por intervalo de datas
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var stopTextField: UITextField!
    @IBOutlet weak var relatorioLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var consultButton: UIButton!
    
    // MARK: datepicker
    let datePicker = UIDatePicker()
    
    var startDateValue: String? = nil
    var stopDateValue: String? = nil
    var startDateInfoValue: String? = nil
    var stopDateInfoValue: String? = nil
    var emailValidUser: String? = nil
    var keyValidUser: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusNow = user.status
        
        // carregar dados da outra tela, de acordo com a seleção
        nameLabel.text = user.name
        emailLabel.text = ("E-mail: " + user.email)
        statusLabel.text = ("Status: " + statusUser(status: statusNow))
        
        // DatePicker
        startShowDatePicker()
        stopShowDatePicker()
        
        // chama a requisição correspondente ao ClockifyTimeEntries
        validEmailSelected()
    }

    // MARK: trata o resultado da statusLabel
    func statusUser(status: String) -> String {
        // trata o resultado do user.status
        switch user.status {
        case "ACTIVE" : return "Ativo"
        case "PENDING_EMAIL_VERIFICATION": return "Verificação de e-mail pendente"
        default: return "Desativo"
        }
    }
    
    // botão Consultar
    @IBAction func generate(_ sender: UIButton) {
        // MARK: validando datas informadas pelo usuário
        // valida se os intervalos de data então preenchidos
        do {
            // se as datas foram preenchidas
            if startTextField.text != "" && stopTextField.text != "" {
                // Ambas as datas são as mesmas
                if startDateInfoValue?.compare(stopDateInfoValue!) == .orderedSame {
                    homeAlert(title: "Datas identicas", message: "É necessário preencher um intervalo de data maior. Por favor, tente novamente.")
                }
                
                // Primeira data é menor que a segunda data
                if startDateInfoValue?.compare(stopDateInfoValue!) == .orderedAscending {
                    validEmailSelected()
                }
                
                // A primeira data é maior que a segunda data
                if startDateInfoValue?.compare(stopDateInfoValue!) == .orderedDescending {
                    homeAlert(title: "Datas inválidas", message: "Não é possível consultar pois a primera data está maior que a segunda data. Por favor, tente novamente.")
                }
                
            }
            // se uma das datas estiver vazia
            else {
                 homeAlert(title: "Data(s) vazia(s)", message: "É necessário preencher os dois campos de datas. Por favor, tente novamente.")
            }
        } catch {
            print("Erro na coletas de data.")
        }
    }
    
    // MARK: prepare - passar informações pra outra tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? TimerTrackerViewController // tela que vai apresentar
        viewController?.startDateInfoValue = startDateInfoValue
        viewController?.stopDateInfoValue = stopDateInfoValue
        viewController?.emailValidUser = user.email
        viewController?.keyValidUser = keyUser
        viewController?.nameValidUser = user.name
        viewController?.startValue = startDateValue
        viewController?.stopValue = stopDateValue
        viewController?.idValidUser = user.id
    }
    
    // MARK: validação - verifica se o usuário identificado é o mesmo usuário consultado
    func validEmailSelected(){
        if user.email != emailUser {
            // validEmail()
            homeAlert(title: "E-mail do usuário não corresponde", message: "O e-mail do usuário identificado não é correspondente ao e-mail do usuário selecionado. Só é permitido consultar o próprio usuário que foi identificado. Volte ao início e identifique-se.")
            startTextField.isHidden = true
            stopTextField.isHidden = true
            relatorioLabel.text = "Relatório indisponível. Usuário não identificado."
            startLabel.isHidden = true
            endLabel.isHidden = true
            consultButton.isHidden = true
        } else {
            if startDateValue == nil || stopDateValue == nil  {
                startDateValue = "2019-03-01"
                stopDateValue = "2019-03-02"
                
                loadTimes(startValue: startDateValue!, stopValue: stopDateValue!)
            } else {
                print ("Preencheu \(startDateValue!)")
                //loadTimes(startValue: startDateValue!, stopValue: stopDateValue!)
            }
        }
    }
    
    // MARK: requisição - correspondente ao ClockifyTimeEntries
    public func loadTimes(startValue: String, stopValue: String){
            let company = "5ab54394b079877ff6187947" // id da iBlue
            let headers = [
                "x-api-key": "\(keyUser)", // usuário identificado APIKey
                "Content-Type": "application/json",
                "cache-control": "no-cache",
                "Postman-Token": "9ee3d028-97c2-4ca9-862e-46c31edfef0c"
            ]
            //print(headers)
            
            // tratar os parâmetros de data
            let parameters = [
                        //2019-03-01
                "start": "\(startValue)T00:00:00.000Z",
                "end": "\(stopValue)T23:59:59.999Z"
                ] as [String : Any]
            
            let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
            // url da requisição
            let url =  NSURL(string: "https://api.clockify.me/api/workspaces/\(company)/timeEntries/user/\(user.id)/entriesInRange")!
            // montando requisição
            let request = NSMutableURLRequest(url: url as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 20.0)
            //print (request)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("Erro: \(error!)")
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse.debugDescription)
                    
                    if let httpStatus = response as? HTTPURLResponse{
                        // retorno da requisição com todos os parâmetros tratados do usuário identificado
                        if httpStatus.statusCode == 200 {
                            print("Status Code da UsersTableViewController = \(httpStatus.statusCode)")
                            print("Requisição inicial com o dados locais. /nE-mail: \(self.emailUser) // Key: \(self.keyUser)")
                            do {
                                if let data = data{
                                    self.userDetail = try! JSONDecoder().decode([ClockifyTimeEntries].self, from: data)
                                    print (self.userDetail)
                                }
                            } catch let parseError as NSError {
                                print("Error with Json: \(parseError)")
                            }
                        }
                        // se status code != 200
                        else {
                            print("Status Code do UserDatail = \(httpStatus.statusCode)")
                            self.homeAlert(title: "API Key inválida", message: "Identifique-se com e-mail e API Key válida.")
                        }
                    }
                }
            })// fecha dataTask
        dataTask.resume()
    } // fecha loadTimes()
    
    
   
    
    // MARK: modifica do teclado para o datePicker - Start Text Field
    func startShowDatePicker(){
        // formate date
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        
        // ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(startDonedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(startCancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        startTextField.inputAccessoryView = toolbar
        startTextField.inputView = datePicker
        
    }

    // MARK: datepicker - Botão de Finalizar - Start Text Field
    @objc public func startDonedatePicker(){
        // mostrar na textField
        let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
        startTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        startDateInfoValue = formatter.string(from: datePicker.date)
        //print ("Start Date Info = \(startDateInfoValue)")

        
        // transformando para o parâmetro
        let start = DateFormatter()
            start.dateFormat = "yyyy-MM-dd"
        let startValue = start.string(from: datePicker.date)
        print(startValue)
        startDateValue = startValue
        //print(startDateValue)
    }
    
    // MARK: datepicker - Botão de Cancelar -  Start Text Field
    @objc func startCancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // MARK: modifica do teclado para o datePicker - Stop Text Field
    func stopShowDatePicker(){
        // formate date
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        
        // ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(stopDoneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(stopCancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        stopTextField.inputAccessoryView = toolbar
        stopTextField.inputView = datePicker
        
    }
    
    // MARK: datepicker - Botão de Finalizar - Stop Text Field
    @objc public func stopDoneDatePicker(){
        // mostrar na textField
        let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
        stopTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        stopDateInfoValue = formatter.string(from: datePicker.date)
        print("Stop Date Info = \(stopDateInfoValue)")
        
        // transformando para o parâmetro
        let stop = DateFormatter()
            stop.dateFormat = "yyyy-MM-dd"
        let stopValue = stop.string(from: datePicker.date)
        print(stopValue)
        stopDateValue = stopValue
        print(stopDateValue)
        
    }
    
    // MARK: datepicker - Botão de Cancelar - Stop Text Field
    @objc func stopCancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // MARK: Alerta
    // FIXME: Bug da volta para a tela inicial, apois isso a navegação para de funcionar
    func homeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let Action = UIAlertAction(title: "Alterar identificação", style: .default, handler: nil
            
        //// volta para a tela inicial
        //{ _ -> Void in
            // let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //let home = self.storyboard?.instantiateViewController(withIdentifier: "UsersTableViewController") as! UsersTableViewController
            //let nextViewController = home
            //modalAPIKey.modalPresentationStyle = .overCurrentContext
           // self.present(nextViewController, animated: true, completion: nil)
        //}
            
        )
        alert.addAction(Action)
        self.present(alert, animated: true){}
    }
    
    // MARK: tirar o foco ao tocar em outras partes da tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

