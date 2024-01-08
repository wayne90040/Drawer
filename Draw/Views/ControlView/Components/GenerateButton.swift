import SwiftUI

// TODO: Refactor
struct GenerateButton: View {
    
    @EnvironmentObject var ctx: GenerationContext
    
    var isRunning: Bool {
        if case .running = ctx.state {
            return true
        }
        return false
    }
    
    var body: some View {
        Button {
            generate()
        } label: {
            if isRunning {
                Text("Generating...")
            }
            else {
                Text("Generate")
            }
        }
        .buttonStyle(.bordered)
        .disabled(ctx.pipeline == nil || isRunning)
    }
    
    private func generate() {
        if isRunning {
            return
        }
        
        Task {
            ctx.state = .running(nil)
            do {
                let result = try await ctx.textToImage()
                ctx.save(result)
                ctx.state = .complete(result)
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
