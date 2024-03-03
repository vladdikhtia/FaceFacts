//
//  EditPersonView.swift
//  FaceFacts
//
//  Created by Vladyslav Dikhtiaruk on 03/03/2024.
//

import SwiftUI

struct EditPersonView: View {
    @Bindable var person: Person
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $person.name)
                    .textContentType(.name) // autocomplete
                
                TextField("Email address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Notes") {
                TextField("details about this person", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    EditPersonView(person: Person(name: "Vlad", emailAddress: "jkfhaskf@gmail.com", details: "fjdhkshgljksdfhljk sdhfkjsda"))
//}
