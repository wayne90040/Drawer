import SwiftUI

struct ColorPanelView: View {
    
    private let colors: [Color] = [
        .red,
        .green,
        .blue,
        .purple,
        .black,
        .white
    ]
    
    @Binding var selected: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: selected == color ? "record.circle.fill" : "circle.fill")
                    .foregroundStyle(color)
                    .font(.system(size: 16))
                    .clipShape(Circle())
                    .onTapGesture {
                        selected = color
                    }
            }
        }
    }
}

#Preview {
    ColorPanelView(selected: .constant(.red))
}
