//
//  ContentView.swift
//  FlagTag!
//
//  Created by Benjamin Heflin on 10/28/22.
//

import SwiftUI

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

struct ContentView: View {
    
    @State private var alertShowingScore = false
    @State private var scoreTitle = ""
    
    @State private var alertGameEnd = false
    private let gameEndTitle = "Game Over!"
    
    @State private var correctScore = 0
    @State private var wrongScore = 0
    @State private var currentGuess = 0
    
    @State private var countries = ["Estonia",
                     "France",
                     "Germany",
                     "Ireland",
                     "Italy",
                     "Poland",
                     "Russia",
                     "Spain",
                     "UK",
                     "US" ]
        .shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 10)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .largeBlueFont()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of: ")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(correctScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            .alert(scoreTitle, isPresented: $alertShowingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text(
                """
                That was \(countries[currentGuess])!
                
                Number Correct: \(correctScore)
                Number Wrong: \(wrongScore)
                """)
            }
        }
        .alert(gameEndTitle, isPresented: $alertGameEnd) {
            Button("Ok", action: resetGame)
        } message: {
            Text(
            """
            Your final score is
            \(correctScore) Correct
            \(wrongScore) Wrong
            
            Want to play again?
            """)
        }
    }
    
    func flagTapped(_ number: Int) {
        currentGuess = number
        if currentGuess == correctAnswer {
            scoreTitle = "Correct!"
            correctScore += 1
        } else {
            scoreTitle = "Wrong!"
            wrongScore += 1
        }
        
        checkGameEnd()
        alertShowingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func checkGameEnd() {
        if correctScore + wrongScore >= 3 {
            alertGameEnd = true
        }
        else if correctScore + wrongScore > 0{
            alertShowingScore = true
        }
    }
    
    func resetGame() {
        correctScore = 0
        wrongScore = 0
        alertShowingScore = false
        scoreTitle = ""
        alertGameEnd = false
        correctScore = 0
        wrongScore = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View {
    func largeBlueFont() -> some View {
        modifier(LargeBlueFont())
    }
}

