//
//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.

import UIKit

struct CardExporter {
    static func export(letter: Letter) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: 250))

        let image = renderer.image { ctx in
            UIColor.systemPink.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 500, height: 250))

            let titleFont = UIFont.boldSystemFont(ofSize: 28)
            let textFont = UIFont.systemFont(ofSize: 20)

            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.white]
            let textAttributes: [NSAttributedString.Key: Any] = [.font: textFont, .foregroundColor: UIColor.white]

            let title = "\(letter.title)\n"
            let recipient = "To: \(letter.recipient)\n"
            let content = "Date: \(letter.date)"

            title.draw(at: CGPoint(x: 20, y: 40), withAttributes: titleAttributes)
            recipient.draw(at: CGPoint(x: 20, y: 90), withAttributes: textAttributes)
            content.draw(at: CGPoint(x: 20, y: 140), withAttributes: textAttributes)
        }

        print("Card exported successfully!")
    }
}
