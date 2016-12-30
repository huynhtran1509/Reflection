extension Metadata {
    public struct Class : NominalType {

        public static let kind: Kind? = .class
        public var pointer: UnsafePointer<_Metadata._Class>

        public var nominalTypeDescriptorOffsetLocation: Int {
            return is64BitPlatform ? 8 : 11
        }

        public var superclass: Class? {
            guard let superclass = pointer.pointee.superclass else { return nil }
            return Metadata.Class(type: superclass)
        }

        public func properties() throws -> [Property.Description] {
            let properties = try fetchAndSaveProperties(nominalType: self, hashedType: HashedType(pointer))
            guard let superclass = superclass, String(describing: unsafeBitCast(superclass.pointer, to: Any.Type.self)) != "SwiftObject" else {
                return properties
            }
            return try superclass.properties() + properties
        }

    }
}

public extension _Metadata {
    public struct _Class {
        public var kind: Int
        public var superclass: Any.Type?
    }
}
