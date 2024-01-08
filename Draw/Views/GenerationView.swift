import SwiftUI
import StableDiffusion

struct GenerationView: View {
    @StateObject var imageCtx = ImageFolderContext()
    @Binding var selected: AI_Image?
    
    let gridLayout = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    init(selected: Binding<AI_Image?>) {
        self._selected = selected
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout) {
                ForEach(imageCtx.ai_Images) { ai_image in
                    Image(ai_image.image, scale: 1, label: Text(""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay {
                            if let selected, selected.id == ai_image.id {
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.accentColor, lineWidth: 3)
                            }
                        }
                        .onTapGesture {
                            selected = ai_image
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    GenerationView(selected: .constant(nil))
}
