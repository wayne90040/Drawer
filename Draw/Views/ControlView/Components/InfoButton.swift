import SwiftUI

struct InfoButton<T: View>: View {
    
    @State private var showHint = false
    
    @ViewBuilder var content: () -> T

    var body: some View {
        Button {
            showHint.toggle()
        } label: {
            Image(systemName: "info.circle")
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showHint) {
            content()
        }
    }
}
