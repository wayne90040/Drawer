import Foundation

enum Constants {
    
    static let defaultURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "Drawer")
    
    static var imageURL: URL {
        defaultURL.appending(path: "images", directoryHint: .isDirectory)
    }
    
    enum Steps {
        static let MAX = 100.0
        static let MIN = 1.0
    }
    
    enum GuidanceScale {
        static let MAX: Float = 20.0
        static let MIN: Float = 0.0
    }
    
    enum Seeds {
        static let MAX = 20
        static let MIN = 0
    }
    
    
}
