public protocol MetadataType : PointerType {
    static var kind: Metadata.Kind? { get }
}

public extension MetadataType {
    public var valueWitnessTable: ValueWitnessTable {
        return ValueWitnessTable(pointer: UnsafePointer<UnsafePointer<Int>>(pointer).advanced(by: -1).pointee)
    }

    public var kind: Metadata.Kind {
        return Metadata.Kind(flag: UnsafePointer<Int>(pointer).pointee)
    }

    public init?(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
        if let kind = type(of: self).kind, kind != self.kind {
            return nil
        }
    }

    public init?(instance: Any) {
        self.init(type: type(of: instance))
    }
}
