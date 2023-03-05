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
import CodeWriterService

struct CodeWriterAnswerProvider: View {
    @Service private var service: CodeWriterService = .live
    @State private var generatedCode: String = ""
    @State private var previousGeneratedCodes: [String] = []
    @State private var isLoading: Bool = false

    var interface: Interface<CodeWriter.Action>

    var body: some View {
        CodeWriter(
            interface: .handled(by: .handled(by: interface)),
            providerInterface: .handled(by: handleProviderInterface),
            code: generatedCode,
            isLoading: isLoading
        )
    }

    @MainActor
    private func handleProviderInterface(_ action: CodeWriter.ProviderAction) {
        switch action {
        case .commit(let prompt):
            commit(prompt)
        case .undo:
            undo()
        case .reset:
            reset()
        }
    }

    private func commit(_ prompt: String) {
        Task {
            isLoading = true
            let answer = try await service.send(prompt, currentCode: generatedCode)
            isLoading = false
            previousGeneratedCodes.append(generatedCode)
            generatedCode = answer
        }
    }

    private func reset() {
        generatedCode = ""
        previousGeneratedCodes.removeAll()
        isLoading = false
    }

    private func undo() {
        generatedCode = previousGeneratedCodes.popLast() ?? ""
    }
}
