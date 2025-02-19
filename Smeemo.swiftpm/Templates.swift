//
//  SwiftUIView.swift
//  Smeemo
//
//  Created by Batch - 2  on 19/02/25.
//

import SwiftUI

struct TemplatesView: View {
    let templates: [(title: String, preview: String)] = [
        ("Love Letter", "My dearest love, every moment spent with you is a treasure..."),
        ("Birthday Card", "Happy Birthday! May your year be filled with joy and laughter..."),
        ("Thank You Note", "Dear friend, I just want to take a moment to say thank you..."),
        ("Apology Letter", "I am deeply sorry for what happened. It was never my intention to hurt you..."),
        ("Congratulation Letter", "Congratulations on your achievement! You deserve all the success..."),
        ("Farewell Letter", "Saying goodbye is never easy, but I will cherish all our memories..."),
        ("Motivational Note", "You are capable of achieving great things. Believe in yourself...")
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(templates, id: \.title) { template in
                NavigationLink(destination: TemplateDetailView(title: template.title, content: template.preview)) {
                    VStack(alignment: .leading) {
                        Text(template.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(template.preview)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .padding()
                }
            }
            .navigationTitle("Templates")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct TemplateDetailView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding()
            
            ScrollView {
                Text(content)
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle(title)
    }
}

