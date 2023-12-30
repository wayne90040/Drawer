import SwiftUI
import CompactSlider

struct GuidanceScaleView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        Text("Guidance Scale")
            .style(.control)
        
        CompactSlider(value: $context.guidanceScale, in: 1...20, step: 0.5) {
            Text("Guidance Scale")
            Spacer()
            Text("\(context.guidanceScale)")
        }
    }
}

#Preview {
    GuidanceScaleView()
}
