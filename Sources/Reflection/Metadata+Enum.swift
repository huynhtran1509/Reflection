extension Metadata {
    public struct Enum : NominalType {
        public static let kind: Kind? = .enum

        public var numberOfPayloadCases: Int {
            return nominalTypeDescriptor.numberOfFields & 0xFFFFFF
        }

        public var numberOfNonPayloadCases: Int {
            return nominalTypeDescriptor.fieldOffsetVector
        }

        public var payloadOffset: Int {
            return nominalTypeDescriptor.numberOfFields & 0xFFF000000
        }

        public var cases: [String] {
            return nominalTypeDescriptor.fieldNames
        }

        public var pointer: UnsafePointer<_Metadata._Enum>

        public var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
}

public extension _Metadata {
    public struct _Enum {
        public var kind: Int
        public var parent: Metadata?
    }
}
