import StableDiffusion
import CoreGraphics

struct StableDiffusionProgress {
    var progress: StableDiffusionPipeline.Progress
    /// current step
    var step: Int { progress.step }
    /// total step
    var stepCount: Int { progress.stepCount }
    var currentImages: [CGImage]
    
    init(progress: StableDiffusionPipeline.Progress) {
        self.progress = progress
        self.currentImages = []
    }
}
