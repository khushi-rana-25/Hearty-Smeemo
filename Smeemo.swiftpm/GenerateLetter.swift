//
//  SwiftUIView.swift
//  Smeemo
//
//  Created by Batch - 2  on 18/02/25.
//

import SwiftUI

struct GenerateLetter: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("This is the Generate Letter Page")
                .font(.largeTitle)
                .padding()

            Button("Go Back") {
                dismiss() // Dismiss when using fullScreenCover
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Generate Letter")
    }
}

#Preview {
    GenerateLetter()
}
 
