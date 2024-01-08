import SwiftUI
import CompactSlider

struct CountView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        HStack {
            Text("Count")
                .style(.control)
            
            InfoButton {
                VStack {
                    Text("Number of image to generate")
                }
                .padding()
            }
        }
        
        CompactSlider(value: $context.count, in: 1...10, step: 1.0) {
            Text("Count")
            Spacer()
            Text("\(context.count.format(".0"))")
        }
    }
}

#Preview {
    CountView()
}
