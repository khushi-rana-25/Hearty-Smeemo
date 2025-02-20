//
//  HomeView.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var letters: [Letter]
    
    // Group letters by category
    var groupedLetters: [String: [Letter]] {
        Dictionary(grouping: letters.filter { !$0.isLocked }, by: { $0.category })
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedLetters.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category).font(.headline)) {
                        ForEach(groupedLetters[category] ?? []) { letter in
                            LetterCardView(letter: .constant(letter), letters: $letters)
                        }
                    }
                }
            }
            .navigationTitle("Letters Repo")
        }
    }
}

// Letter Card UI
import SwiftUI

struct LetterCardView: View {
    @Binding var letter: Letter
    @Binding var letters: [Letter]
    @State private var showExportOptions = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(letter.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("To: \(letter.recipient)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(letter.date)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Button(action: toggleLock) {
                    Image(systemName: letter.isLocked ? "lock.fill" : "lock.open.fill")
                        .foregroundColor(letter.isLocked ? .red : .gray)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Button(action: { showExportOptions = true }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())

            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
        .actionSheet(isPresented: $showExportOptions) {
                    ActionSheet(
                        title: Text("Export Letter"),
                        buttons: [
                            .default(Text("Save as PDF")) { exportAsPDF() },
                            .default(Text("Save as PNG")) { exportAsPNG() },
                            .default(Text("Save as Card")) { exportAsCard() },
                            .cancel()
                        ]
                    )
                }

    }

    private func toggleLock() {
        if let index = letters.firstIndex(where: { $0.id == letter.id }) {
            letters[index].isLocked.toggle()
            FileManagerHelper.saveLetters(letters) // ✅ Save updated lock status
        }
    }
    
    private func exportAsPDF() {
            PDFExporter.export(letter: letter)
        }

        private func exportAsPNG() {
            ImageExporter.export(letter: letter)
        }

        private func exportAsCard() {
            CardExporter.export(letter: letter)
        }
}

#Preview {
    HomeView(letters: .constant([]))
}
