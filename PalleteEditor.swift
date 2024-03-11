//
//  PalleteEditor.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 11.03.2024.
//

import SwiftUI

struct PalleteEditor: View {
    @Binding var palette: Palette
    @State private var emojisToAdd: String = ""
    private let  emojiFont  = Font.system(size: 40)
    @FocusState private var focused: Focused?
    
    enum Focused {
        case name
        case addEmojis
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")){
                TextField("Name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Emojis")){
                TextField("Add more Emojis", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd ) { emojisToAdd in
                        palette.emojis = (emojisToAdd + palette.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear(){
            if palette.name.isEmpty {
                focused = .name
            }else{
                focused = .addEmojis
            }
        }
        
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove emoji").font(.caption).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self){ emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}

#Preview {
    @State var palette = PaletteStore(named: "Preview").palettes.first!
    return PalleteEditor(palette: $palette)
}
