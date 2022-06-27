//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Daniel Wippermann on 29.05.22.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if self.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    init() {
        emojiArt = EmojiArtModel()
    }
    
    private func save(to url: URL) {
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisfunction) error = \(error)")
        }
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    @Published var selectedEmojis = Set<EmojiArtModel.Emoji>()
    
    var background: EmojiArtModel.Background { emojiArt.background }
    
    //MARK: - Background

    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch self.background {
        case .blank:
            break
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if let imageData = imageData {
                            self?.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        }
    }
    
    //MARK: - User Intends
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
        print("background set to \(background)")
    }
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int(CGFloat(emojiArt.emojis[index].size) * scale.rounded(.toNearestOrAwayFromZero))
        }
    }
    func selectEmoji(_ emoji: EmojiArtModel.Emoji) {
        if !selectedEmojis.contains(emoji) {
            selectedEmojis.insert(emoji)
        } else {
            selectedEmojis.remove(emoji)
        }
    }
}
