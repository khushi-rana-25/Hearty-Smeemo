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
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 16) // Apply corner radius to the row background
                                        .fill(Color.white)
                                        .shadow(radius: 2) // Optional: Add shadow for depth
                                        .padding(.vertical, 8) // Add some spacing between rows
                                )
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                        }
                        
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // Use inset grouped style for better appearance
            .navigationTitle("Letters Repo")
            .background(
                RoundedRectangle(cornerRadius: 16) // Apply corner radius to the List background
                    .fill(Color.white)
                    .shadow(radius: 2) // Optional: Add shadow for depth
            )
        }
    }
}
