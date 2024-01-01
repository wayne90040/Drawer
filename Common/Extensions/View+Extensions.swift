import SwiftUI

@usableFromInline
struct HiddenViewStyle: ViewModifier {
    
    private var isHidden: Bool
    
    private var remove: Bool = false
    
    @usableFromInline
    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden = isHidden
        self.remove = remove
    }
    
    @usableFromInline
    func body(content: Content) -> some View {
        if isHidden {
            if remove {
                EmptyView()
            }
            else {
                content.hidden()
            }
        }
        else {
            content
        }
    }
}

extension View {
    @inlinable public func isHidden(_ isHidden: Bool, remove: Bool = false) -> some View {
        modifier(HiddenViewStyle(isHidden: isHidden, remove: remove))
    }
}
