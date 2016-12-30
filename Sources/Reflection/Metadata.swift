public struct Metadata : MetadataType {
    public var pointer: UnsafePointer<Int>

    init(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
    }
}

public struct _Metadata {
    struct __Metadata {
        let kind: Int
    }
}

var is64BitPlatform: Bool {
    return sizeof(Int.self) == sizeof(Int64.self)
}
