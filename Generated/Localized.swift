// Source: https://github.com/SwiftGen/SwiftGen/issues/685#issuecomment-782893242
// Adjusted to better fit needs
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

// MARK: - Strings

public enum Localized {
  /// Prompt
  public static let prompt = LocalizedString(lookupKey: "prompt")
  /// Reset
  public static let reset = LocalizedString(lookupKey: "reset")
  /// Undo
  public static let undo = LocalizedString(lookupKey: "undo")
  public enum BasicPrompt {
    /// The API is instructed to answer in a concise and factual manner, without adding any "fluff" or unnecessary extras.\n\nYou can copy answers by long pressing.
    public static let description = LocalizedString(lookupKey: "basic-prompt.description")
    /// What do do you want to ask GPT?
    public static let headline = LocalizedString(lookupKey: "basic-prompt.headline")
    /// Basic Prompt
    public static let title = LocalizedString(lookupKey: "basic-prompt.title")
    public enum SubmitButton {
      /// Submit Prompt
      public static let title = LocalizedString(lookupKey: "basic-prompt.submit-button.title")
    }
  }
  public enum CodeWriter {
    /// Copy Code
    public static let copyCode = LocalizedString(lookupKey: "code-writer.copy-code")
    /// Generate code through natural language prompts.
    public static let description = LocalizedString(lookupKey: "code-writer.description")
    /// Code Writer
    public static let title = LocalizedString(lookupKey: "code-writer.title")
    public enum EmptyList {
      /// Enter a prompt to generate the first code snippet. Afterwards, you can improve the code by entering more prompts.\n\nThis AI is instructed to keep the generated code consistent so that you can iteratively improve it by adding prompts.
      public static let title = LocalizedString(lookupKey: "code-writer.empty-list.title")
    }
    public enum SubmitButton {
      /// Submit Prompt
      public static let title = LocalizedString(lookupKey: "code-writer.submit-button.title")
    }
  }
}

// MARK: - Implementation Details

extension Localized {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

public struct LocalizedString {
    private let lookupKey: String

    init(lookupKey: String) {
        self.lookupKey = lookupKey
    }

    var key: LocalizedStringKey {
        LocalizedStringKey(lookupKey)
    }

    var string: String {
        Localized.tr("Localizable", lookupKey)
    }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
      return Bundle.module
    #else
      return Bundle(for: BundleToken.self)
    #endif
  }()
}
