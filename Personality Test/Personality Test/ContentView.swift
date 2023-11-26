//
//  ContentView.swift
//  Personality Test
//
//  Created by Jasmine Andresol on 6/14/23.
//

import SwiftUI

struct MyColors {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
}

struct ContentView: View {
    @State private var selectedScores = [Question: Int]()
    @State private var isTestComplete = false
    @State private var currentQuestionIndex = 0
    
    
    //list of questions
    let questions = [
        Question(question: "I prefer to spend time with a large group of people rather than alone.", attribute: "extroversion"),
        Question(question: "I enjoy helping others and find it easy to empathize with their problems.", attribute: "agreeableness"),
        Question(question: "I tend to worry a lot and often experience anxiety.", attribute: "neuroticism"),
        Question(question: "I am organized and like to plan things ahead.", attribute: "conscientiousness"),
        Question(question: "I am open to new experiences and ideas.", attribute: "openness"),
        Question(question: "I find it energizing to be around people.", attribute: "extroversion"),
        Question(question: "I value cooperation and harmony in relationships.", attribute: "agreeableness"),
        Question(question: "I am prone to mood swings.", attribute: "neuroticism"),
        Question(question: "I pay attention to details and strive for perfection.", attribute: "conscientiousness"),
        Question(question: "I enjoy trying new activities and exploring different perspectives.", attribute: "openness"),
        Question(question: "I am comfortable in social situations and enjoy meeting new people.", attribute: "extroversion"),
        Question(question: "I prioritize the needs of others and enjoy helping them succeed.", attribute: "agreeableness"),
        Question(question: "I am easily stressed and often feel overwhelmed.", attribute: "neuroticism"),
        Question(question: "I am disciplined and follow a structured routine.", attribute: "conscientiousness"),
        Question(question: "I have a vivid imagination and enjoy creative endeavors.", attribute: "openness"),
        Question(question: "I feel energized by social interactions and being the center of attention.", attribute: "extroversion"),
        Question(question: "I value harmony and avoid conflicts as much as possible.", attribute: "agreeableness"),
        Question(question: "I am prone to worry and often anticipate negative outcomes.", attribute: "neuroticism"),
        Question(question: "I like to keep my environment neat and organized.", attribute: "conscientiousness"),
        Question(question: "I enjoy exploring new ideas and challenging traditional beliefs.", attribute: "openness"),
        Question(question: "I find it draining to be in large social gatherings for extended periods.", attribute: "extroversion"),
        Question(question: "I prioritize the needs of others over my own.", attribute: "agreeableness"),
        Question(question: "I am sensitive to criticism and easily get hurt.", attribute: "neuroticism"),
        Question(question: "I follow a set schedule and dislike last-minute changes.", attribute: "conscientiousness"),
        Question(question: "I am curious and always seek new knowledge and experiences.", attribute: "openness")
    ]
    
    //making sure the sequence  prints in order i.e. SCUAI not ACISU
    let attributeOrder = ["extroversion", "neuroticism", "conscientiousness", "agreeableness", "openness"]
    
