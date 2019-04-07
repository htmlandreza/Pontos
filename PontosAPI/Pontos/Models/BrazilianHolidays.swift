//
//  BrazilianHolidays.swift
//  Pontos
//
//  Created by Andreza Moreira on 05/04/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import Foundation

typealias BrazilianHolidays = [BrazilianHoliday]

struct BrazilianHoliday: Codable {
    let date, title, description, legislation: String
    let startTime, endTime: String
    let variableDates: [String: String]
}


