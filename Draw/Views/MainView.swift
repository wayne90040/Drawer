import SwiftUI
import Combine
import StableDiffusion
import CoreML
import Dispatch

struct MainView: View {
    @StateObject var generationContext = GenerationContext()
    @State var selected: AI_Image? = nil
    
    let maxSeed: UInt32 = UInt32.max
    
    var body: some View {
        NavigationSplitView {
            ControlView()
        } content: {
            GenerationView(selected: $selected)
        } detail: {
            InfoView(ai_Image: selected)
        }
        .toolbar {
            GeneratedProgressView()
                .frame(width: 200, height: 30)
        }
        .environmentObject(generationContext)
    }
}

#Preview {
    MainView()
}
