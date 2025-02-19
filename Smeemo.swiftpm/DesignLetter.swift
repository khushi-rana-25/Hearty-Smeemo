import SwiftUI

struct DesignLetter: View {
    @Environment(\.dismiss) var dismiss
    @State private var letterTitle: String = ""
    @State private var showTemplates = false
    @State private var showFontOptions = false
    
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderline = false
    @State private var selectedFont = "SF Pro"
    @State private var fontSize: Double = 13
    @State private var textColor = Color.black
    @State private var fillColor = Color.white

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                TextField("Enter title", text: $letterTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(width: 250)

                Spacer()

                HStack(spacing: 15) {
                    Menu {
                        Button(action: { print("Image selected") }) {
                            Label("Image", systemImage: "photo")
                        }
                        Button(action: { print("Voice Recording selected") }) {
                            Label("Voice Recording", systemImage: "mic")
                        }
                        Button(action: { print("Camera selected") }) {
                            Label("Camera", systemImage: "camera")
                        }
                        Button(action: { print("Audio File selected") }) {
                            Label("Audio File", systemImage: "music.note")
                        }
                        Button(action: { print("Stickers selected") }) {
                            Label("Stickers", systemImage: "moonphase.waxing.crescent")
                        }
                        Button(action: { print("Draw selected") }) {
                            Label("Draw", systemImage: "pencil.and.outline")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    Menu {
                        Button(action: { exportAsPDF() }) {
                            Label("PDF", systemImage: "doc.richtext")
                        }
                        Button(action: { exportAsPNG() }) {
                            Label("PNG", systemImage: "photo")
                        }
                        Button(action: { exportAsCard() }) {
                            Label("Card", systemImage: "creditcard")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill") // Share icon
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())

                    
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()

            // MARK: - Toolbar Section
            HStack {
                Button(action: { showFontOptions.toggle() }) {
                    Text("Aa")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.leading, 50)
                }
                .popover(isPresented: $showFontOptions, attachmentAnchor: .point(.bottomLeading), arrowEdge: .bottom, content: {
                    VStack {
                        HStack(spacing: 15) {
                            Button(action: { isBold.toggle() }) {
                                Image(systemName: "bold")
                                    .foregroundColor(isBold ? .blue : .black)
                            }
                            Button(action: { isItalic.toggle() }) {
                                Image(systemName: "italic")
                                    .foregroundColor(isItalic ? .blue : .black)
                            }
                            Button(action: { isUnderline.toggle() }) {
                                Image(systemName: "underline")
                                    .foregroundColor(isUnderline ? .blue : .black)
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        // Font Picker
                        Picker("Font", selection: $selectedFont) {
                            Text("SF Pro").tag("SF Pro")
                            Text("Arial").tag("Arial")
                            Text("Times New Roman").tag("Times New Roman")
                        }
                        .padding()
                        
                        Stepper("Size: \(Int(fontSize)) pt", value: $fontSize, in: 10...50, step: 1)
                            .padding()
                        
                        ColorPicker("Text Color", selection: $textColor)
                            .padding()
                        ColorPicker("Fill Color", selection: $fillColor)
                            .padding()
                    }
                }).padding()
    
                Button(action: { showTemplates=true }) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                            .font(.title2)
                        Text("Templates")
                    }
                    .foregroundColor(.black)
                    .padding()
                }
                .sheet(isPresented: $showTemplates) {
                                    TemplatesView()
                                }

                Spacer()
            }
            .background(Color.white)

            Divider()

            // MARK: - Writing Space
            Spacer()
            Color.gray.opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

func exportAsPDF() { print("Exporting as PDF...") }
func exportAsPNG() { print("Exporting as PNG...") }
func exportAsCard() { print("Exporting as Card...") }
