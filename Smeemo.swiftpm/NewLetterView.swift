//  NewLetterView.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import SwiftUI

struct NewLetterView: View {
    @State private var title: String = ""
    @State private var recipient: String = ""
    @State private var content: String = ""
    @State private var selectedCategory: String = "Birthday Note"

    // List of categories
    let categories = ["Birthday Note", "Thank You", "Love Letter"]

    // Environment property to dismiss view
    @Environment(\.presentationMode) var presentationMode
    
    // Reference to shared letters (to update HomeView)
    @Binding var letters: [Letter]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Recipient", text: $recipient)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Spacer()
                
                Button(action: saveLetter) {
                    Text("Save Letter").font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("New Letter")
        }
    }

    // Save Letter Function
    private func saveLetter() {
        let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory)
        letters.append(newLetter) // Add new letter to the list
        FileManagerHelper.saveLetters(letters)
        presentationMode.wrappedValue.dismiss() // Navigate back
    }

    // Get Current Date
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
}

#Preview {
    NewLetterView(letters: .constant([]))
}
