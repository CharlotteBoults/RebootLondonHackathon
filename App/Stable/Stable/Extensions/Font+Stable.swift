import SwiftUI

extension Font {
    static func stableTitle() -> Font {
        .system(size: 32, weight: .semibold, design: .rounded)
    }
    
    static func stableSubtitle() -> Font {
        .system(size: 18, weight: .regular, design: .rounded)
    }
    
    static func stableBody() -> Font {
        .system(size: 20, weight: .medium, design: .rounded)
    }
}
