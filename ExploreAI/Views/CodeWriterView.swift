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

struct CodeWriterView: View {
    @FocusState private var isFocusingPrompt: Bool
    var interface: Interface<Action>
    var state: ViewState

    var body: some View {
        ScrollView {
            VStack {
                codeView
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            promptView
        }
    }

    @ViewBuilder @MainActor
    private var promptView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                TextField(
                    Localized.prompt.string,
                    text: interface.binding(state.prompt, to: { .didChangePrompt($0) })
                )
                .onSubmit {
                    isFocusingPrompt = true
                    interface.fire(.didTapSubmit)
                }
                .focused($isFocusingPrompt)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background {
                Color(uiColor: .secondarySystemBackground)
            }
            Button {
                interface.fire(.didTapSubmit)
            } label: {
                Text(Localized.CodeWriter.SubmitButton.title.string)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(state.prompt.isEmpty ? Color.gray : Color.App.accent)
                    .foregroundColor(Color.App.primaryTextOnAccent)
            }
            .disabled(state.prompt.isEmpty)
        }
        .onAppear { isFocusingPrompt = true }
    }

    @ViewBuilder @MainActor
    private var codeView: some View {
        ZStack {
            if state.code.characters.isEmpty {
                Text(Localized.CodeWriter.EmptyList.title.string)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background {
                        Color(uiColor: .secondarySystemBackground)
                    }
            } else {
                Text(state.code)
                    .textSelection(.enabled)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background {
                        Color(uiColor: .secondarySystemBackground)
                    }
            }
        }
        .overlay(loadingOverlay)
        .animation(.default, value: state.isLoading)
    }

    @ViewBuilder @MainActor
    private var loadingOverlay: some View {
        if state.isLoading {
            Color.black.opacity(0.5)
                .overlay { ProgressView() }
        }
    }
}

extension CodeWriterView {
    struct ViewState {

        var prompt: String
        var isLoading: Bool
        var code: AttributedString

        init(
            prompt: String = "",
            code: AttributedString = "",
            isLoading: Bool = false
        ) {
            self.prompt = prompt
            self.code = code
            self.isLoading = isLoading
        }

        static var mock: Self {
            .init(code: "let a: String = \"Hello, World\"".highlightAsCode(colorScheme: .dark)!)
        }
    }

    enum Action {
        case didChangePrompt(String)
        case didTapSubmit
    }
}

struct CodeWriter_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Preview(CodeWriterView.init, state: .mock) { action, $state in
                switch action {
                case let .didChangePrompt(newValue):
                    state.prompt = newValue
                default:
                    break
                }
            }
            .onStart { $state in
                state.code = ""
            }
            .navigationTitle("Code Writer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
//        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