    var body: some View {
        VStack {
            // Title
            Text("Big 5 Test")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(MyColors.primary)
            
            // Scrollable
            ScrollView {
                VStack {
                    // End screen
                    if isTestComplete {
                        Text("Test Complete")
                            .font(.title)
                            .padding()
                        Text("Personality Result: \(generatePersonalityResult())")
                            .font(.title)
                            .padding()
                        
                        Button(action: {
                            restartTest()
                        }) {
                            Text("Restart Test")
                        }
                        .buttonStyle(CustomButtonStyle(question: questions[currentQuestionIndex], score: 4, selectedScores: selectedScores))
                        .padding()
                    } else if currentQuestionIndex == questions.count - 1 {
                        VStack {
                            Text(questions[currentQuestionIndex].question)
                                .font(.title)
                                .padding()
                            
                            Slider(value: Binding(
                                get: { Double(selectedScores[questions[currentQuestionIndex]] ?? 0) },
                                set: { selectedScores[questions[currentQuestionIndex]] = Int($0) }
                            ), in: 1...4)
                            .padding()
                            
                            HStack {
                                Button(action: {
                                    navigateToPreviousQuestion()
                                }) {
                                    Text("Previous")
                                }
                                .disabled(currentQuestionIndex == 0)
                                .buttonStyle(CustomButtonStyle(question: questions[currentQuestionIndex], score: 1, selectedScores: selectedScores))
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedScores[questions[currentQuestionIndex]] = 1 // Set a default score if the user doesn't move the slider
                                    isTestComplete = true
                                }) {
                                    Text("Finish")
                                }
                                .buttonStyle(CustomButtonStyle(question: questions[currentQuestionIndex], score: 4, selectedScores: selectedScores))
                            }
                            .padding()
                        }
                        .padding()
                        .onChange(of: selectedScores[questions[currentQuestionIndex]]) { score in
                            if score != nil {
                                isTestComplete = true
                            }
                        }
                    } else {
                        
                        VStack {
                            Text(questions[currentQuestionIndex].question)
                                .font(.title)
                                .padding()
                            
                            HStack {
                                Text("Disagree")
                                Spacer()
                                Text("Agree")
                            }
                            .padding(.horizontal)
                            
                            Slider(value: Binding(
                                get: { Double(selectedScores[questions[currentQuestionIndex]] ?? 0) },
                                set: { selectedScores[questions[currentQuestionIndex]] = Int($0) }
                            ), in: 1...4)
                            .padding()
                            
                            HStack {
                                Button(action: {
                                    navigateToPreviousQuestion()
                                }) {
                                    Text("Previous")
                                }
                                .disabled(currentQuestionIndex == 0)
                                .buttonStyle(CustomButtonStyle(question: questions[currentQuestionIndex], score: 1, selectedScores: selectedScores))
                                
                                Spacer()
                                
                                Button(action: {
                                    navigateToNextQuestion()
                                }) {
                                    Text("Next")
                                }
                                .disabled(currentQuestionIndex == questions.count - 1)
                                .buttonStyle(CustomButtonStyle(question: questions[currentQuestionIndex], score: 4, selectedScores: selectedScores))
                            }
                            .padding()
                        }
                        .padding()
                    }
                }
                .padding()
            }
            
            // Progress Bar
            ProgressBar(progress: CGFloat(selectedScores.count) / CGFloat(questions.count))
                .frame(height: 8)
                .padding()
        }
    }
    
    func answerQuestion(score: Int, forQuestion question: Question) {
        selectedScores[question] = score
        
        if selectedScores.count >= questions.count {
            isTestComplete = true
        }
    }
    
    func navigateToPreviousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func navigateToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            if selectedScores[questions[currentQuestionIndex]] == nil {
                selectedScores[questions[currentQuestionIndex]] = 1
            }
            currentQuestionIndex += 1
        } else {
            isTestComplete = true
        }
    }
    
    func restartTest() {
        selectedScores = [Question: Int]()
        isTestComplete = false
        currentQuestionIndex = 0
    }
    
    func generatePersonalityResult() -> String {
        let mappings = [
            "extroversion": ["high": "S", "low": "R"],
            "neuroticism": ["high": "L", "low": "C"],
            "conscientiousness": ["high": "O", "low": "U"],
            "agreeableness": ["high": "A", "low": "E"],
            "openness": ["high": "I", "low": "N"]
        ]
        
        var attributeScores = [String: Int]()
        
        for question in questions {
            if let score = selectedScores[question] {
                let attribute = question.attribute
                attributeScores[attribute] = (attributeScores[attribute] ?? 0) + score
            }
        }
        
        var sequence = ""
        for attribute in attributeOrder {
            if let mapping = mappings[attribute], let score = attributeScores[attribute] {
                if score > 10 {
                    sequence += mapping["high"]!
                } else {
                    sequence += mapping["low"]!
                }
            }
        }
        
        return sequence
    }
    
    struct Question: Identifiable, Hashable {
        let id = UUID()
        let question: String
        let attribute: String
    }
    
    struct CustomButtonStyle: ButtonStyle {
        let question: Question
        let score: Int
        let selectedScores: [Question: Int]
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.title)
                .padding()
                .background(buttonBackgroundColor(forQuestion: question, score: score, isPressed: configuration.isPressed))
                .foregroundColor(MyColors.primary)
                .cornerRadius(10)
        }
        
        func buttonBackgroundColor(forQuestion question: Question, score: Int, isPressed: Bool) -> Color {
            if let selectedScore = selectedScores[question], selectedScore == score {
                return isPressed ? MyColors.accent.opacity(0.8) : MyColors.accent
            } else {
                return isPressed ? MyColors.accent.opacity(0.8) : MyColors.secondary
            }
        }
    }
    
}

struct ProgressBar: View {
    @State private var alignment = HorizontalAlignment.leading
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(MyColors.secondary)
                
                Rectangle()
                    .frame(width: min(progress * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(MyColors.accent)
                    .animation(.linear)
            }
        }
    }
}
