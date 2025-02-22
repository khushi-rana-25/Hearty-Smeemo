//
//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import Foundation

// Letter Data Model
struct Letter: Identifiable, Codable { // Added Codable for JSON support
    let id: UUID
    let title: String
    let recipient: String
    let date: String
    let category: String
    let content: String
    var isLocked: Bool

    init(title: String, recipient: String, date: String, category: String, content: String, isLocked: Bool = false) {
        self.id = UUID()
        self.title = title
        self.recipient = recipient
        self.date = date
        self.category = category
        self.content = content
        self.isLocked = isLocked
    }
}
