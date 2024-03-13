//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 13.03.2024.
//

import SwiftUI

struct PaletteManager: View {
    let stores: [PaletteStore]
    @State var selectedStore: PaletteStore?
    
    
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                Text(store.name) // bad
                    .tag(store)
            }
        }content:  {
                if let selectedStore{
                    EditablePaletteList(store: selectedStore)
                }
                Text("Choose a store")
            
        } detail: {
            Text("Choose a palette")
        }
    }
}

//#Preview {
//    PaletteManager()
//}
