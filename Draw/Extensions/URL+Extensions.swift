import Foundation

extension URL {

    var subDirectories: [URL] {
        
        guard hasDirectoryPath else {
            return []
        }
        
        let urls = try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            .filter {
                $0.resolvingSymlinksInPath().hasDirectoryPath
            }
        
        return urls ?? []
    }
}
