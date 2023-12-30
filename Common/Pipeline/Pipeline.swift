import StableDiffusion
import CoreML
import Combine

class Pipeline {
    let pipeline: StableDiffusionPipelineProtocol
    let maxSeed: UInt32
    
    var isXL: Bool {
        if #available(macOS 14.0, *) {
            return (pipeline as? StableDiffusionXLPipeline) != nil
        } 
        else {
            return false
        }
    }
    
    var progress: StableDiffusionProgress? = nil {
        didSet {
            progressPublisher.value = progress
        }
    }
    
    lazy private(set) var progressPublisher: CurrentValueSubject<StableDiffusionProgress?, Never> = .init(progress)
    
    private var canceled = false
    
    init(_ pipeline: StableDiffusionPipelineProtocol, maxSeed: UInt32 = .max) {
        self.pipeline = pipeline
        self.maxSeed = maxSeed
    }
    
    func text(
        prompt: String,
        negativePrompt: String,
        scheduler: StableDiffusionScheduler,
        stepCount: Int,
        seed: UInt32,
        guidanceScale: Float = 7.5,
        disableSafety: Bool = false
    ) throws -> GenerationResult {
        canceled = false
        
        var config = StableDiffusionPipeline.Configuration(prompt: prompt)
        config.negativePrompt = negativePrompt
        config.stepCount = stepCount
        config.seed = seed
        config.guidanceScale = guidanceScale
        config.disableSafety = disableSafety
        config.schedulerType = scheduler
        config.useDenoisedIntermediates = true
        if isXL {
            config.encoderScaleFactor = 0.13025
            config.decoderScaleFactor = 0.13025
            config.schedulerTimestepSpacing = .karras
        }
        let images = try pipeline.generateImages(configuration: config) { _ in
            return !canceled
        }
        let image = images.compactMap { $0 }.first
        return .init(image: image, lastSeed: seed, userCanceled: canceled)
    }
    
    func image(
        prompt: String,
        start: CGImage?,
        scheduler: StableDiffusionScheduler,
        stepCount: Int,
        seed: UInt32,
        guidanceScale: Float = 7.5,
        disableSafety: Bool = false
    ) throws -> GenerationResult {
        canceled = false
        
        var config = StableDiffusionPipeline.Configuration(prompt: prompt)
//        config.startingImage = start
        config.imageCount = 5
        config.strength = 0.5
        config.stepCount = stepCount
        config.seed = seed
        config.guidanceScale = guidanceScale
        config.disableSafety = disableSafety
        config.schedulerType = scheduler
        config.useDenoisedIntermediates = false
        if isXL {
            config.encoderScaleFactor = 0.13025
            config.decoderScaleFactor = 0.13025
            config.schedulerTimestepSpacing = .karras
        }
        let images = try pipeline.generateImages(configuration: config) { progress in
            handleProgress(.init(progress: progress))
            return !canceled
        }
        let image = images.compactMap { $0 }.first
        return .init(image: image, lastSeed: seed, userCanceled: canceled)
    }
    
    func setCancelled() {
        canceled = true
    }
    
    private func handleProgress(_ progress: StableDiffusionProgress) {
        self.progress = progress
    }
}
