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

//import SwiftUI
//
//struct NewLetterView: View {
//    @State private var title: String = ""
//    @State private var recipient: String = ""
//    @State private var content: String = ""
//
//    @State private var selectedCategory: String = ""
//    @State private var isCreatingNewCategory = false
//    @State private var categories: [String] = UserDefaults.standard.stringArray(forKey: "categories") ?? []
//    
//    @State private var showFormattingMenu = false
//    @State private var showTemplatePicker = false
//    @State private var showAddOptions = false
//    
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var letters: [Letter]
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                floatingInputField(title: "Title", text: $title)
//                floatingInputField(title: "Recipient", text: $recipient)
//                categorySelector()
//
//                toolbar() // Formatting & Insert Options
//                
//                AutoExpandingTextEditor(text: $content)
//                                        .padding(.horizontal)
//
//                Spacer()
//
//                Button(action: saveLetter) {
//                    Text("Save Letter")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
//                        .cornerRadius(12)
//                        .shadow(radius: 3)
//                }
//                .padding()
//            }
//            
//            .padding()
//            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
//        }
//    }
//
//    // MARK: - Toolbar for Formatting & Insert Options
//    @ViewBuilder
//    private func toolbar() -> some View {
//        HStack {
//            Button(action: { showFormattingMenu.toggle() }) {
//                Image(systemName: "textformat.size")
//                    .font(.title2)
//                    .foregroundColor(.blue)
//            }
//            .sheet(isPresented: $showFormattingMenu) {
//                FormattingMenu()
//            }
//            .padding(.trailing, 50)
//            
////            Spacer(minLength: 10)
//            
//            Button(action: { showTemplatePicker.toggle() }) {
//                Image(systemName: "doc.text.image")
//                    .font(.title2)
//                    .foregroundColor(.purple)
//            }
//            .sheet(isPresented: $showTemplatePicker) {
//                TemplatePicker()
//            }
//            .padding(.trailing, 50)
//
////            Spacer()
//
//            Button(action: { showAddOptions.toggle() }) {
//                Image(systemName: "plus.circle.fill")
//                    .font(.title2)
//                    .foregroundColor(.green)
//            }
//            .actionSheet(isPresented: $showAddOptions) {
//                ActionSheet(title: Text("Insert"), buttons: [
//                    .default(Text("Image")) { /* Handle Image Upload */ },
//                    .default(Text("Audio File")) { /* Handle Audio Upload */ },
//                    .default(Text("Camera")) { /* Handle Camera Capture */ },
//                    .default(Text("Voice Recording")) { /* Handle Voice Recording */ },
//                    .default(Text("Emojis")) { /* Handle Emojis */ },
//                    .default(Text("Stickers")) { /* Handle Stickers */ },
//                    .cancel()
//                ])
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    // Floating Label Input Field
//    @ViewBuilder
//    private func floatingInputField(title: String, text: Binding<String>) -> some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//                .offset(y: text.wrappedValue.isEmpty ? 25 : 0)
//                .scaleEffect(text.wrappedValue.isEmpty ? 1.2 : 1, anchor: .leading)
//                .animation(.easeInOut(duration: 0.2), value: text.wrappedValue)
//
//            TextField("", text: text)
//                .padding(.vertical, 10)
//                .foregroundColor(.primary)
//                .background(Color.clear)
//                .overlay(
//                    Rectangle()
//                        .frame(height: 1)
//                        .foregroundColor(.gray)
//                        .opacity(0.7),
//                    alignment: .bottom
//                )
//        }
//        .padding(.horizontal)
//    }
//
//    // Category Selector with Stored Categories & "New Category" Option
//    @ViewBuilder
//    private func categorySelector() -> some View {
//        VStack(alignment: .leading) {
//            Text("Category")
//                .font(.caption)
//                .foregroundColor(.gray)
//
//            if isCreatingNewCategory {
//                floatingInputField(title: "New Category", text: $selectedCategory)
//            } else {
//                Menu {
//                    ForEach(categories, id: \.self) { category in
//                        Button(category) {
//                            selectedCategory = category
//                            isCreatingNewCategory = false
//                        }
//                    }
//                    Divider()
//                    Button("New Category") {
//                        isCreatingNewCategory = true
//                        selectedCategory = ""
//                    }
//                } label: {
//                    HStack {
//                        Text(selectedCategory.isEmpty ? "Select a Category" : selectedCategory)
//                            .foregroundColor(selectedCategory.isEmpty ? .gray : .primary)
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .background(Color.white.opacity(0.1).cornerRadius(10))
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    // Save Letter Function
//    private func saveLetter() {
//        let trimmedCategory = selectedCategory.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if !categories.contains(where: { $0.lowercased() == trimmedCategory.lowercased() }) {
//            categories.append(trimmedCategory)
//            UserDefaults.standard.set(categories, forKey: "categories")
//        }
//
//        let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: trimmedCategory)
//        letters.append(newLetter)
//        FileManagerHelper.saveLetters(letters)
//        presentationMode.wrappedValue.dismiss()
//    }
//
//    // Get Current Date
//    private func getCurrentDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, yyyy"
//        return formatter.string(from: Date())
//    }
//}
//
//// MARK: - Formatting Menu
//struct FormattingMenu: View {
//    @State private var selectedFont = "System"
//    @State private var fontSize: Double = 16
//    @State private var textColor: Color = .black
//    @State private var bgColor: Color = .white
//    
//    let allFonts = UIFont.familyNames.sorted()
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Text Formatting")
//                .font(.headline)
//            
//            VStack(alignment: .leading) {
//                                Text("Font Face")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                                
//                                Menu {
//                                    ForEach(allFonts, id: \.self) { font in
//                                        Button(font) {
//                                            selectedFont = font
//                                        }
//                                    }
//                                } label: {
//                                    HStack {
//                                        Text(selectedFont)
//                                            .foregroundColor(.primary)
//                                        Spacer()
//                                        Image(systemName: "chevron.down")
//                                            .foregroundColor(.gray)
//                                    }
//                                    .padding()
//                                    .background(Color.white.opacity(0.1).cornerRadius(10))
//                                }
//                            }
//                            .padding(.horizontal)
//
//
//            HStack {
//                Text("Font Size")
//                Slider(value: $fontSize, in: 12...36, step: 1)
//                Text("\(Int(fontSize))")
//            }
//            .padding()
//
//            HStack {
//                Text("Text Color")
//                ColorPicker("", selection: $textColor)
//            }
//            .padding()
//
//            HStack {
//                Text("Background Color")
//                ColorPicker("", selection: $bgColor)
//            }
//            .padding()
//
//            Button("Apply") {
//                // Apply formatting changes
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//// MARK: - Template Picker
//struct TemplatePicker: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Select a Template")
//                .font(.headline)
//
//            List {
//                Text("Formal Letter")
//                Text("Casual Letter")
//                Text("Apology Letter")
//                Text("Thank You Letter")
//                Text("Business Proposal")
//            }
//
//            Button("Close") {
//                // Close template picker
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.red)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//
//struct AutoExpandingTextEditor: View {
//    @Binding var text: String
//    @State private var textHeight: CGFloat = 120 // Minimum height for letter-writing space
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            // Placeholder
//            if text.isEmpty {
//                Text("Write your letter here...")
//                    .foregroundColor(.gray)
//                    .padding(.leading, 15)
//                    .padding(.top, 12)
//            }
//
//            TextEditor(text: $text)
//                .frame(minHeight: textHeight, maxHeight: .infinity) // Auto-expand height
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(Color.white.opacity(0.95)) // Soft background
//                        .shadow(color: Color.gray.opacity(0.2), radius: 5) // Soft shadow
//                )
//                .foregroundColor(.primary)
//                .font(.system(size: 18))
//                .onChange(of: text) { _ in
//                    adjustHeight()
//                }
//        }
//        .frame(maxWidth: UIScreen.main.bounds.width) // Full width with margin
//    }
//
//    private func adjustHeight() {
//        let minHeight: CGFloat = 120
//        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.6 // Max 60% of screen height
//        let estimatedHeight = CGFloat(text.split(separator: "\n").count) * 22 + 60 // Approximate line height
//        textHeight = max(minHeight, min(estimatedHeight, maxHeight))
//    }
//}
//
//#Preview{
//    NewLetterView(letters: .constant([]))
//}

