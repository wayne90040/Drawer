import SwiftUI
import Combine
import Dispatch

struct ModelPickerView: View {
    @EnvironmentObject private var generationCtx: GenerationContext
    
    @StateObject private var folderCtx = FolderContext()
    @StateObject private var viewModel = ModelPickerViewModel()
    
    var body: some View {
        Text("Model")
            .style(.control)
        
        HStack {
            icon(viewModel.state)
            Picker("\(viewModel.selection.name)", selection: $viewModel.selection) {
                ForEach(folderCtx.cores, id: \.self) {
                    Text(verbatim: $0.name).tag($0.name)
                }
            }
            .onChange(of: viewModel.selection, perform: {
                viewModel.onChange(to: $0)
            })
            .disabled(viewModel.isLoading)
            .labelsHidden()
        }
        .onReceive(viewModel.$pipeline) {
            generationCtx.coreModelName = viewModel.selection.name
            generationCtx.pipeline = $0
        }
    }
    
    @ViewBuilder
    private func icon(_ state: ModelPickerViewModel.LoadState) -> some View {
        
        switch state {
        case .loading:
            ProgressView()
                .controlSize(.small)
                .padding(.trailing, 8)
                .isHidden(!viewModel.isLoading, remove: true)
            
        case .error:
            Image(systemName: "x.circle")
            
        case .loaded:
            Image(systemName: "checkmark.circle")
            
        default:
            EmptyView()
        }
    }
}

#Preview {
    ModelPickerView()
}
