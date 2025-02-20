//
//  SwiftUIView.swift
//  Smeemo
//
//  Created by Khushi Rana on 20/02/25.
//

import SwiftUI

struct LockedLettersView: View {
    @State private var isUnlocked = false
    @State private var enteredPin = ""
    let correctPin = "1234" // ✅ Change this later

    @Binding var letters: [Letter]

    var body: some View {
        NavigationView {
            if isUnlocked {
                List {
                    ForEach(letters.filter { $0.isLocked }) { letter in
                        LetterCardView(letter: .constant(letter), letters: $letters)
                    }
                }
                .navigationTitle("Locked Letters")
            } else {
                VStack {
                    Text("Enter Your PIN:")
                        .font(.title2)
                        .padding()

                    SecureField("PIN", text: $enteredPin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)

                    Button(action: unlockLetters) {
                        Text("Unlock")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }

    private func unlockLetters() {
        if enteredPin == correctPin {
            isUnlocked = true
        } else {
            enteredPin = ""
        }
    }
}


#Preview {
    LockedLettersView(letters: .constant([]))
}
