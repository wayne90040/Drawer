import SwiftUI
import CompactSlider

struct ControlView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                
                CountView()
                    .padding(.bottom, 5)
                
                SeedsView()
                
                Divider()
                    .padding(.vertical, 10)
                
                GenerateButton()
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ControlView()
}
