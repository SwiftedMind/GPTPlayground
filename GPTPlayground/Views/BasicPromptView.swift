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
import PreviewDebugTools
import IdentifiedCollections

struct BasicPromptView: View {
    @FocusState private var isFocused: Bool

    var interface: Interface<Action>
    var state: ViewState

    var body: some View {
        List {
            promptSection
            answerSection
        }
        .animation(.default, value: state.answers)
        .onAppear { isFocused = true }
        .safeAreaInset(edge: .bottom) {
            submitButton
        }
        .scrollDismissesKeyboard(.interactively)
    }

    @ViewBuilder @MainActor
    private var promptSection: some View {
        Section {
            Text(Localized.BasicPrompt.headline.string)
                .font(.headline)
                .foregroundColor(.App.primaryTextOnAccent)
                .listRowBackground(Color.App.accent.saturation(0.5))
            TextField(
                Localized.prompt.string,
                text: interface.binding(state.prompt, to: { .didChangePrompt($0) })
            )
            .onSubmit {
                isFocused = true
                interface.sendAction(.didCommit)
            }
            .padding(5)
            .focused($isFocused)
        }
    }

    @ViewBuilder @MainActor
    private var answerSection: some View {

        if state.answers.isEmpty {
            Text(Localized.BasicPrompt.description.string)
                .font(.caption)
                .foregroundColor(.gray)
        } else {
            Section {
                ForEach(state.answers) { answer in
                    VStack(alignment: .leading) {
                        Text(answer.prompt)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        switch answer.value {
                        case .initial, .loading:
                            ProgressView()
                                .padding(.vertical, 5)
                        case .failure(let error):
                            Text("Something went wrong:\n\(error.localizedDescription)")
                                .foregroundColor(.red)
                        case let .loaded(value):
                            Text(value)
                                .textSelection(.enabled)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onDelete { interface.sendAction(.didDeleteAnswers($0)) }
            }
        }
    }

    @ViewBuilder @MainActor
    private var submitButton: some View {
        Button {
            interface.sendAction(.didCommit)
        } label: {
            Text(Localized.CodeWriter.SubmitButton.title.string)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(state.prompt.isEmpty ? Color.gray : Color.App.accent)
                .foregroundColor(Color.App.primaryTextOnAccent)
        }
        .disabled(state.prompt.isEmpty)
    }
}

extension BasicPromptView {

    struct Answer: Identifiable, Equatable {
        var id = UUID()
        var prompt: String
        var value: LoadingState<String, Error>
        var creationDate = Date()
    }

    struct ViewState {

        var prompt: String
        var answers: IdentifiedArrayOf<Answer>

        init(prompt: String = "", answers: IdentifiedArrayOf<Answer> = []) {
            self.prompt = prompt
            self.answers = answers
        }

        static var mock: Self {
            .init(answers: [
                .init(prompt: "What is the purpose of life?", value: .loading),
                .init(prompt: "What is the purpose of life?", value: .loaded("Some Answer")),
                .init(prompt: "What is the purpose of life?", value: .failure(.mock))
            ])
        }
    }

    enum Action {
        case didChangePrompt(String)
        case didCommit
        case didDeleteAnswers(IndexSet)
    }
}

struct BasicPromptView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Preview(BasicPromptView.init, state: .mock) { action, $state in
                switch action {
                case let .didChangePrompt(newValue):
                    state.prompt = newValue
                case let .didDeleteAnswers(indexSet):
                    state.answers.remove(atOffsets: indexSet)
                case .didCommit:
                    state.answers.insert(.init(prompt: "What is the purpose of life?", value: .loaded("New Answer")), at: 0)
                default:
                    break
                }
            }
            .navigationTitle("Basic Prompt")
        }
        .preferredColorScheme(.dark)
    }
}
