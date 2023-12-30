import SwiftUI
import Combine
import Dispatch

class ModelPickerController: ObservableObject {
        
    @Published
    var selection: CoreModel = .init(url: URL(string: "file:///")!, name: "")
    
    @Published
    var pipeline: Pipeline?
    
    @Published
    var isLoading: Bool = false
    
    private var loaderSubscriber: Cancellable?
    
    private let maxSeed: UInt32 = UInt32.max // TODO: -
    
    func onChange(from oldState: CoreModel, to newState: CoreModel) {
        guard !newState.name.isEmpty else {
            return
        }
        
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
                pipeline = try await loader.load()
            }
            catch {
                pipeline = nil
            }
        }
    }
}

struct ModelPickerView: View {
    
    @EnvironmentObject private var generationCtx: GenerationContext
    
    @EnvironmentObject private var folderCtx: FolderContext
    
    @ObservedObject private var controller = ModelPickerController()
    
    var body: some View {
        Text("Model")
            .style(.control)
                
        HStack {
            ProgressView()
            Picker("\(controller.selection.name)", selection: $controller.selection) {
                ForEach(folderCtx.cores, id: \.self) {
                    Text(verbatim: $0.name).tag($0.name)
                }
            }
            .onChange(of: controller.selection, { oldValue, newValue in
                controller.onChange(from: oldValue, to: newValue)
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