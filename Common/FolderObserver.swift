import Combine
import Foundation
import Dispatch

class FolderObserver {
    
    let onChange: PassthroughSubject<Void, Never>
    
    private var source: DispatchSourceFileSystemObject?
    
    private let queue: DispatchQueue
    
    private var url: URL
    
    init(_ url: URL, handler: (() -> Void)? = nil) {
        self.queue = DispatchQueue(label: "com.drawer.folder.observer")
        self.url = url
        self.onChange = PassthroughSubject()
        self.start(handler: handler)
    }
    
    func start(handler: (() -> Void)? = nil) {
        let fileDescriptor = open(url.path(percentEncoded: false), O_EVTONLY)
        
        guard fileDescriptor >= .zero else {
            return
        }
        
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)
        source?.setEventHandler { [weak self] in
           
            if let handler = handler {
                handler()
            }
            
            self?.onChange.send(())
            
        }
        source?.resume()
    }
}

