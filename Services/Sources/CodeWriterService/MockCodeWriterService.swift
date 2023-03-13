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

public class MockCodeWriterService: CodeWriterService {

    public func send(_ prompt: String, currentCode: String?) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return code
    }
}

private let code = """
import SwiftUI
import Puddles

struct Home: Provider {

    var interface: Interface<Action>

    var entryView: some View {
        HomeView(
            interface: .consume(handleViewInterface),
            state: .init(

            )
        )
        .navigationTitle("Home")
    }

    @MainActor
    private func handleViewInterface(_ action: HomeView.Action) {
        switch action {
        case .didTapBasicPrompt:
            interface.sendAction(.didTapBasicPrompt)
        case .didTapCodeWriter:
            interface.sendAction(.didTapCodeWriter)
        }
    }
}

extension Home {
    enum Action {
        case didTapBasicPrompt
        case didTapCodeWriter
    }
}
"""
