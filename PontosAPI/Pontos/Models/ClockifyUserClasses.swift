//
//  ClockifyUserClasses.swift
//  Pontos
//
//  Created by Andreza Moreira on 01/04/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import Foundation

// header da requisição

// guardando email e api key
struct ClockifyUserHeader {
    static let (emailUser, xAPIKey) = ("email", "key")
    
    static let userSessionKey = "com.save.usersession"
    
    struct Model {
        var email: String? = "iblue"
        var key: String? = "123"
        
        init(_ json: [String: String]) {
            self.email = json[emailUser]
            self.key = json[xAPIKey]
        }
    }
    
    static var saveEmailAndxAPIKey = { (email: String, key: String) in
        UserDefaults.standard.set([emailUser: email, xAPIKey: key], forKey: userSessionKey)
        UserDefaults.standard.synchronize()
    }
    
    static var getEmailAndxAPIKey = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }(())
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userSessionKey)
    }
}

struct ClockifyUser: Codable{
    let id: String
    let email: String
    let name: String
    let status: String
    
    init(id: String, email: String, name: String, status: String) {
        self.id = id
        self.email = email
        self.name = name
        self.status = status
    }
}

//enum Status: String, Codable {
//    case active = "Ativo"
//    case pendingEmailVerification = "Verificação de e-mail pendente"
//    case deactivated = "Desativo"
//}



