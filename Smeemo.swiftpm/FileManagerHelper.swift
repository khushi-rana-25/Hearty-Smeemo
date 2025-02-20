//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import Foundation

struct FileManagerHelper {
    static let fileName = "letters.json"
    
    // Get File Path
    static func getFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }

    // Save Letters to File
    static func saveLetters(_ letters: [Letter]) {
        do {
            let data = try JSONEncoder().encode(letters)
            try data.write(to: getFilePath(), options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving letters: \(error.localizedDescription)")
        }
    }

    // Load Letters from File
    static func loadLetters() -> [Letter] {
        let filePath = getFilePath()
        guard FileManager.default.fileExists(atPath: filePath.path) else { return [] }
        
        do {
            let data = try Data(contentsOf: filePath)
            return try JSONDecoder().decode([Letter].self, from: data)
        } catch {
            print("Error loading letters: \(error.localizedDescription)")
            return []
        }
    }
}

