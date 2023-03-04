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

import Puddles
import SwiftUI
import IdentifiedCollections

struct CodeWriter: Coordinator {

    let interface: Interface<Action>

    @State private var prompt: String = ""
    @State private var selectedLanguage: ProgrammingLanguage = .swift
    var onSubmit: @MainActor (_ prompt: String) -> Void
    var code: AttributedString = ""
    var isLoading: Bool = false

    var entryView: some View {
        CodeWriterView(
            interface: .handled(by: handleViewInterface),
            state: .init(
                prompt: prompt,
                code: code,
                isLoading: isLoading,
                selectedLanguage: selectedLanguage
            )
        )
        .navigationTitle(Localized.CodeWriter.title.string)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Interface Handler

    @MainActor
    private func handleViewInterface(_ action: CodeWriterView.Action) {
        switch action {
        case .didChangePrompt(let newValue):
            prompt = newValue
        case .didChangeSelectedLanguage(let newValue):
            selectedLanguage = newValue
        case .didTapSubmit:
            onSubmit(prompt)
            prompt = ""
        }
    }
}

extension CodeWriter {
    enum Action: Hashable {
        case noAction
    }
}
