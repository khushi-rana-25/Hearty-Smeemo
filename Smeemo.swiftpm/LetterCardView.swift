
import SwiftUI

struct LetterCardView: View {
    @Binding var letter: Letter
    @Binding var letters: [Letter]
    @State private var showExportOptions = false
    @State private var previewURL: IdentifiableURL?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
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
                }
                Spacer()

                // Ellipsis Button
                Menu {
                    Button(action: editLetter) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(action: toggleLock) {
                        Label(letter.isLocked ? "Unlock" : "Lock", systemImage: letter.isLocked ? "lock.open.fill" : "lock.fill")
                    }
                    Button(action: {showExportOptions = true}) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive, action: deleteLetter) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
        .sheet(item: $previewURL) { wrapper in
            DocumentPreviewController(url: wrapper.url)
        }
    }
    
    // Actions
    private func toggleLock() {
        if let index = letters.firstIndex(where: { $0.id == letter.id }) {
            letters[index].isLocked.toggle()
            FileManagerHelper.saveLetters(letters)
        }
    }

    private func exportAsPDF() {
        let url = PDFExporter.export(letter: letter)
        previewURL = IdentifiableURL(url: url)
    }
    
    private func exportAsPNG() {
        if let url = ImageExporter.export(letter: letter) {
            previewURL = IdentifiableURL(url: url)
        } else {
            print("❌ Error exporting PNG")
        }
    }

    private func exportAsCard() {
        CardExporter.export(letter: letter)
    }

    private func deleteLetter() {
        letters.removeAll { $0.id == letter.id }
        FileManagerHelper.saveLetters(letters)
    }

    private func editLetter() {
        print("Edit functionality to be implemented")
    }
}

