////
////  HomeView.swift
////  Smeemo
////
////  Created by Khushi Rana on 20/02/25.
////
//
//import SwiftUI
//
//struct HomeView: View {
//    @Binding var letters: [Letter]
//    
//    // Group letters by category
//    var groupedLetters: [String: [Letter]] {
//        Dictionary(grouping: letters.filter { !$0.isLocked }, by: { $0.category })
//    }
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(groupedLetters.keys.sorted(), id: \.self) { category in
//                    Section(header: Text(category).font(.headline)) {
//                        ForEach(groupedLetters[category] ?? []) { letter in
//                            LetterCardView(letter: .constant(letter), letters: $letters)
//                                .listRowBackground(
//                                    RoundedRectangle(cornerRadius: 16) // Apply corner radius to the row background
//                                        .fill(Color.white)
//                                        .shadow(radius: 2) // Optional: Add shadow for depth
//                                        .padding(.vertical, 8) // Add some spacing between rows
//                                )
//                                .listRowSeparator(.hidden)
//                                .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
//                        }
//                        
//                    }
//                }
//            }
//            .listStyle(InsetGroupedListStyle()) // Use inset grouped style for better appearance
//            .navigationTitle("Letters Repo")
//            .background(
//                RoundedRectangle(cornerRadius: 16) // Apply corner radius to the List background
//                    .fill(Color.white)
//                    .shadow(radius: 2) // Optional: Add shadow for depth
//            )
//        }
//    }
//}


import SwiftUI

struct HomeView: View {
    @Binding var letters: [Letter]
    @State private var expandedCategories: Set<String> = [] // Track expanded categories

    // Group letters by category dynamically
    var groupedLetters: [String: [Letter]] {
        Dictionary(grouping: letters.filter { !$0.isLocked }, by: { $0.category })
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(groupedLetters.keys.sorted(), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 6) {
                            // 🔹 Category Header with Chevron
                            HStack {
                                Text(category)
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()

                                Button(action: { toggleCategory(category) }) {
                                    Image(systemName: expandedCategories.contains(category) ? "chevron.down" : "chevron.right")
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                }
                            }
                            .padding(.horizontal)

                            // 🔹 Display Only 2 Cards By Default, Expand for More
                            LazyVStack {
                                ForEach(displayedCards(for: category)) { letter in
                                    LetterCardView(letter: .constant(letter), letters: $letters)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(radius: 2)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("Letters Repo")
        }
    }

    private func toggleCategory(_ category: String) {
        if expandedCategories.contains(category) {
            expandedCategories.remove(category)
        } else {
            expandedCategories.insert(category)
        }
    }

    private func displayedCards(for category: String) -> [Letter] {
        if expandedCategories.contains(category) {
            return groupedLetters[category] ?? []
        } else {
            return Array(groupedLetters[category]?.prefix(2) ?? [])
        }
    }
}
