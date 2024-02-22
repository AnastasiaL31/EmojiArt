//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 22.02.2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    private var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus"){
                store.insert(name: "Math", emojis: "+−ℸℏ∞≩≭")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive){
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
    
    
    func view(for palette: Palette) -> some View{
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init) //from character to string
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}
