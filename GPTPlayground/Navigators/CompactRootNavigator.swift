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

struct CompactRootNavigator: Navigator {

    // MARK: - Root

    @State private var path: [Path] = []

    var root: some View {
        NavigationStack(path: $path) {
            Home(interface: .handled(by: handleHomeInterface))
                .navigationDestination(for: Path.self) { path in
                    destination(for: path)
                }
        }
    }

    @MainActor @ViewBuilder
    private func destination(for path: Path) -> some View {
        switch path {
        case .basicPrompt:
            BasicPromptAnswerProvider()
        case .codeWriter:
            CodeWriterAnswerProvider(interface: .handled(by: handleCodeWriterInterface))
        }
    }

    // MARK: - State Configuration

    func applyStateConfiguration(_ configuration: StateConfiguration) {
        switch configuration {
        case .reset:
            path.removeAll()
        case .showBasicPrompt:
            path = [.basicPrompt]
        case .showCodeWriter:
            path = [.codeWriter]
        }
    }

    // MARK: - Interface Handlers

    @MainActor
    private func handleHomeInterface(_ action: Home.Action) {
        switch action {
        case .didTapBasicPrompt:
            applyStateConfiguration(.showBasicPrompt)
        case .didTapCodeWriter:
            applyStateConfiguration(.showCodeWriter)
        }
    }

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

extension CompactRootNavigator {
    enum StateConfiguration: Hashable {
        case reset
        case showBasicPrompt
        case showCodeWriter
    }

    enum Path: Hashable {
        case basicPrompt
        case codeWriter
    }
}
