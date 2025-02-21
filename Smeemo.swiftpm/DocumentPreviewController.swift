//
//  File.swift
//  Smeemo
//
//  Created by Khushi Rana on 21/02/25.
//

import SwiftUI
import QuickLook

struct DocumentPreviewController: UIViewControllerRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.delegate = context.coordinator
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        var parent: DocumentPreviewController

        init(_ parent: DocumentPreviewController) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as NSURL
        }
    }
}


import Foundation

struct IdentifiableURL: Identifiable {
    let id = UUID() // Required for Identifiable
    let url: URL
}
