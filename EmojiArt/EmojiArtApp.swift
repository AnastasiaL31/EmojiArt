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
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
    }
}
