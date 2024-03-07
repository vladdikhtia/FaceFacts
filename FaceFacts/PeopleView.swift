//
//  PeopleView.swift
//  FaceFacts
//
//  Created by Vladyslav Dikhtiaruk on 03/03/2024.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) var modelContext
    @Query var people: [Person] // all the person objects, it's up to date all time because of Query
    
    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    Text(person.name)
                }
            }
            .onDelete(perform: deletePerson)
        }
    }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        //        _people means change the query itself not a result
        _people = Query(filter: #Predicate { person in // if person in array it will return true, converting swift code to sql code, receiving one person to check,  only show people withmaching name
            
            if searchString.isEmpty {
                true
            } else {
                // no matter is it capitalized or no because of localizedContains
                person.name.localizedStandardContains(searchString)
                || person.emailAddress.localizedStandardContains(searchString)
                || person.details.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
    
    func deletePerson(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
    
    //TODO - add button to delete all people
    //    func deleteAllPeople(){
    //        try? modelContext.delete(model: Person.self)
    //    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return PeopleView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
