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

struct BasicPrompt: Provider {

    @State private var prompt: String = ""

    var dataInterface: Interface<DataAction>
    var answers: IdentifiedArrayOf<BasicPromptView.Answer>

    var entryView: some View {
        BasicPromptView(
            interface: .consume(handleViewInterface),
            state: .init(
                prompt: prompt,
                answers: answers
            )
        )
        .navigationTitle("Basic Prompt")
        .toolbar { toolbarContent }
    }

    func applyStateConfiguration(_ configuration: StateConfiguration) {

    }

    @MainActor
    private func handleViewInterface(_ action: BasicPromptView.Action) {
        switch action {
        case .didChangePrompt(let newValue):
            prompt = newValue
        case .didCommit:
            dataInterface.fire(.commit(prompt: prompt))
            prompt = ""
        case .didDeleteAnswers(let indexSet):
            dataInterface.fire(.deleteAnswers(offsets: indexSet))
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder @MainActor
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                dataInterface.fire(.undo)
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
            }
            .disabled(answers.isEmpty)
            Button {
                dataInterface.fire(.reset)
            } label: {
                Image(systemName: "xmark.circle")
            }
            .disabled(answers.isEmpty)
        }
    }
}

extension BasicPrompt {

    enum StateConfiguration {
        case reset
    }

    enum Action {
        case didTapBasicPrompt
    }

    enum DataAction: Hashable {
        case commit(prompt: String)
        case undo
        case reset
        case deleteAnswers(offsets: IndexSet)
    }
}
