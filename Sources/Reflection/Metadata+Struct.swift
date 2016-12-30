extension Metadata {
    public struct Struct : NominalType {
        public static let kind: Kind? = .struct

        public var pointer: UnsafePointer<_Metadata._Struct>
        public var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
}

public extension _Metadata {
    public struct _Struct {
        public var kind: Int
        public var nominalTypeDescriptorOffset: Int
        public var parent: Metadata?
    }
}
