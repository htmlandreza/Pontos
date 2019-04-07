//
//  ClockifyTimeEntriesInRangeClasses.swift
//  Pontos
//
//  Created by Andreza Moreira on 01/04/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import Foundation

struct ClockifyTimeEntries: Codable {
    let id: String
    let description: String
    let user: ClockifyUser
    let project: ClockifyProject?
    let timeInterval: ClockifyTimeInterval
    
    init(id: String, description: String, user: ClockifyUser, project: ClockifyProject, timeInterval : ClockifyTimeInterval) {
        self.id = id
        self.description = description
        self.user = user
        self.project = project
        self.timeInterval = timeInterval
    }
}

struct ClockifyProject: Codable {
    let id: String
    let name: String
    let clientName: String
}

struct ClockifyTimeInterval: Codable {
    let start: String
    let end: String
    let duration: String
}
