//
//  EditPersonView.swift
//  FaceFacts
//
//  Created by Vladyslav Dikhtiaruk on 03/03/2024.
//

import PhotosUI
import SwiftUI
import SwiftData

struct EditPersonView: View {
    @Environment(\.modelContext) var modelContext // read Ram correctly
    @Binding var navigationPath: NavigationPath
    @Bindable var person: Person
    @State private var selectedItem: PhotosPickerItem?
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]
    
    var body: some View {
        Form{
            if let imageData = person.photo, // checks if the person.photo property is not nil
               let uiImage = UIImage(data: imageData) { // checks if the UIImage can be created from the imageData
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
            }
            
            Section {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }
            Section{
                TextField("Name", text: $person.name)
                    .textContentType(.name) // autocomplete
                
                TextField("Email address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)
                    
                    if !events.isEmpty {
                        Divider()
                        
                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event)) // when you choose event select this event, when is unknown event it's null
                        }
                    }
                }
                Button("Add new event", action: addEvent)
            }
            
            Section("Notes") {
                TextField("details about this person", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
    
    func addEvent(){
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        navigationPath.append(event)
    }
    
    func loadPhoto(){
        Task { @MainActor in
            person.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EditPersonView(navigationPath: .constant(NavigationPath()), person: previewer.person)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
