//
//  SwiftUIView.swift
//  Smeemo
//
//  Created by Batch - 2  on 18/02/25.
//

import SwiftUI

struct MainScreen: View {
    @State private var showModal = false
    
    var body: some View {
        VStack {

            Spacer(minLength: 30)
            Text("Smeemo").font(.largeTitle).bold()
             .padding(.leading, -170)

            Text("Your World! 🌍")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.top, 10)
                .padding(.leading, -160)
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
                TabButton(icon: "plus.circle.fill", label: "")
                    .font(.system(size: 60))
                    .onTapGesture {
                        showModal = true
                    }
                Spacer()
                TabButton(icon: "lock", label: "Locked Letters")
            }
            .padding(.top, 5)
            .background(Color.white)
        }
        .padding()
        .sheet(isPresented: $showModal) {
                    NewLetterModal()
                .presentationDetents([.height(200)]) // Set custom height for the modal
                .presentationDragIndicator(.visible)
                }
        
        
       
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
    @State private var isPopupVisible = false

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
            Menu {
                Button(action: {
                    
                }) {
                    Label("Lock", systemImage: "lock")
                }
                Button(action: {
                
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                Button(action: {
                    
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
            }
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

// MARK: - PLUS ICON MODAL VIEW
import SwiftUI

struct NewLetterModal: View {
    @State private var showGenerateLetter = false
    @State private var showDesignLetter = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 50)
            
            Button(action: {
                showGenerateLetter = true
            }) {
                HStack {
                    Image(systemName: "text.badge.plus")
                        .font(.title)
                    Text("Generate your letter")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .fullScreenCover(isPresented: $showGenerateLetter) {
                GenerateLetter()
            }

            Button(action: {
                showDesignLetter = true
            }) {
                HStack {
                    Image(systemName: "paintbrush.fill")
                        .font(.title)
                    Text("Design your letter")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .fullScreenCover(isPresented: $showDesignLetter) {
                DesignLetter()
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
