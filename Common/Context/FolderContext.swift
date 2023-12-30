import Foundation
import Combine

class FolderContext: ObservableObject {

    @Published
    private(set) var cores: [CoreModel] = []
    
    private var defaultURL: URL {
        FileManager.default.homeDirectoryForCurrentUser.appending(path: "Drawer")
    }
    
    var modelURL: URL {
        defaultURL.appending(path: "models", directoryHint: .isDirectory)
    }
    
    var imageURL: URL {
        defaultURL.appending(path: "images", directoryHint: .isDirectory)
    }
    
    private lazy var modelObserver = FolderObserver(modelURL)
    private lazy var imageObserver = FolderObserver(imageURL)
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        prepare()
        bind()
        loadModels()
    }
    
    private func prepare() {
        if !FileManager.default.fileExists(atPath: modelURL.absoluteString) {
            try? FileManager.default.createDirectory(at: modelURL, withIntermediateDirectories: true)
        }
        
        if !FileManager.default.fileExists(atPath: imageURL.absoluteString) {
            try? FileManager.default.createDirectory(at: imageURL, withIntermediateDirectories: true)
        }
    }
    
    private func bind() {
        modelObserver.onChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadModels()
            }
            .store(in: &cancellables)
        
        imageObserver.onChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadImages()
            }
            .store(in: &cancellables)
    }
    
    private func loadModels() {
        cores = []
        cores = modelURL.subDirectories.map {
            .init(url: $0, name: $0.lastPathComponent)
        }
    }
    
    private func loadImages() {
        
    }
}
