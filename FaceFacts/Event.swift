//
//  Event.swift
//  FaceFacts
//
//  Created by Vladyslav Dikhtiaruk on 05/03/2024.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String
    var location: String
    var people: [Person] = []
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
