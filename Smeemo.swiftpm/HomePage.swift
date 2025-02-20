//
//  HomePage.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import SwiftUI

struct HomePage: View {
    @State private var letters: [Letter] = FileManagerHelper.loadLetters()
    
    var body: some View {
        TabView {
            HomeView(letters: $letters) // Letters Repository
                .tabItem {
                    Image(systemName: "tray.full")
                    Text("Letters Repo")
                }
            
            NewLetterView(letters: $letters) // Letter Editor
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("New Letter")
                }
            
            LockedLettersView(letters: $letters) // Locked Letters
                .tabItem {
                    Image(systemName: "lock.fill")
                    Text("Locked Letters")
                }
        }
    }
}


#Preview {
    HomePage()
}
