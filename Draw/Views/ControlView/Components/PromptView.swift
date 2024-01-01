import SwiftUI

struct PromptView: View {
    
    @EnvironmentObject var ctx: GenerationContext
    
    @State private var showHint = false
    
    @State private var showNegativeHint = false
    
    init() {
        debugPrint("rebuild PromptView")
    }
    
    var body: some View {
        
        debugPrint("rebuild PromptView body")
        
        return VStack(alignment: .leading) {
            
            HStack {
                Text("Positive prompt")
                    .style(.control)
                InfoButton {
                    VStack {
                        Text("Text prompt to guide sampling")
                    }
                    .padding(5)
                }
            }
            
            TextEditor(text: $ctx.prompt)
                .style(.control)
                .padding(.bottom, 10)
            
            HStack {
                Text("Negative Prompt")
                    .style(.control)
                InfoButton {
                    VStack {
                        Text("Negative text prompt to guide sampling")
                    }
                    .padding(5)
                }
            }
            TextEditor(text: $ctx.nevgativePrompt)
                .style(.control)
        }
    }
}

#Preview {
    PromptView()
}
