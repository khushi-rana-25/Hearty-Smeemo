
import SwiftUI
import UIKit

struct RichTextEditor: UIViewRepresentable {
    @Binding var text: NSAttributedString
    @Binding var selectedFont: String
    @Binding var fontSize: CGFloat
    @Binding var textColor: UIColor
    @Binding var bgColor: UIColor
    @Binding var isBold: Bool
    @Binding var isItalic: Bool
    @Binding var isUnderlined: Bool

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.textColor = textColor
        textView.attributedText = text
        textView.isUserInteractionEnabled = true
        textView.allowsEditingTextAttributes = true
        textView.layer.cornerRadius = 16
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: selectedFont, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: textColor,
            .backgroundColor: bgColor,
            .underlineStyle: isUnderlined ? NSUnderlineStyle.single.rawValue : 0
        ]
        
        let updatedText = NSMutableAttributedString(string: uiView.text, attributes: attributes)
        uiView.attributedText = updatedText
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.attributedText
        }
    }
}
