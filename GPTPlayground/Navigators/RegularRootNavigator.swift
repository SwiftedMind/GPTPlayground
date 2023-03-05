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

enum Panel: Hashable {
    case basicPrompt
    case codeWriter
}

struct RegularRootNavigator: Navigator {
    
    @State private var selection: Panel? = .codeWriter
    
    // MARK: - Root
    
    var root: some View {
        NavigationSplitView() {
            Sidebar(selection: $selection)
        } detail: {
            viewForSelection
        }
    }
    
    @ViewBuilder @MainActor
    private var viewForSelection: some View {
        switch selection {
        case .none:
            Text("Select a tool")
        case .basicPrompt:
            WithProvider(BasicPromptAnswerProvider.self) { provider in
                BasicPrompt(
                    answers: provider.answers,
                    onCommit: provider.commit,
                    onUndo: provider.undo,
                    onReset: provider.reset,
                    onAnswersDeleted: provider.deleteAnswers
                )
            }
        case .codeWriter:
            CodeWriterAnswerProvider(interface: .handled(by: handleCodeWriterInterface))
        }
    }
    
    // MARK: - State Configuration
    
    func applyStateConfiguration(_ configuration: StateConfiguration) {
        switch configuration {
        case .reset:
            break
        }
    }
    
    // MARK: - Interface Handlers

    @MainActor
    private func handleCodeWriterInterface(_ action: CodeWriter.Action) {
        switch action {
        case .noAction:
            break
        }
    }
    
    // MARK: - Deep Links
    
    func handleDeepLink(_ deepLink: URL) -> StateConfiguration? {
        nil
    }
    
}

extension RegularRootNavigator {
    enum StateConfiguration: Hashable {
        case reset
    }
    
    enum Path: Hashable {
        
    }
}
