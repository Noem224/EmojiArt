//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Daniel Wippermann on 29.05.22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var document = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