import SwiftUI

struct NewLetterView: View {
    @State private var title: String = ""
    @State private var recipient: String = ""
    @State private var content: String = ""
    
    @State private var selectedCategory: String = ""
    @State private var isCreatingNewCategory = false
    @State private var categories: [String] = UserDefaults.standard.stringArray(forKey: "categories") ?? []
    
    @State private var showFormattingMenu = false
    @State private var showTemplatePicker = false
    @State private var showAddOptions = false
    @State private var isNewLetter: Bool
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @Binding var letters: [Letter]
    
    init(letters: Binding<[Letter]>, isNewLetter: Bool = true) {
        self._letters = letters
        self._categories = State(initialValue: CategoryManager.loadCategories())
        self._isNewLetter = State(initialValue: isNewLetter) // ✅ Start fresh or edit existing
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                // 🔹 HEADER: Title, Recipient & Category
                VStack(spacing: 15) {
                    floatingInputField(title: "Title", text: $title)
                    floatingInputField(title: "Recipient", text: $recipient)
                    categorySelector()
                }
                .padding(.horizontal)
                
                // 🔹 FULL-SCREEN LETTER AREA (NO EXTRA WHITE BG)
                ZStack(alignment: .bottom) {
                    AutoExpandingTextEditor(text: $content)
                        .padding(.horizontal)
                        .onChange(of: content) { _ in autoSaveLetter() }
                    
                    // 🔹 FLOATING TOOLBAR (Aa, Template, +)
                    HStack(spacing: 40) {
                        Button(action: { showFormattingMenu.toggle() }) {
                            Image(systemName: "textformat.size")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $showFormattingMenu) {
                            FormattingMenu()
                        }
                        
                        Button(action: { showTemplatePicker.toggle() }) {
                            Image(systemName: "doc.text.image")
                                .font(.title2)
                                .foregroundColor(.purple)
                        }
                        .sheet(isPresented: $showTemplatePicker) {
                            TemplatePicker()
                        }
                        
                        Button(action: { showAddOptions.toggle() }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .actionSheet(isPresented: $showAddOptions) {
                            ActionSheet(title: Text("Insert"), buttons: [
                                .default(Text("Image")) { /* Handle Image Upload */ },
                                .default(Text("Audio File")) { /* Handle Audio Upload */ },
                                .default(Text("Camera")) { /* Handle Camera Capture */ },
                                .default(Text("Voice Recording")) { /* Handle Voice Recording */ },
                                .default(Text("Emojis")) { /* Handle Emojis */ },
                                .default(Text("Stickers")) { /* Handle Stickers */ },
                                .cancel()
                            ])
                        }
                    }
                    .padding()
                    .background(BlurView(style: .systemMaterial)) // 🔹 Blurred Background for Floating Toolbar
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .frame(maxHeight: .infinity)
            }
            .navigationTitle("New Letter")
            .navigationBarItems(trailing: Button("Save") {
                saveLetter()
                dismiss() // ✅ Navigate back to Home Page
            })
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                if isNewLetter {
                    resetLetter() // ✅ If creating a new letter, start fresh
                }
                else{
                    loadLastSavedLetter()
                }
            }
        }
    }
    
    private func autoSaveLetter() {
        let letter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory, content: content)
        FileManagerHelper.saveLetters([letter]) // ✅ Save every time something changes!
    }
    
    private func saveLetter() {
            let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory, content: content)
            letters.append(newLetter) // ✅ Add to letters list
            FileManagerHelper.saveLetters(letters) // ✅ Save to file
        }

    
    // MARK: - Get Current Date
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    
    // MARK: - Reset Letter (Ensures New Letter Starts Blank)
    private func resetLetter() {
        title = ""
        recipient = ""
        content = ""
        selectedCategory = ""
    }
    
    private func loadLastSavedLetter() {
        if let savedLetter = FileManagerHelper.loadLetters().last {
            title = savedLetter.title
            recipient = savedLetter.recipient
            content = savedLetter.content
            selectedCategory = savedLetter.category
        }
    }
    
    
    // MARK: - Category Selector (FIXED BINDING)
    @ViewBuilder
    private func categorySelector() -> some View {
        VStack(alignment: .leading) {
            Text("Category")
                .font(.caption)
                .foregroundColor(.gray)
            
            Menu {
                ForEach(categories, id: \.self) { category in
                    Button(category) {
                        selectedCategory = category
                        isCreatingNewCategory = false
                    }
                }
                Divider()
                Button("New Category") {
                    isCreatingNewCategory = true
                    selectedCategory = ""
                }
            } label: {
                HStack {
                    Text(selectedCategory.isEmpty ? "Select a Category" : selectedCategory)
                        .foregroundColor(selectedCategory.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.3).cornerRadius(10))
            }
            
            if isCreatingNewCategory {
                floatingInputField(title: "New Category", text: $selectedCategory)
                    .onSubmit {
                        saveCategory() // ✅ Save new category to UserDefaults
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private func saveCategory() {
        let trimmedCategory = selectedCategory.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // ✅ Prevent Duplicate Categories (Case-Insensitive)
        if !categories.contains(where: { $0.lowercased() == trimmedCategory.lowercased() }) {
            categories.append(trimmedCategory)
            CategoryManager.saveCategories(categories) // ✅ Save to UserDefaults
        }
    }
}

// MARK: - Auto Expanding Full-Screen Text Editor (FIXED BG)
struct AutoExpandingTextEditor: View {
    @Binding var text: String
    @State private var textHeight: CGFloat = 300
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text("Write your letter here...")
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 12)
            }
            
            TextEditor(text: $text)
                .frame(minHeight: textHeight, maxHeight: .infinity) // Auto-expand
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.95)) // ✅ FIXED: No Extra White BG
                        .shadow(color: Color.gray.opacity(0.2), radius: 5)
                )
                .foregroundColor(.primary)
                .font(.system(size: 18))
                .onChange(of: text) { _ in adjustHeight() }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 40) // Full width with margins
    }
    
    private func adjustHeight() {
        let minHeight: CGFloat = 300
        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.85 // Allow full-screen writing
        let estimatedHeight = CGFloat(text.split(separator: "\n").count) * 22 + 60
        textHeight = max(minHeight, min(estimatedHeight, maxHeight))
    }
}

    struct CategoryManager {
        private static let key = "categories"

        static func saveCategories(_ categories: [String]) {
            UserDefaults.standard.set(categories, forKey: key)
        }

        static func loadCategories() -> [String] {
            return UserDefaults.standard.stringArray(forKey: key) ?? []
        }
    }

    
    // MARK: - Floating Label Input Field (PLACEMENT FIXED)
    @ViewBuilder
    private func floatingInputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .offset(y: text.wrappedValue.isEmpty ? 25 : 0)
                .scaleEffect(text.wrappedValue.isEmpty ? 1.2 : 1, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: text.wrappedValue)
            
            TextField("", text: text)
                .padding(.vertical, 10)
                .foregroundColor(.primary)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .opacity(0.7),
                    alignment: .bottom
                )
        }
        .padding(.horizontal)
    }
    
        
    // MARK: - Formatting Menu
    struct FormattingMenu: View {
        @State private var selectedFont = "System"
        @State private var fontSize: Double = 16
        @State private var textColor: Color = .black
        @State private var bgColor: Color = .white
        
        let allFonts = UIFont.familyNames.sorted()
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Text Formatting")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    Text("Font Face")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Menu {
                        ForEach(allFonts, id: \.self) { font in
                            Button(font) {
                                selectedFont = font
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedFont)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1).cornerRadius(10))
                    }
                }
                .padding(.horizontal)
                
                
                HStack {
                    Text("Font Size")
                    Slider(value: $fontSize, in: 12...36, step: 1)
                    Text("\(Int(fontSize))")
                }
                .padding()
                
                HStack {
                    Text("Text Color")
                    ColorPicker("", selection: $textColor)
                }
                .padding()
                
                HStack {
                    Text("Background Color")
                    ColorPicker("", selection: $bgColor)
                }
                .padding()
                
                Button("Apply") {
                    // Apply formatting changes
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
    
    
    
    // MARK: - Blur View for Floating Toolbar
    struct BlurView: UIViewRepresentable {
        let style: UIBlurEffect.Style
        
        func makeUIView(context: Context) -> UIVisualEffectView {
            let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
            return view
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    }
    
    // MARK: - Template Picker (FIXED UI)
    struct TemplatePicker: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("Select a Template")
                    .font(.headline)
                
                List {
                    Text("Formal Letter")
                    Text("Casual Letter")
                    Text("Apology Letter")
                    Text("Thank You Letter")
                    Text("Business Proposal")
                }
                
                Button("Close") {}
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }

#Preview {
    NewLetterView(letters: .constant([]))
}
