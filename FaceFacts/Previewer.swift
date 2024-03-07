//
//  Previewer.swift
//  FaceFacts
//
//  Created by Vladyslav Dikhtiaruk on 07/03/2024.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true) // not on the disk, it's just temporary data for preview
        container = try ModelContainer(for: Person.self, configurations: config)
        
        event = Event(name: "Code Europe", location: "Warsaw")
        person = Person(name: "Tom Shelby", emailAddress: "tom.shelby@gmail.com", details: "", metAt: event)
        
        container.mainContext.insert(person)
    }
}
