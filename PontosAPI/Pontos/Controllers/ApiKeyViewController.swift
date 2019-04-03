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
////        valor para teste
//        if apiKeyLabel.text == "" {
//            apiKeyLabel.text = "XJzUp/FcmBU8oozz"
//        }
//        if emailLabel.text == "" {
//            emailLabel.text = "gfranca@iblueconsulting.com.br"
//        }
        
        reference?.changeUserAPI(email: emailLabel.text!, apiKey: apiKeyLabel.text!)
        let emailUser = ClockifyUserHeader.getEmailAndxAPIKey.email!
               let keyUser = ClockifyUserHeader.getEmailAndxAPIKey.key!
        
        print(emailUser, keyUser)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
