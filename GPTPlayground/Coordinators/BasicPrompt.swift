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

struct BasicPrompt: Coordinator {

    @State private var prompt: String = ""
    var answers: IdentifiedArrayOf<BasicPromptView.Answer>
    var onCommit: @MainActor (String) -> Void
    var onAnswersDeleted: @MainActor (IndexSet) -> Void

    var entryView: some View {
        BasicPromptView(
            interface: .handled(by: handleViewInterface),
            state: .init(
                prompt: prompt,
                answers: answers
            )
        )
        .navigationTitle("Basic Prompt")
    }

    @MainActor
    private func handleViewInterface(_ action: BasicPromptView.Action) {
        switch action {
        case .didChangePrompt(let newValue):
            prompt = newValue
        case .didCommit:
            onCommit(prompt)
            prompt = ""
        case .didDeleteAnswers(let indexSet):
            onAnswersDeleted(indexSet)
        }
    }
}

extension BasicPrompt {
    enum Action {
        case didTapBasicPrompt
    }
}
