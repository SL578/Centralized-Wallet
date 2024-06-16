//
//  Centralized_WalletApp.swift
//  Centralized Wallet
//
//  Created by Stephen Lin on 6/13/24.
//

import SwiftUI
import SwiftData

@main
struct Centralized_WalletApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView_06162024()
        }
        .modelContainer(sharedModelContainer)
    }
}
