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
import Puddles
import IdentifiedCollections
import BasicPromptService

struct BasicPromptAnswerProvider: Provider {
    @Service private var service: BasicPromptService = .live

    @State private var answers: IdentifiedArrayOf<BasicPromptView.Answer> = []
    @State private var previousConversation: [(question: String, answer: String)] = []

    var entryView: some View {
        BasicPrompt(
            providerInterface: .consume(handleProviderInterface),
            answers: answers
        )
    }

    @MainActor
    private func handleProviderInterface(_ action: BasicPrompt.ProviderAction) {
        switch action {
        case let .commit(prompt):
            commit(prompt)
        case let .deleteAnswers(offsets):
            deleteAnswers(atOffsets: offsets)
        case .undo:
            undo()
        case .reset:
            reset()
        }
    }

    private func commit(_ prompt: String) {
        Task {
            let answer = BasicPromptView.Answer(prompt: prompt, value: .loading)
            do {
                answers.insert(answer, at: 0)
                var fullAnswer = ""
                for try await word in try await service.send(prompt, previousConversation: previousConversation) {
                    fullAnswer += word
                    answers[id: answer.id]?.value = .loaded(fullAnswer)
                }

                if answers[id: answer.id]?.value.isLoading == true {
                    answers[id: answer.id]?.value = .failure(.mock)
                    return
                }

                previousConversation.insert((prompt, fullAnswer), at: 0)
            } catch {
                answers[id: answer.id]?.value = .failure(error)
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }

    private func deleteAnswers(atOffsets indexSet: IndexSet) {
        answers.remove(atOffsets: indexSet)
    }

    private func reset() {
        previousConversation.removeAll()
        answers.removeAll()
    }

    private func undo() {
        previousConversation.removeFirst()
        answers.removeFirst()
    }
}
