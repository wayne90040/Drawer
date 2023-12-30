import Foundation

struct CoreModel: Hashable {
    let url: URL
    
    /// Core model name
    let name: String
    
    let isXL: Bool = false // MARK: TODO
}

extension CoreModel {
    var originalURL: URL {
        url.appending(path: AttentionVariant.original.rawValue)
    }
    
    var splitEinsum: URL {
        url.appending(path: AttentionVariant.splitEinsum.rawValue)
    }
    
    var splitEinsumV2: URL {
        url.appending(path: AttentionVariant.splitEinsumV2.rawValue)
    }
}
