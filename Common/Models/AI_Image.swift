import Foundation
import UniformTypeIdentifiers
import CoreGraphics
import ImageIO

struct AI_Image: Identifiable {
    
    var id: UUID
    
    var image: CGImage
    
    var prompt: String
    
    var nevgativePrompt: String
    
    var steps: Int
    
    var seeds: UInt32
    
    var guidanceScale: Float
    
    var timestamp: TimeInterval? 
    
    var coreModelName: String
    
    var data: Data? {
        guard 
            let data = CFDataCreateMutable(nil, .zero),
            let destination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil)
        else {
            return nil
        }
        
        let iptc = [
            kCGImagePropertyIPTCCaptionAbstract: meta
        ]
        
        CGImageDestinationAddImage(destination, image, [kCGImagePropertyIPTCDictionary: iptc] as CFDictionary)
        CGImageDestinationFinalize(destination)
        
        return data as Data
    }
}



extension AI_Image {
    
    func saveTo(_ url: URL) throws {
        let fileURL = url.appendingPathExtension("png")
        
        guard let data else {
            return
        }
        
        try data.write(to: fileURL)
    }
}


extension AI_Image {
    var meta: String {
"""
prompt:\(prompt);nevgative:\(nevgativePrompt);steps:\(steps);seeds:\(seeds);scale:\(guidanceScale);timestamp:\(Int(timestamp ?? -1));core:\(coreModelName)
"""
    }
}
