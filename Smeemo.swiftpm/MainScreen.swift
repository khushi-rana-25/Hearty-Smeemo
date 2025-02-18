//
//  SwiftUIView.swift
//  Smeemo
//
//  Created by Batch - 2  on 18/02/25.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        VStack {

            Spacer(minLength: 30)
            HStack {
                Text("Smeemo")
                    .font(.largeTitle).bold()
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 10)

            Text("Your World! 🌍")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.top, 10)
                .padding(.leading, 1)
                .padding(.bottom, 30)

            ScrollView {
                VStack(alignment: .leading, spacing: 30
                ) {
                    LetterSection(title: "Thank you Letters", letters: [
                        Letter(recipient: "Muya", date: "4 Feb 2024"),
                        Letter(recipient: "Sanju ☺️", date: "4 Feb 2024")
                    ])
                    LetterSection(title: "Birthday Letters", letters: [
                        Letter(recipient: "Idiot", date: "31 Jan 2023"),
                        Letter(recipient: "Kaa 🥳", date: "4 Feb 2025")
                    ])
                    LetterSection(title: "Love Letters", letters: [
                        Letter(recipient: "Idiot 😍", date: "31 Jan 2023")
                    ])
                }
            }.scrollIndicators(.hidden)

            Divider()
                .frame(height: 0.5)
                .background(Color.gray)

            HStack {
                TabButton(icon: "doc.text", label: "Letters Repo")
                Spacer()
                TabButton(icon: "plus.circle.fill", label: "New Letter")
                    .font(.system(size: 30))
                Spacer()
                TabButton(icon: "lock.fill", label: "Locked Letters")
            }
            .padding(.top, 5)
            .background(Color.white)
        }
        .padding()
    }
}

// MARK: - Letter Section
struct LetterSection: View {
    var title: String
    var letters: [Letter]
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline).bold()
                    .padding(.leading, 16)
                Spacer()
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.black)
                }.padding(.trailing, 16)
            }
            .padding(.vertical, 5)

            if isExpanded {
                ForEach(letters, id: \.recipient) { letter in
                    LetterCard(letter: letter)
                }
            }
        }
    }
}

// MARK: - Letter Card
struct LetterCard: View {
    var letter: Letter

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "FF95CA"))
                .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text("Sent to: \(letter.recipient)")
                    .font(.subheadline).bold()
                Text(letter.date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

// MARK: - Tab Button
struct TabButton: View {
    var icon: String
    var label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.footnote)
        }
        .foregroundColor(.purple)
    }
}

// MARK: - Data Model
struct Letter {
    var recipient: String
    var date: String
}

// MARK: - HEX COLOR EXTENSION
extension Color {
    init(hex: String) {
        // Ensure the hex string has a valid format
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hexSanitized)
        scanner.currentIndex = hexSanitized.startIndex
        var rgb: UInt64 = 0

        if scanner.scanHexInt64(&rgb) {
            self.init(
                .sRGB,
                red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x0000FF) / 255.0,
                opacity: 1.0
            )
        } else {
            self.init(.clear)
        }
    }
}
