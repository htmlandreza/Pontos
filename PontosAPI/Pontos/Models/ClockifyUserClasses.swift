//
//  ClockifyUserClasses.swift
//  Pontos
//
//  Created by Andreza Moreira on 01/04/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import Foundation

// header da requisição
struct ClockifyUserHeader: Codable {
    let xAPIKey: String // x-api-key
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



