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

struct SidebarView: View {

    var interface: Interface<Action>
    var state: ViewState

    var body: some View {
        List(
            selection: interface.binding(state.selection, to: { .didChangeSelection($0) })
        ) {
            Section {
                NavigationLink(Localized.BasicPrompt.title.string, value: Panel.basicPrompt)
                NavigationLink(Localized.CodeWriter.title.string, value: Panel.codeWriter)
            }
        }
        .listStyle(.insetGrouped)
    }
}

extension SidebarView {
    struct ViewState {
        
        var selection: Panel?
        
        static var mock: Self {
            .init()
        }
    }

    enum Action {
        case didChangeSelection(Panel?)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Preview(SidebarView.init, state: .mock) { action, $state in

            }
            .navigationTitle("Tools")
        }
        .preferredColorScheme(.dark)
    }
}
