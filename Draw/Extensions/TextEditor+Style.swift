import SwiftUI

extension TextEditor {
    
    @usableFromInline
    struct ControlViewStyle: ViewModifier {
        
        @usableFromInline
        init() { }
        
        @usableFromInline
        func body(content: Content) -> some View {
            content
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(height: 100)
                .cornerRadius(8)
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
            return ModifiedContent(content: self, modifier: ControlViewStyle())
        }
    }
}
