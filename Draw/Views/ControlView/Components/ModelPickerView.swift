import SwiftUI
import Combine
import Dispatch

class ModelPickerController: ObservableObject {
    
    enum LoadState {
        case wait
        case loading
        case loaded
        case error
    }
    
    @Published
    var selection: CoreModel = .init(url: URL(string: "file:///")!, name: "")
    
    @Published
    var pipeline: Pipeline?
    
    @Published
    var isLoading: Bool = false
    
    @Published
    var state: LoadState = .wait
    
    private var loaderSubscriber: Cancellable?
    private let maxSeed: UInt32 = UInt32.max // TODO: -
    
    @MainActor
    func onChange(from oldState: CoreModel? = nil, to newState: CoreModel) {
        guard !newState.name.isEmpty else {
            return
        }
        
        updateState(.loading)
        
        let loader = PipelineLoader(
            coreModel: newState,
            computeUnits: .cpuAndNeuralEngine,
            maxSeed: maxSeed,
            attentionVariant: .splitEinsum)
        
        loaderSubscriber = loader.statePublisher
            .map {
                switch $0 {
                case .loading:
                    return true
                default:
                    return false
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isLoading = $0
            }
        
        loaderPipeline(loader: loader)
    }
    
    private func loaderPipeline(loader: PipelineLoader) {
        Task {
            do {
                let pipeline = try await loader.load()
                await updatePipeline(pipeline)
                await updateState(.loaded)
            }
            catch {
                await updatePipeline(nil)
                await updateState(.error)
            }
        }
    }
    
    @MainActor
    private func updatePipeline(_ pipeline: Pipeline?) {
        self.pipeline = pipeline
    }
    
    @MainActor
    private func updateState(_ state: LoadState) {
        self.state = state
    }
}

struct ModelPickerView: View {
    
    @EnvironmentObject private var generationCtx: GenerationContext
    @EnvironmentObject private var folderCtx: FolderContext
    @ObservedObject private var controller = ModelPickerController()
    
    @ViewBuilder
    func icon(_ state: ModelPickerController.LoadState) -> some View {
        
        switch state {
        case .loading:
            ProgressView()
                .controlSize(.small)
                .padding(.trailing, 8)
                .isHidden(!controller.isLoading, remove: true)
            
        case .error:
            Image(systemName: "x.circle")
            
        case .loaded:
            Image(systemName: "checkmark.circle")
            
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        Text("Model")
            .style(.control)
        
        HStack {
            
            icon(controller.state)
            
            Picker("\(controller.selection.name)", selection: $controller.selection) {
                ForEach(folderCtx.cores, id: \.self) {
                    Text(verbatim: $0.name).tag($0.name)
                }
            }
            .onChange(of: controller.selection, perform: {
                controller.onChange(to: $0)
            })
            .disabled(controller.isLoading)
            .labelsHidden()
        }
        .onReceive(controller.$pipeline) {
            generationCtx.pipeline = $0
        }
    }
}

#Preview {
    ModelPickerView()
}
