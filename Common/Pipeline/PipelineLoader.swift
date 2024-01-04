import CoreML
import Combine
import StableDiffusion
import Foundation

enum AttentionVariant: String {
    case original = "original"
    case splitEinsum = "split_einsum"
    case splitEinsumV2 = "split_einsum_v2"
}

class PipelineLoader {
    
    private let coreModel: CoreModel
    private let computeUnits: MLComputeUnits
    private let maxSeed: UInt32
    private let attentionVariant: AttentionVariant
    
    enum PipelineLoaderState {
        case waiting
        case loading
        case loaded
        case failed(Error)
    }
    
    private(set) var state: PipelineLoaderState = .waiting {
        didSet {
            statePublisher.send(state)
        }
    }
    
    private(set) lazy var statePublisher: CurrentValueSubject<PipelineLoaderState, Never> = .init(state)

    init(
        coreModel: CoreModel,
        computeUnits: MLComputeUnits,
        maxSeed: UInt32 = .max,
        attentionVariant: AttentionVariant = .splitEinsum
    ) {
        self.coreModel = coreModel
        self.computeUnits = computeUnits
        self.maxSeed = maxSeed
        self.attentionVariant = attentionVariant
    }
    
    func load() async throws -> Pipeline {
        do {
            let pipeline = try await load(url: coreModelURL)
            return .init(pipeline, maxSeed: maxSeed)
        }
        catch {
            state = .failed(error)
            throw error
        }
    }
    
    func testLoading() async {
        state = .loading
        sleep(5)
        state = .loaded
    }
    
    private var coreModelURL: URL {
        switch attentionVariant {
        case .original:
            return coreModel.originalURL.appending(path: "compiled")
        case .splitEinsum:
            return coreModel.splitEinsum.appending(path: "compiled")
        case .splitEinsumV2:
            return coreModel.splitEinsumV2.appending(path: "compiled")
        }
    }
    
    private func load(url: URL) async throws -> StableDiffusionPipelineProtocol {
        state = .loading
        let startDate = Date()
        let configuration = MLModelConfiguration()
        configuration.computeUnits = computeUnits
        let pipeline: StableDiffusionPipelineProtocol
        
        if coreModel.isXL, #available(macOS 14.0, *) {
            pipeline = try StableDiffusionXLPipeline(
                resourcesAt: url,
                configuration: configuration,
                reduceMemory: false)
        }
        else {
            pipeline = try StableDiffusionPipeline(
                resourcesAt: url,
                controlNet: [],
                configuration: configuration,
                disableSafety: false,
                reduceMemory: false)
        }
        do {
            try pipeline.loadResources()
            state = .loaded
        }
        catch {
            state = .failed(error)
            throw error
        }
        debugPrint("Pipeline loaded in \(Date().timeIntervalSince(startDate))")
        return pipeline
    }
}
