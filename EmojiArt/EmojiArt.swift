//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 16.02.2024.
//

import Foundation

struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]()
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String,at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    
    }
    
    mutating func resizeEmoji(_ id: Int, scale: Float) {
        if let emojiIndex = emojis.firstIndex(where: { emoji in emoji.id == id}) {
            emojis[emojiIndex].size = Int(Float(emojis[emojiIndex].size) * scale)
        }
    }
    
    mutating func moveEmoji(_ id: Int, offset: Emoji.Position){
        if let emojiIndex = emojis.firstIndex(where: { emoji in emoji.id == id}) {
            emojis[emojiIndex].position += offset
        }
    }
    
    mutating func deleteEmoji(_ id: Int){
        if let emojiIndex = emojis.firstIndex(where: { emoji in emoji.id == id}) {
            emojis.remove(at: emojiIndex)
        }
    }
    
    
    struct Emoji : Identifiable{
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}
