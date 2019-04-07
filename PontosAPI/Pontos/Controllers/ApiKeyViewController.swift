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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseApiKey(_ sender: UIButton) {
        
        
        var emailModal: String? = ""
        var keyModal: String? = ""
        
        emailModal = emailLabel.text
        keyModal = apiKeyLabel.text
        
        reference?.changeUserAPI(email: emailModal!, key: keyModal!)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // tirar o foco ao tocar em outras partes da tela
        view.endEditing(true)
    }
    
}
