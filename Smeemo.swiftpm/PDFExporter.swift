//
//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import UIKit
import PDFKit

struct PDFExporter {
    static func export(letter: Letter) -> URL {
        let pdfMetaData = [
            kCGPDFContextCreator: "Smeemo",
            kCGPDFContextAuthor: "User"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let pdfData = renderer.pdfData { context in
            context.beginPage()
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let textFont = UIFont.systemFont(ofSize: 18)

            let titleAttributes = [NSAttributedString.Key.font: titleFont]
            let textAttributes = [NSAttributedString.Key.font: textFont]

            let title = "\(letter.title)\n\n"
            let recipient = "To: \(letter.recipient)\n\n"
            let content = "Category: \(letter.category)\nDate: \(letter.date)"

            title.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            recipient.draw(at: CGPoint(x: 50, y: 100), withAttributes: textAttributes)
            content.draw(at: CGPoint(x: 50, y: 150), withAttributes: textAttributes)
        }

        let pdfFilename = FileManagerHelper.getFilePath().deletingPathExtension().appendingPathExtension("pdf")

        do {
            try pdfData.write(to: pdfFilename)
            print("Saved PDF to: \(pdfFilename)")
            
            if FileManager.default.fileExists(atPath: pdfFilename.path) {
                return pdfFilename
            }else{
                print("❌ Error: PDF file not found after saving!")
                return pdfFilename
            }
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
            return pdfFilename
        }
    }
}
