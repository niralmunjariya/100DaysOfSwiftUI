//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Niral Munjariya on 17/01/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, createdDate
    }
    
    let filter: FilterType
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var sort: SortType = .createdDate
    @State private var showingSortSelector = false
    
    var title : String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        var filteredProspects: [Prospect]
        switch filter {
        case .none:
            filteredProspects =  prospects.people
        case .contacted:
            filteredProspects = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filteredProspects = prospects.people.filter { !$0.isContacted }
        }
        
        let sortedPersons = filteredProspects.sorted { lhs, rhs in
            switch sort {
            case .name:
                return lhs.name < rhs.name
            case .createdDate:
                return lhs.createdDate > rhs.createdDate
            }
        }
        return sortedPersons
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading ){
                        HStack {
                            VStack (alignment: .leading ) {
                                Text(prospect.name)
                                    .font(.headline)
                                Text(prospect.emailAddress)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if filter == .none && prospect.isContacted {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .swipeActions(edge: .leading) {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            prospects.deleteProspect(prospect)
                        } label: {
                            Label("Delete", systemImage: "minus.circle")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                            Text("Scan")
                        }
                    }
                }
                
                ToolbarItem (placement: .navigationBarLeading){
                    Button {
                        showingSortSelector = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down.circle")
                            Text("Sort")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: prospects.randomProspects.randomElement()!) { result in
                    handleScan(result: result)
                }
            }
            .confirmationDialog("Select sort option", isPresented: $showingSortSelector) {
                Button("Name") {
                    sort = .name
                }
                
                Button("Recent first") {
                    sort = .createdDate
                }
            } message : {
                Text("Sort by")
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let prospect = Prospect()
            prospect.name = details[0]
            prospect.emailAddress = details[1]
            prospects.addProspect(prospect)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings {setting in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
