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

        public var caseTypes: [Any.Type] {
            guard numberOfPayloadCases > 0 else { return [] }
            guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return [] }

            let typePointers = function(UnsafePointer<Int>(pointer))
            let buffer = UnsafeBufferPointer<UnsafePointer<Int>>(start: typePointers, count: numberOfPayloadCases)

            return buffer.map({ unsafeBitCast($0, to: Any.Type.self) })
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
    }
}
