//
//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import UIKit

struct ImageExporter {
    static func export(letter: Letter) -> URL? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 300))
        
        let image = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 400, height: 300))
            
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let textFont = UIFont.systemFont(ofSize: 18)
            
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: UIColor.black]
            let textAttributes: [NSAttributedString.Key: Any] = [.font: textFont, .foregroundColor: UIColor.gray]
            
            let title = "\(letter.title)\n"
            let recipient = "To: \(letter.recipient)\n"
            let content = "Category: \(letter.category)\nDate: \(letter.date)"
            
            title.draw(at: CGPoint(x: 20, y: 40), withAttributes: titleAttributes)
            recipient.draw(at: CGPoint(x: 20, y: 80), withAttributes: textAttributes)
            content.draw(at: CGPoint(x: 20, y: 120), withAttributes: textAttributes)
        }
        
        if let pngData = image.pngData() {
            let filename = FileManagerHelper.getFilePath().deletingPathExtension().appendingPathExtension("png")
            do {
                try pngData.write(to: filename)
                print("✅ Saved PNG to: \(filename.path)")
                return filename
            } catch {
                print("❌ Error saving PNG: \(error.localizedDescription)")
                return filename
            }
        }
        return nil
    }
  }

