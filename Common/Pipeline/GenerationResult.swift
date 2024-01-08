import CoreGraphics
import Foundation

struct GenerationResult {
    
    var images: [CGImage]
    
    var prompt: String
    
    var nevgativePrompt: String
    
    var steps: Int
    
    var seeds: UInt32
    
    var guidanceScale: Float
    
    var timestamp: TimeInterval
    
    var interval: TimeInterval?
    
    var userCanceled: Bool
    
    var itsPerSecond: Double?
    
    var coreModelName: String

}

extension GenerationResult {

    var ai_images: [AI_Image] {
        images.map {
            .init(
                id: .init(),
                image: $0,
                prompt: prompt,
                nevgativePrompt: nevgativePrompt,
                steps: steps,
                seeds: seeds,
                guidanceScale: guidanceScale,
                timestamp: timestamp,
                coreModelName: coreModelName
            )
        }
    }
}
