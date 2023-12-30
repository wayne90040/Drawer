import CoreGraphics
import Foundation

struct GenerationResult {
    var image: CGImage?
    
    var lastSeed: UInt32
    
    var interval: TimeInterval?
    
    var userCanceled: Bool
    
    var itsPerSecond: Double?
}
