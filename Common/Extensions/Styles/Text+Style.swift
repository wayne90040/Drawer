import SwiftUI

extension Text {

    struct ControlTextStyle: ViewModifier {
    
        func body(content: Content) -> some View {
            content
                .textCase(.uppercase)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
    
    struct InfoTitleTextStyle: ViewModifier {
        
        func body(content: Content) -> some View {
            content
                .textCase(.uppercase)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
    
    struct InfoValueTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.headline)
                .foregroundColor(.white)
        }
    }
    

    enum Style {
        
        case control
        
        case infoTitle
        
        case infoValue
    }
    
    @ViewBuilder
    func style(_ style: Style) -> some View {
        switch style {
        case .control:
            ModifiedContent(content: self, modifier: ControlTextStyle())
            
        case .infoTitle:
            ModifiedContent(content: self, modifier: InfoTitleTextStyle())
            
        case .infoValue:
            ModifiedContent(content: self, modifier: InfoValueTextStyle())
        }
    }
}
