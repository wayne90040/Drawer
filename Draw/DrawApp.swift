//
//  DrawApp.swift
//  Draw
//
//  Created by user on 2023/12/15.
//

import SwiftUI
import SwiftData

@main
struct DrawApp: App {
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
            ContentView()
//            DrawView()
        }
        .modelContainer(sharedModelContainer)
    }
}
