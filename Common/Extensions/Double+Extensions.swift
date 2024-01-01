extension Double {
    func format(_ format: String) -> String {
        .init(format: "%\(format)f", self)
    }
}

extension Float {
    func format(_ format: String) -> String {
        .init(format: "%\(format)f", self)
    }
}
