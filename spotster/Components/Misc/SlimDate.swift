//
//  SlimDate.swift
//  spotster
//
//  Created by Colton Lathrop on 12/24/22.
//

import Foundation
import SwiftUI

/// Makes nice text for the given date of a review or reply.
/// "12/27" or "last month" or "last year"
struct SlimDate: View {
    var date: Date
    
    func trimString(string: String, numChars: Int) -> String {
        let start = string.index(string.startIndex, offsetBy: 0)
        let end = string.index(string.endIndex, offsetBy: -numChars)
        let range = start..<end
        return String(string[range])
    }
    
    func getDateString() -> String {
        var text = ""
        if date > Date().addingTimeInterval(-3600) {
            text = "just now"
        } else if date > Date().addingTimeInterval(-86400) {
            text = "today"
        } else if date > Date().addingTimeInterval(-172800) {
            text = "yesterday"
        } else if date > Date().addingTimeInterval(-604800) {
            text = "few days ago"
        } else if date > Date().addingTimeInterval(-1209600) {
            text = "last week"
        } else if date > Date().addingTimeInterval(-2419200) {
            text = "couple weeks ago"
        } else if date > Date().addingTimeInterval(-3628800) {
            text = "few weeks ago"
        } else if date > Date().addingTimeInterval(-4838400) {
            text = "a month ago"
        } else if date > Date().addingTimeInterval(-9676800) {
            text = "last month"
        } else if date > Date().addingTimeInterval(-31536000) {
            text = trimString(string: date.formatted(date: .numeric, time: .omitted), numChars: 5)
        } else if date > Date().addingTimeInterval(-63072000) {
            text = "last year"
        } else if date > Date().addingTimeInterval(-126144000) {
            text = "few years ago"
        } else {
            text = "a long time ago"
        }
        
        return text;
    }
    
    var body: some View {
        Text(getDateString()).foregroundColor(.secondary).font(.caption)
    }
}

struct SlimDate_Preview: PreviewProvider {
    static func callback() -> Void {
        
    }
    
    static var previews: some View {
        VStack{
            SlimDate(date: Date()).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-23094)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-23923094)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-734634)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-569569)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-234923499)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-2373723)).preferredColorScheme(.dark)
            SlimDate(date: Date().addingTimeInterval(-122232)).preferredColorScheme(.dark)
        }
    }
}
