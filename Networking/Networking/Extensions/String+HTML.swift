import Foundation

import class Aztec.HTMLParser

/// String: HTML Stripping
///
extension String {

    /// Returns the HTML Stripped version of the receiver.
    ///
    /// NOTE: I can be very slow ⏳ — using it in a background thread is strongly recommended.
    ///
    public var strippedHTML: String {
        HTMLParser().parse(self).rawText()
    }

    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    public var slugified: String? {
        guard let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) else {
            return nil
        }

        let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
        let result = urlComponents.filter { $0 != "" }.joined(separator: "-")

        guard result.count > 0 else {
            return nil
        }

        return result
    }
}
