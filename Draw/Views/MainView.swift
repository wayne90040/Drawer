import SwiftUI
import Combine
import StableDiffusion
import CoreML
import Dispatch

struct MainView: View {
    
    @StateObject var generationContext = GenerationContext()
    @StateObject var folderContext = FolderContext()
    
    let maxSeed: UInt32 = UInt32.max
    
    var body: some View {
        NavigationSplitView {
            ControlView()
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            GenerationView()
        }
        .frame(minHeight: 300)
        .environmentObject(generationContext)
        .environmentObject(folderContext)
    }
}

#Preview {
    MainView()
}
