import Foundation

let runningOnMac = true
let deviceHas6GBOrMore = true
let deviceHas8GBOrMore = true

struct ModelInfo {
    /// Model name `coreml-stable-diffusion-2-base`
    let modelName: String
    /// Are weights quantized? This is only used to decide whether to use `reduceMemory`
    let quantized: Bool
    /// Whether this is a Stable Diffusion XL model
    let isXL: Bool
    
    var reduceMemory: Bool {
        if runningOnMac {
            return false
        }
        if isXL {
            return !deviceHas8GBOrMore
        }
        return !(quantized && deviceHas6GBOrMore)
    }
}

extension ModelInfo {
    
    static let MODELS: [ModelInfo] = [
        v2Base,
        v15CN,
        v2BasePalettized,
        v21Base,
        chilloutMix
    ]
    
    static let v2Base = ModelInfo(
        modelName: "coreml-stable-diffusion-2-base",
        quantized: false,
        isXL: false)
    
    static let v15CN = ModelInfo(
        modelName: "coreml-stable-diffusion-v1-5_cn",
        quantized: false,
        isXL: false)
    
    static let v2BasePalettized = ModelInfo(
        modelName: "coreml-stable-diffusion-2-base-palettized",
        quantized: false,
        isXL: false)
    
    static let v21Base = ModelInfo(
        modelName: "coreml-stable-diffusion-2-1-base",
        quantized: false,
        isXL: false)
    
    static let chilloutMix = ModelInfo(
        modelName: "coreml-ChilloutMix",
        quantized: false,
        isXL: false
    )
}
