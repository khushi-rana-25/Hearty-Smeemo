//
//import SwiftUI
//
//struct NewLetterView: View {
//    @State private var title: String = ""
//    @State private var recipient: String = ""
//    @State private var content: String = ""
//    @State private var selectedCategory: String = "Birthday Note"
//
//    // List of categories
//    let categories = ["Birthday Note", "Thank You", "Love Letter"]
//
//    // Environment property to dismiss view
//    @Environment(\.presentationMode) var presentationMode
//    
//    // Reference to shared letters (to update HomeView)
//    @Binding var letters: [Letter]
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Title", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                TextField("Recipient", text: $recipient)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Picker("Category", selection: $selectedCategory) {
//                    ForEach(categories, id: \.self) { category in
//                        Text(category)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                TextEditor(text: $content)
//                    .frame(height: 200)
//                    .padding()
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                
//                Spacer()
//                
//                Button(action: saveLetter) {
//                    Text("Save Letter").font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .padding()
//                }
//            }
//            .navigationTitle("New Letter")
//        }
//    }
//
//    // Save Letter Function
//    private func saveLetter() {
//        let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory)
//        letters.append(newLetter) // Add new letter to the list
//        FileManagerHelper.saveLetters(letters)
//        presentationMode.wrappedValue.dismiss() // Navigate back
//    }
//
//    // Get Current Date
//    private func getCurrentDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: Date())
//    }
//}
//
//#Preview {
//    NewLetterView(letters: .constant([]))
//}

import SwiftUI

struct NewLetterView: View {
    @State private var title: String = ""
    @State private var recipient: String = ""
    @State private var content: String = ""
    @State private var selectedCategory: String = ""

    // Formatting states
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderlined = false
    @State private var fontSize: CGFloat = 16
    @State private var fontColor: Color = .black
    @State private var backgroundColor: Color = .white
    @State private var selectedFont: String = "System"

    @State private var showFormattingOptions = false

    let fonts = ["System", "Arial", "Times New Roman", "Helvetica"]

    @Environment(\.presentationMode) var presentationMode
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

                TextField("Category", text: $selectedCategory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Aa Button to Open Formatting Options
                HStack {
                    Spacer()
                    Button(action: { showFormattingOptions.toggle() }) {
                        Image(systemName: "textformat") // "Aa" icon
                            .font(.title2)
                            .padding()
                    }
                    .popover(isPresented: $showFormattingOptions) {
                        formattingMenu()
                    }
                }

                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(fontColor)
                    .background(backgroundColor)
                    .font(.custom(selectedFont, size: fontSize))
                    .bold(isBold)
                    .italic(isItalic)
                    .underline(isUnderlined, color: fontColor)

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

    // Formatting Menu
    @ViewBuilder
    private func formattingMenu() -> some View {
        VStack {
            Toggle("Bold", isOn: $isBold)
            Toggle("Italic", isOn: $isItalic)
            Toggle("Underline", isOn: $isUnderlined)
            
            HStack {
                Text("Font Size")
                Slider(value: $fontSize, in: 12...30, step: 1)
            }

            Picker("Font", selection: $selectedFont) {
                ForEach(fonts, id: \.self) { font in
                    Text(font).tag(font)
                }
            }

            ColorPicker("Text Color", selection: $fontColor)
            ColorPicker("Background Color", selection: $backgroundColor)

            Button("Close") {
                showFormattingOptions = false
            }
            .padding()
        }
        .padding()
        .frame(width: 250)
    }

    // Save Letter Function
    private func saveLetter() {
        let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory)
        letters.append(newLetter)
        FileManagerHelper.saveLetters(letters)
        presentationMode.wrappedValue.dismiss()
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
