import SwiftUI

struct PromptView: View {
    
    @EnvironmentObject var ctx: GenerationContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Positive prompt")
                .style(.control)
            
            TextEditor(text: $ctx.prompt)
                .style(.control)
                .padding(.bottom, 10)
            
            Text("Negative Prompt")
                .style(.control)
            
            TextEditor(text: $ctx.nevgativePrompt)
                .style(.control)
        }
    }
}

#Preview {
    PromptView()
}
