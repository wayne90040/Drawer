import StableDiffusion
import Combine
import Foundation
import Dispatch
import CoreGraphics

let DEFAULT_PROMPT = ""
let DEFAULT_NEGATIVE_PROMPT = ""

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
    
    @Published var loaderState: PipelineLoader.PipelineLoaderState = .waiting
    @Published var state: GenerationState = .startup
    @Published var prompt: String = DEFAULT_PROMPT
    @Published var nevgativePrompt: String = DEFAULT_NEGATIVE_PROMPT
    
    @Published var steps: Double = 25
    @Published var seed: UInt32 = .zero
    
    /// 關鍵詞權重
    @Published var guidanceScale: Float = 7.5
    @Published var disableSafety: Bool = false
    
//    @Published var computeUnits: MLComputeUnits =
    
    private var progressSubscriber: Cancellable?
    
    enum GenerationState {
        case startup
        case running(StableDiffusionProgress?)
        /// prompt, cgImage, lastSeed, interval
        case complete(String, CGImage?, UInt32, TimeInterval?)
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
            prompt: prompt,
            negativePrompt: nevgativePrompt,
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
}
