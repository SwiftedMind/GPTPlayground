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
import GPTSwift
import KeysReader
import RegexBuilder

public class LiveCodeWriterService: CodeWriterService {

    private lazy var gptSwift = GPTSwift(apiKey: KeysReader.shared.openAIKey)

    public func send(_ prompt: String, language: String, currentCode: String?) async throws -> String {

        var messages: [CompletionRequest.Message] = [
            .init(
                role: .system,
                content:
"""
I want you to act as a code editor, helping me build a block of code. I will type commands and you will reply with the updated code. I want you to only reply with the code inside one unique code block, and nothing else. Do not write explanations. Do not apologize. Always use proper markdown to format the code block. Use the \(language) programming language. Only change existing code when I explicitly say that. Only delete existing code when I explicitly say that.
"""
            ),
            .init(role: .user, content: prompt)
        ]

        if let currentCode, !currentCode.isEmpty {
            messages.append(.init(role: .assistant, content: currentCode))
        }

        let answer = try await gptSwift.commit(messages)
        dump(answer.choices)
        let codeCapture = Reference(Substring.self)
        let regex = Regex {
            Optionally {
                "```"
            }
            Optionally {
                "swift"
            }
            Optionally {
                "\n"
            }
            Capture(as: codeCapture) {
                ZeroOrMore {
                    CharacterClass(
                        .whitespace,
                        .whitespace.inverted
                    )
                }
            }
            ChoiceOf {
                "\n```"
                "\n"
            }
        }

        if let value = answer.choices.first?.message.content,
           let match = value.firstMatch(of: regex) {
            return String(match[codeCapture])
        }

        return "ERROR"
//        throw CodeWriterServiceError.couldNotFetchAnswer
    }

}

