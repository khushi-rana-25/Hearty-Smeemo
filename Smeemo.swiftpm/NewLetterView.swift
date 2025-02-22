
import SwiftUI

class RichTextViewModel: ObservableObject {
    @Published var content: NSMutableAttributedString = NSMutableAttributedString(string: "") {
        didSet {
            // Add any additional processing if needed
            objectWillChange.send()
        }
    }
}


struct NewLetterView: View {
    @State private var title: String = ""
    @State private var recipient: String = ""
    @State private var selectedCategory: String = ""
    @State private var isCreatingNewCategory = false
    @State private var categories: [String] = []
    @State private var isNewLetter: Bool
    
    // 🔹 Formatting States
    @State private var content: NSAttributedString = NSAttributedString(string:  " ")
    @State private var selectedFont: String = "Helvetica"
    @State private var fontSize: Double = 16
    @State private var textColor: Color = .black
    @State private var bgColor: Color = .white
    @State private var isBold: Bool = false
    @State private var isItalic: Bool = false
    @State private var isUnderlined: Bool = false
    @State private var showFontPicker = false
    @State private var showColorPicker = false
    @State private var showTemplatePicker = false
    @State private var showAddOptions = false
    @State private var showFormattingMenu = false
    @State private var showEmojiPicker = false

    @StateObject private var viewModel = RichTextViewModel()


    @Environment(\.presentationMode) var presentationMode
    @Binding var letters: [Letter]

    init(letters: Binding<[Letter]>, isNewLetter: Bool = true) {
        self._letters = letters
        self._categories = State(initialValue: CategoryManager.loadCategories())
        self._isNewLetter = State(initialValue: isNewLetter)
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 5){
                    floatingInputField(title: "Title", text: $title)
                    floatingInputField(title: "Recipient", text: $recipient)
                    categorySelector()
                }
                .padding(.horizontal)
                
                // 🔹 Rich Text Editor for Letter
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(radius: 3)
                        .padding(.horizontal)

