import SwiftUI

struct GenerateButton: View {
    
    @EnvironmentObject var ctx: GenerationContext
    
    var body: some View {
        Button("Generate") {
            generate()
        }
        .disabled(ctx.pipeline == nil)
    }
    
    private func generate() {
        if case .running = ctx.state {
            return
        }
        
        Task {
            ctx.state = .running(nil)
            do {
                let result = try await ctx.textToImage()
                ctx.state = .complete(
                    ctx.prompt,
                    result.image,
                    result.lastSeed,
                    result.interval)
            }
            catch {
                ctx.state = .failed(error)
            }
        }
    }
}

#Preview {
    GenerateButton()
}
