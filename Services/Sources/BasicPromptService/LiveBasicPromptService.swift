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

import SwiftUI
import ChatGPT
import KeysReader

public class LiveBasicPromptService: BasicPromptService {

    private lazy var gptSwift = ChatGPT(apiKey: KeysReader.shared.openAIKey)

    public func send(_ prompt: String, previousConversation: [(question: String, answer: String)]) async throws -> AsyncThrowingStream<String, Error> {

        var answer = ""
        for try await nextWord in try await gptSwift.streamedAnswer.ask("Tell me a story about birds") {
            answer += nextWord
        }

        let instructionMessage = ChatMessage(role: .system, content: "I want you to be a helpful, generic chat companion. Answer concise and focused, do not add any personal flavor. Stay topical and only answer the question.")
        let pastConversationMessages = previousConversation.flatMap { [ChatMessage(role: .user, content: $0.question), ChatMessage(role: .assistant, content: $0.answer)] }
        let newPromptMessage = ChatMessage(role: .user, content: prompt)
        return try await gptSwift.streamedAnswer.ask(messages: [instructionMessage] + pastConversationMessages + [newPromptMessage])
    }
}
