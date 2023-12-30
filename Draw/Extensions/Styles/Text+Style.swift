import SwiftUI

extension Text {
    
    @usableFromInline
    struct ControlTextStyle: ViewModifier {
        
        @usableFromInline
        init() {}
        
        @usableFromInline
        func body(content: Content) -> some View {
            content
                .textCase(.uppercase)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
    
    @usableFromInline
    enum Style {
        case control
    }
    
    @inlinable
    func style(_ style: Style) -> some View {
        switch style {
        case .control:
            return ModifiedContent(content: self, modifier: ControlTextStyle())
        }
    }
}
