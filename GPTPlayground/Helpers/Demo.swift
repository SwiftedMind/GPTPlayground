//
//  Copyright © 2023 Dennis Müller and all collaborators
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import GPTSwift

func askChatGPT() async throws {
    let gptSwift = GPTSwift(apiKey: "YOUR_API_KEY")

    // Basic query
    let firstResponse = try await gptSwift.askChatGPT("What is the answer to life, the universe and everything in it?")
    print(firstResponse.choices.map(\.message))

    // Send multiple messages
    let secondResponse = try await gptSwift.askChatGPT(
        messages: [
            ChatMessage(role: .system, content: "You are a dog."),
            ChatMessage(role: .user, content: "Do you actually like playing fetch?")
        ]
    )
    print(secondResponse.choices.map(\.message))

    // Full control
    var fullRequest = ChatRequest(
        messages: [
            .init(role: .system, content: "You are the pilot of an alien UFO. Be creative."),
            .init(role: .user, content: "Where do you come from?")
        ]
    )
    fullRequest.temperature = 0.8
    fullRequest.numberOfAnswers = 2

    let thirdResponse = try await gptSwift.askChatGPT(request: fullRequest)
    print(thirdResponse.choices.map(\.message))
}
