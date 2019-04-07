//
//  ApiKeyViewController.swift
//  Pontos
//
//  Created by Andreza Moreira on 29/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class ApiKeyViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var apiKeyLabel: UITextField!
    
    
    weak var reference: UsersTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseApiKey(_ sender: UIButton) {
        
        var email: String? = ""
        var apiKey: String? = ""
        
        email = emailLabel.text
        apiKey = apiKeyLabel.text
        
        ClockifyUserHeader.clearUserData()
        
        reference?.changeUserAPI(email: email!, apiKey: apiKey!)
        
        dismiss(animated: true, completion: nil)
        view.endEditing(true)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // tirar o foco ao tocar em outras partes da tela
        view.endEditing(true)
    }
}
