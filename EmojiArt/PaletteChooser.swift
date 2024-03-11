//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 22.02.2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    @State var showPalleteEditor = false
    
    var body: some View {
        HStack {
            chooser
                //.popover(isPresented: $showPalleteEditor) {
                //    PalleteEditor()
                //}
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
        .sheet(isPresented: $showPalleteEditor) {
            PalleteEditor(palette: $store.palettes[store.cursorIndex])
                .font(nil)
        }
    }
    private var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            gotoMenu
            AnimatedActionButton("New", systemImage: "plus"){
                store.insert(name: "", emojis: "")
                showPalleteEditor = true
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive){
                store.palettes.remove(at: store.cursorIndex)
            }
            AnimatedActionButton("Edit", systemImage: "pencil"){
                showPalleteEditor = true
            }
        }
    }
    
    private var gotoMenu: some View{
        Menu {
            ForEach(store.palettes) { pallete in
                AnimatedActionButton(pallete.name) {
                    if let index = store.palettes.firstIndex(where: {$0.id == pallete.id}){
                        store.cursorIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
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
