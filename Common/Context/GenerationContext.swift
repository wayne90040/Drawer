import StableDiffusion
import Combine
import Foundation
import Dispatch
import CoreGraphics

class GenerationContext: ObservableObject {
    
    let scheduler = StableDiffusionScheduler.dpmSolverMultistepScheduler
    
    @Published var pipeline: Pipeline? = nil {
        didSet {
            guard let pipeline = pipeline else { return }
            progressSubscriber = pipeline
                .progressPublisher
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] progress in
                    guard let progress = progress else { return }
                    state = .running(progress)
                }
        }
    }

    @Published var state: GenerationState = .startup
    @Published var prompt: String = ""
    @Published var nevgativePrompt: String = ""
    @Published var count: Float = 1
    @Published var steps: Double = 50
    @Published var seed: UInt32 = .zero
    
    /// 關鍵詞權重
    @Published var guidanceScale: Float = 7.5
    @Published var disableSafety: Bool = false
    
    var coreModelName: String = ""
    
    private var progressSubscriber: Cancellable?
    
    enum GenerationState {
        case startup
        case running(StableDiffusionProgress?)
        case complete(GenerationResult)
        case userCanceled
        case failed(Error?)
    }

    enum GenerationContextError: Error {
        case pipelineIsNil
    }
    
    func textToImage() async throws -> GenerationResult {
        guard let pipeline = pipeline else {
            throw GenerationContextError.pipelineIsNil
        }
        return try pipeline.text(
            coreDataName: coreModelName,
            prompt: prompt,
            negativePrompt: nevgativePrompt,
            imageCount: Int(count),
            scheduler: scheduler,
            stepCount: Int(steps),
            seed: seed,
            guidanceScale: guidanceScale,
            disableSafety: disableSafety)
    }
    
    func imageToImage(_ start: CGImage?) async throws -> GenerationResult {
        guard let pipeline = pipeline else {
            throw GenerationContextError.pipelineIsNil
        }
        return try pipeline.image(
            coreDataName: coreModelName,
            prompt: prompt,
            start: start,
            scheduler: scheduler,
            stepCount: Int(steps),
            seed: seed,
            guidanceScale: guidanceScale,
            disableSafety: disableSafety)
    }
    
    func cancelGeneration() {
        pipeline?.setCancelled()
    }
    
    // TODO: Refactor
    func save(_ result: GenerationResult) {
        let ai_Images = result.ai_images
        
        ai_Images.enumerated().forEach {
            let url = Constants.imageURL.appending(path: "\($0.element.id)")
            
            do {
                try $0.element.saveTo(url)
            }
            catch {
                debugPrint(error)
            }
        }
    }
}
