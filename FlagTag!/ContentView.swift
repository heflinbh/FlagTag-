//
//  ContentView.swift
//  FlagTag!
//
//  Created by Benjamin Heflin on 10/28/22.
//

import SwiftUI

struct ContentView: View {
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var correctScore = 0
    @State private var wrongScore = 0

    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var selectedFlag = -1

    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]

    var body: some View {
        ZStack {
            
            appBackground()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                                .animation(.default, value: selectedFlag)
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
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("""
                Correct: \(correctScore)
                Wrong: \(wrongScore)
                """)
        }
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(correctScore)")
        }
    }

    func flagTapped(_ number: Int) {
        selectedFlag = number

        if number == correctAnswer {
            scoreTitle = "Correct"
            correctScore += 1
        } else {
            wrongScore += 1
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]

            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That's the flag of the \(theirAnswer)."
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)."
            }
        }

        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }

    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }

    func newGame() {
        questionCounter = 0
        correctScore = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func appBackground() -> some View {
        
        RadialGradient(stops: [
            .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
            .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
        ], center: .top, startRadius: 200, endRadius: 700)
        .ignoresSafeArea()
    }
}