                    RichTextEditor(
                        text: Binding(
                            get: { viewModel.content },
                            set: { newValue in viewModel.content = NSMutableAttributedString(attributedString: newValue) }
                        ),
                        selectedFont: $selectedFont,
                        fontSize: Binding<CGFloat>(
                            get: { CGFloat(fontSize) },
                            set: { fontSize = Double($0) }
                        ),
                        textColor: Binding<UIColor>(
                            get: { UIColor(textColor) },
                            set: { textColor = Color($0) }
                        ),
                        bgColor: Binding<UIColor>(
                            get: { UIColor(bgColor) },
                            set: { bgColor = Color($0) }
                        ),
                        isBold: $isBold,
                        isItalic: $isItalic,
                        isUnderlined: $isUnderlined
                    )
                    .onChange(of: content) { _ in
                        print("Updated text: \(content.string)")
                    }
                    .padding(12)
                }
                .frame(minHeight: 300, maxHeight: .infinity)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                

                HStack(spacing: 40) {
                    Button(action: { showFormattingMenu.toggle() }) {
                        Image(systemName: "textformat.size")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .popover(isPresented: $showFormattingMenu) {
                        FormattingMenu(isBold: $isBold, isItalic: $isItalic, isUnderlined: $isUnderlined, selectedFont: $selectedFont, fontSize: $fontSize, textColor: $textColor, bgColor: $bgColor)
                            .frame(width: 300, height: 350)
                    }
                    
                    // 🔹 Additional Toolbar for Templates & Attachments
                    HStack {
                        Button(action: { showTemplatePicker.toggle() }) {
                            Image(systemName: "doc.text.image")
                                .font(.title2)
                                .foregroundColor(.purple)
                        }
                        .sheet(isPresented: $showTemplatePicker) {
                            TemplatePicker()
                        }
                        
//
                        Button(action: { showAddOptions.toggle() }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .confirmationDialog("Insert", isPresented: $showAddOptions, titleVisibility: .visible) {
                            Button("Image") { /* Handle Image Upload */ }
                            Button("Audio File") { /* Handle Audio Upload */ }
                            Button("Camera") { /* Handle Camera Capture */ }
                            Button("Voice Recording") { /* Handle Voice Recording */ }
                            Button("Emojis") { showEmojiPicker = true }
                            Button("Stickers") { /* Handle Stickers */ }
                            Button("Cancel", role: .cancel) { }
                        }
                        .sheet(isPresented: $showEmojiPicker) {
                            EmojiPickerView { emoji in
                                insertEmoji(emoji)
                                showEmojiPicker = false
                            }
                        }


                    }
                    .padding()
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(16)
                    .shadow(radius: 5)
                }
                .frame(maxHeight: .infinity)
            }
            .navigationTitle("New Letter")
            .navigationBarItems(trailing: Button("Save") {
                saveLetter()
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                if isNewLetter {
                    resetLetter()
                }
                else{
                    loadLastSavedLetter()
                }
            }
        }
    }
    
    private func insertEmoji(_ emoji: String) {
        let mutableAttrString = NSMutableAttributedString(attributedString: viewModel.content)
        mutableAttrString.append(NSAttributedString(string: emoji))
        DispatchQueue.main.async {
            self.viewModel.content = mutableAttrString
        }
    }


    private func autoSaveLetter() {
        let letter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory, content: content.string)
            FileManagerHelper.saveLetters([letter])
        }
    
    private func saveLetter() {
        let plainText = content.string

        let newLetter = Letter(title: title, recipient: recipient, date: getCurrentDate(), category: selectedCategory, content: plainText)
        letters.append(newLetter)
        FileManagerHelper.saveLetters(letters)
    }

    private func resetLetter() {
            title = ""
            recipient = ""
            content = NSAttributedString(string: "")
            selectedCategory = ""
        }

    private func loadLastSavedLetter() {
            if let savedLetter = FileManagerHelper.loadLetters().last {
                title = savedLetter.title
                recipient = savedLetter.recipient
                content = NSAttributedString(string: savedLetter.content)
                selectedCategory = savedLetter.category
            }
        }


    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

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
                        saveCategory()
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private func saveCategory() {
        let trimmedCategory = selectedCategory.trimmingCharacters(in: .whitespacesAndNewlines)
        if !categories.contains(where: { $0.lowercased() == trimmedCategory.lowercased() }) {
            categories.append(trimmedCategory)
            CategoryManager.saveCategories(categories)
        }
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


struct FontPicker: View {
    @Binding var selectedFont: String

    let allFonts = UIFont.familyNames.sorted()

    var body: some View {
        NavigationView {
            List(allFonts, id: \.self) { font in
                Button(action: { selectedFont = font }) {
                    Text(font)
                        .font(.custom(font, size: 18))
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Select Font")
        }
    }
}


@ViewBuilder
private func floatingInputField(title: String, text: Binding<String>) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .font(.caption)
            .foregroundColor(.gray)

        TextField("", text: text)
            .padding(.vertical, 10)
            .foregroundColor(.primary)
            .background(Color.clear)
            .overlay(Rectangle().frame(height: 1).foregroundColor(.gray).opacity(0.7), alignment: .bottom)
    }
    .padding(.horizontal)
}

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
    @Environment(\.dismiss) private var dismiss
    
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

            Button("Close") {dismiss()}
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

// MARK: - Formatting Menu
struct FormattingMenu: View {
    @Binding var isBold: Bool
    @Binding var isItalic: Bool
    @Binding var isUnderlined: Bool
    @Binding var selectedFont: String
    @Binding var fontSize: Double
    @Binding var textColor: Color
    @Binding var bgColor: Color
    @Environment(\.dismiss) private var dismiss
    
    let allFonts = UIFont.familyNames.sorted()

    var body: some View {
        VStack(spacing: 20) {
            Text("Text Formatting")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: { isBold.toggle() }) {
                        Image(systemName: "bold")
                            .font(.title2)
                            .foregroundColor(isBold ? .blue : .gray)
                    }

                    Button(action: { isItalic.toggle() }) {
                        Image(systemName: "italic")
                            .font(.title2)
                            .foregroundColor(isItalic ? .blue : .gray)
                    }

                    Button(action: { isUnderlined.toggle() }) {
                        Image(systemName: "underline")
                            .font(.title2)
                            .foregroundColor(isUnderlined ? .blue : .gray)
                    }
                }
                .padding()
            
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
                dismiss()
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

struct EmojiPickerView: View {
    let allEmojis = fetchAllEmojis()  // Fetch all iOS emojis
    var onEmojiSelected: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 10) {
                    ForEach(allEmojis, id: \.self) { emoji in
                        Button(action: {
                            onEmojiSelected(emoji)
                            dismiss()
                        }) {
                            Text(emoji)
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Emoji")
            .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
    }
}


func fetchAllEmojis() -> [String] {
    let emojiRanges: [(Int, Int)] = [
        (0x1F600, 0x1F64F), // Emoticons 😀😃😄😁
        (0x1F300, 0x1F5FF), // Misc Symbols and Pictographs 🌍🌎🌏
        (0x1F680, 0x1F6FF), // Transport and Map Symbols 🚗🚕🚙
        (0x2600, 0x26FF),   // Miscellaneous Symbols ☀️☁️☂️
        (0x2700, 0x27BF),   // Dingbats ✂️✉️☎️
        (0xFE00, 0xFE0F),   // Variation Selectors
        (0x1F900, 0x1F9FF)  // Supplemental Symbols and Pictographs 🤩🤯🥳
    ]

    var emojis: [String] = []

    for range in emojiRanges {
        for unicode in range.0...range.1 {
            if let scalar = UnicodeScalar(unicode) {
                emojis.append(String(scalar))
            }
        }
    }
    return emojis
}


#Preview{
    NewLetterView(letters: .constant([]))
    
}
