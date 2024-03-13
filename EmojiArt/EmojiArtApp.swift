//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 16.02.2024.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    @StateObject var store2 = PaletteStore(named: "Alternative")
    @StateObject var store3 = PaletteStore(named: "Special")

    var body: some Scene {
        WindowGroup {
            PaletteManager(stores: [paletteStore, store2, store3])
            //EmojiArtDocumentView(document: defaultDocument)
            .environmentObject(paletteStore)
        }
    }
}
