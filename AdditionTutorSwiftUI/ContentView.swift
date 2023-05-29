//
//  ContentView.swift
//  AdditionTutorSwiftUI
//
//  Created by Lori Rothermel on 5/28/23.
//

import SwiftUI
import AVFAudio


struct ContentView: View {
    @State private var firstNumber: Int = 0
    @State private var secondNumber: Int = 0
    @State private var firstNumberEmojis: String = ""
    @State private var secondNumberEmojis: String = ""
    @State private var answer: String = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var guessButtonDisabled = false
    @State private var message = ""
    
    
    @FocusState private var textFieldIsFocused: Bool
    
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶",
                  "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟",
                  "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                Text("+")
                Text(secondNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }  // Group
                       
            Spacer()
                        
            Text("\(firstNumber) + \(secondNumber) = ")
                .font(.largeTitle)
            
            TextField("", text: $answer)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .font(.largeTitle)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }  // .overlay
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess") {
                textFieldIsFocused = false
                
                let result = firstNumber + secondNumber
                
                if let answerValue = Int(answer) {
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "No! the correct answer is \(firstNumber + secondNumber)."
                    }  // if...else
                } else {
                    playSound(soundName: "wrong")
                    message = "No! the correct answer is \(firstNumber + secondNumber)."
                }  // if let...else
                textFieldIsDisabled = true
                guessButtonDisabled = true
            }  // Button
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || guessButtonDisabled)
          
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(message == "Correct!" ? .green : .red)
            
            
            if guessButtonDisabled {
                Button("Play Again?") {
                    guessButtonDisabled = false
                    answer = ""
                    textFieldIsDisabled = false
                    message = ""
                    generateNewEquation()
                }
                .buttonStyle(.borderedProminent)
            }
        }  // VStack
        .padding()
        .onAppear {
            generateNewEquation()
        }  // .onAppear

    }  // some View
    
    
    func generateNewEquation() {
        firstNumber = Int.random(in: 1...25)
        secondNumber = Int.random(in: 1...25)
        firstNumberEmojis = String(repeating: emojis.randomElement() ?? "❗️", count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement() ?? "❗️", count: secondNumber)
    }
    
    
    
    func playSound(soundName: String) {
        
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("❗️ Could not read file named \(soundName)")
            return
        }  // guard let
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("❗️ ERROR: \(error.localizedDescription)")
        }  // do...catch
        
    }  // playSound
    
    
}  // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
