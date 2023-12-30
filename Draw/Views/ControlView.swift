import SwiftUI
import CompactSlider

struct ControlView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            PromptView()
            
            Divider()
                .padding(.vertical, 10)
            
            ModelPickerView()
            
            Divider()
                .padding(.vertical, 10)
            
            GuidanceScaleView()
                .padding(.bottom, 5)
            
            StepsView()
                .padding(.bottom, 5)
            
            SeedsView()
            
            Divider()
                .padding(.vertical, 10)
            
//            Button("Generate") {
//                debugPrint("Generate")
//            }
            
            GenerateButton()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ControlView()
}
