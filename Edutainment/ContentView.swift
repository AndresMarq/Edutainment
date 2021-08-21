//
//  ContentView.swift
//  Edutainment
//
//  Created by Andres on 2021-06-25.
//

import SwiftUI

struct Question {
    var text: String
    var answer: String
}

struct ContentView: View {
    //Desired table to practice
    @State private var tableNumber = 5
    //Option number of questions
    @State private var amountQuestions = ["5", "10", "20", "All"]
    //Selected option within previous array
    @State private var questionNumber = 0
    //Array of actual questions to be asked
    @State private var questions: [Question] = []
    //Keeps track of which question is currently being asked
    @State private var questionCount = 0
    //false if asking for setting, true if game active
    @State private var gameStatus = false
    //stores user reponse
    @State private var userAnswer = ""
    //Stores user score
    @State private var score = 0
    
    //Actives alert after each response
    @State private var alertStatus = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var buttonAnimationAmount = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                AngularGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.white]), center: .top).ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Section(header: Text("Which table would you like to practice?")) {
                        Stepper(value: $tableNumber, in: 1...12) {
                            ZStack {
                                Circle()
                                    .frame(width: CGFloat(tableNumber) * 15, height: CGFloat(tableNumber) * 15)
                                    .foregroundColor(.red)
                                Text("\(tableNumber)")
                            }
                            .animation(.easeIn)
                        }
                    }.padding(5)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    Spacer()
                    Group {
                        Text("How many questions would you like?")
                         
                        Picker(selection: $questionNumber, label: EmptyView()) {
                            ForEach(0..<4) {
                                Text("\(amountQuestions[$0])")
                            }
                           
                        }
                    }
                    .padding(.top, 0)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    Spacer()
                    
                    if gameStatus == false {
                        Button("Start!") {
                            withAnimation {
                                self.buttonAnimationAmount += 360
                            }
                            startGame()
                            gameStatus = true
                        }
                        .padding(5)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .clipShape(Rectangle())
                        .rotation3DEffect(
                            .degrees(buttonAnimationAmount),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        Spacer()
                    }
                    
                    if gameStatus == true {
                        Text("\(questions[questionCount].text)")
                        TextField("Enter your answer", text: $userAnswer)
                        Button("Submit!") {
                            withAnimation {
                                self.buttonAnimationAmount += 360
                            }
                            evaluate()
                            next()
                        } .padding(5)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .clipShape(Rectangle())
                        .rotation3DEffect(
                            .degrees(buttonAnimationAmount),
                            axis: (x: 1, y: 1, z: 0)
                        )
                        
                        Text("Your score is: \(score)")
                            .alert(isPresented: $alertStatus, content: {
                                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("OK")))
                            })
                        Button("Reset") {
                            withAnimation {
                                buttonAnimationAmount += 360
                            }
                            reset()
                        }
                        .padding(5)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .clipShape(Rectangle())
                        .rotation3DEffect(
                            .degrees(buttonAnimationAmount),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    }
                }
                .navigationBarTitle("Multiply!")
                .navigationViewStyle(StackNavigationViewStyle())
                Spacer()
            }
            
        }
    }
    //This function creates all questions in an array of Questions struct
    func startGame() {
        let numberOfQuestions = Int(amountQuestions[questionNumber]) ?? 25
        let count = 1...numberOfQuestions
        for _ in count {
            let tempNumber = Int.random(in: 1...100)
            let tempResult = String(tableNumber * tempNumber)
            let tempQuestion = Question(text: "What is \(tableNumber) * \(tempNumber)?", answer: "\(tempResult)")
            questions.append(tempQuestion)
        }
        let finalState = Question(text: "Game completed", answer: "none")
        questions.append(finalState)
    }
    
    //This function checks userAnswer
    func evaluate() {
        if userAnswer == questions[questionCount].answer {
            score += 1
            alertTitle = "Good Job!"
            alertMessage = "Your score is now: \(score)"
            alertStatus = true
        } else {
            alertTitle = "Not that one, but keep trying!"
            alertMessage = "The correct answer was \(questions[questionCount].answer)"
            alertStatus = true
        }
    }
    
    //Provides next questions
    func next() {
        let tempTotalQuestions = Int(amountQuestions[questionNumber]) ?? 25
        if questionCount < (tempTotalQuestions - 1) {
            questionCount += 1
        } else if questionCount == (tempTotalQuestions - 1) {
            questionCount += 1
            alertTitle = "Great Job!"
            alertMessage = "Your Final Score was: \(score)"
            alertStatus = true
            //if I add reset() here I don't get the alert anymore
        }
        else {
            reset()
        }
    }
    
    func reset() {
        gameStatus = false
        alertStatus = false
        questions = []
        score = 0
        userAnswer = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
