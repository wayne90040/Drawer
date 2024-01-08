import SwiftUI

struct InfoTile: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .style(.infoTitle)
            Text(value)
                .style(.infoValue)
        }
    }
}

struct InfoView: View {
    
    @ObservedObject private var viewModel = InfoViewModel()
    
    
    init(ai_Image: AI_Image? = nil) {
        self.viewModel.ai_Image = ai_Image
    }
    
    var body: some View {
        
        Group {
            if let image = viewModel.ai_Image {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(image.image, scale: 1, label: Text(""))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
            
                        InfoTile(title: "Positive prompt", value: image.prompt)
                        InfoTile(title: "Negative Prompt", value: image.nevgativePrompt)
                        InfoTile(title: "Model", value: image.coreModelName)
                        InfoTile(title: "Guidance Scale", value: image.guidanceScale.format(".1"))
                        InfoTile(title: "Steps", value: "\(image.steps)")
                        InfoTile(title: "Seed", value: "\(image.seeds)")
                        InfoTile(title: "Create Date", value: "\(String(describing: image.timestamp ?? .zero))")
                    }
                    .padding()
                }
            }
            else {
                Text("None")
            }
        }
    }
}

#Preview {
    InfoView(ai_Image: nil)
}
