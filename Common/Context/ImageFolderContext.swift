import Foundation
import Combine
import CoreGraphics
import ImageIO

class ImageFolderContext: ObservableObject {
    
    @Published
    private(set) var ai_Images: [AI_Image] = []
    
    private lazy var imageObserver = FolderObserver(Constants.imageURL)
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func prepare() {
        if !FileManager.default.fileExists(atPath: Constants.imageURL.absoluteString) {
            try? FileManager.default.createDirectory(at: Constants.imageURL, withIntermediateDirectories: true)
        }
    }
    
    init() {
        prepare()
        bind()
        loadImages()
    }
    
    private func bind() {
        imageObserver.onChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadImages()
            }
            .store(in: &cancellables)
    }
    
    private func loadImages() {
        guard let fileURLs = try? FileManager.default.contentsOfDirectory(
            at: Constants.imageURL,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles)
        else {
            return
        }
        
        ai_Images = []
        
        let imageURLs = fileURLs
            .filter {
                $0.isFileURL && ["png"].contains($0.pathExtension)
            }
        
        imageURLs.forEach { [weak self] in
            if let image = self?.decodeToImage($0) {
                self?.ai_Images.append(image)
            }
        }
        
        ai_Images = ai_Images.sorted { p1, p2 in
            p1.timestamp ?? .zero > p2.timestamp ?? .zero
        }
    }
    
    private func decodeToImage(_ url: URL) -> AI_Image? {
        guard
            let source = CGImageSourceCreateWithURL(url as CFURL, nil)
        else {
            return nil
        }
        
        let primaryIdx = CGImageSourceGetPrimaryImageIndex(source)
        
        guard
            let cgImage = CGImageSourceCreateImageAtIndex(source, primaryIdx, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(source, primaryIdx, nil) as? [String: Any],
            let tiffMap = properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any]
        else {
            return nil
        }
        
        var image = AI_Image(
            id: .init(),
            image: cgImage,
            prompt: "",
            nevgativePrompt: "",
            steps: .zero,
            seeds: .zero,
            guidanceScale: .zero,
            timestamp: nil,
            coreModelName: "")
        
        if let info = tiffMap[kCGImagePropertyTIFFImageDescription as String] as? String {
            
            info.split(separator: ";").forEach {
                let pair = $0.split(separator: ":")
                
                if pair.count >= 2 {
                    let key = String(pair[0])
                    let value = String(pair[1])

                    switch key {
                    case "prompt":
                        image.prompt = value
                    
                    case "nevgative":
                        image.nevgativePrompt = value
                        
                    case "steps":
                        image.steps = .init(value) ?? .zero
                        
                    case "seeds":
                        image.seeds = .init(value) ?? .zero
                        
                    case "scale":
                        image.guidanceScale = .init(value) ?? .zero
                    
                    case "timestamp":
                        image.timestamp = .init(value)
                        
                    case "core":
                        image.coreModelName = .init(value)
                        
                    default:
                        break
                    }
                }
            }
        }
        else {
            
        }
        
        if let createDate = try? url.resourceValues(forKeys: [.creationDateKey,]).creationDate {
            image.timestamp = createDate.timeIntervalSince1970
        }
        
        return image
    }
}
