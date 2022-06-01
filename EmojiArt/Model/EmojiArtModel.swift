//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Daniel Wippermann on 29.05.22.
//

import Foundation

struct EmojiArtModel {
    var background: Background = .blank
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable {
        var id: UUID
        
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int) {
            id = UUID()
            self.text = text
            self.x = x
            self.y = y
            self.size = size
        }
    }
    init() { }
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size))
    }
}
