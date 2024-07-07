import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let type: String
}

struct ChatBotView: View {
    var model: IdentificationModel?
    @State private var messages: [ChatMessage] = []
    @State private var userQuestion: String = ""
    @State private var predefinedQuestions: [String] = [
        "How do I take care of this plant?",
        "Is this plant edible?",
        "What is the best soil for this plant?",
        "How often should I water this plant?",
        "Does this plant need direct sunlight?",
        "What temperature is ideal for this plant?"
    ]
    @State private var currentQuestions: [String] = []
    @State private var questionIndex: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                List(messages) { message in
                    VStack(alignment: .leading) {
                        if message.type == "question" {
                            Text("You: \(message.content)")
                                .bold()
                        } else {
                            Text("Bot: \(message.content)")
                        }
                    }
                }
                
                VStack {
                    ForEach(currentQuestions, id: \.self) { question in
                        Button(action: {
                            sendMessage(question)
                            updateQuestions()
                        }) {
                            Text(question)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .foregroundColor(.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                                .padding(.bottom, 5)
                        }
                    }
                    HStack {
                        TextField("Type your question here", text: $userQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            if !userQuestion.isEmpty {
                                sendMessage(userQuestion)
                                userQuestion = ""
                            }
                        }) {
                            Text("Send")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Chat with Bot", displayMode: .inline)
            .onAppear {
                updateQuestions()
            }
        }
    }
    
    func sendMessage(_ question: String) {
        guard let accessToken = model?.accessToken else {
            print("No access token found.")
            return
        }
        
        let url = URL(string: "https://plant.id/api/v3/identification/\(accessToken)/conversation")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("TzmkUH1lVPNVqK7YTNHBk8xER0tL9VquupWB4MK2I1SM3vQB6r", forHTTPHeaderField: "Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "question": question,
            "temperature": 0.5,
            "app_name": "MyAppBot"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Chat Response: \(responseString)")
                    }
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let messagesArray = responseDict["messages"] as? [[String: Any]] {
                        if let lastMessage = messagesArray.last {
                            DispatchQueue.main.async {
                                if let content = lastMessage["content"] as? String,
                                   let type = lastMessage["type"] as? String {
                                    messages.append(ChatMessage(content: question, type: "question"))
                                    messages.append(ChatMessage(content: content, type: type))
                                }
                            }
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            } else if let error = error {
                print("Error performing request: \(error)")
            }
        }.resume()
    }
    
    func updateQuestions() {
        if questionIndex < predefinedQuestions.count {
            currentQuestions = Array(predefinedQuestions[questionIndex..<min(questionIndex + 2, predefinedQuestions.count)])
            questionIndex = min(questionIndex + 2, predefinedQuestions.count)
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView(model: IdentificationModel(accessToken: "z7myxWxJwPs77hQ", result: IdentificationModel.Result(classification: IdentificationModel.Result.Classification(suggestions: []))))
    }
}
