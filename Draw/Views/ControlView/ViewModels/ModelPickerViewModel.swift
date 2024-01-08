import Combine
import Dispatch
import Foundation

class ModelPickerViewModel: ObservableObject {
    
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
    
    @MainActor
    private func updatePipeline(_ pipeline: Pipeline?) {
        self.pipeline = pipeline
    }
    
    @MainActor
    private func updateState(_ state: LoadState) {
        self.state = state
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
}

