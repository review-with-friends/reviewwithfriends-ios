//
//  LikeEmojis.swift
//  app
//
//  Created by Colton Lathrop on 6/14/23.
//

import Foundation

struct Emoji: Identifiable {
    var id: Int
    var emoji: String
}

func getEmojiFromNumber(number: Int) -> Emoji {
    switch number {
    case 0:
        return Emoji(id: 0, emoji: "❤️")
    case 1:
        return Emoji(id: 1, emoji: "🔥")
    case 2:
        return Emoji(id: 2, emoji: "😍")
    case 3:
        return Emoji(id: 3, emoji: "😢")
    case 4:
        return Emoji(id: 4, emoji: "🤣")
    default:
        return Emoji(id: 0, emoji: "❤️")
    }
}

func getEmojiFromEmoji(emoji: String) -> Emoji {
    switch emoji {
    case "❤️":
        return Emoji(id: 0, emoji: "❤️")
    case "🔥":
        return Emoji(id: 1, emoji: "🔥")
    case "😍":
        return Emoji(id: 2, emoji: "😍")
    case "😢":
        return Emoji(id: 3, emoji: "😢")
    case "🤣":
        return Emoji(id: 4, emoji: "🤣")
    default:
        return Emoji(id: 0, emoji: "❤️")
    }
}
