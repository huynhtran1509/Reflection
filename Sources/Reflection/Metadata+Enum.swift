extension Metadata {
    public struct Enum : NominalType {
        public static let kind: Kind? = .enum

        public var pointer: UnsafePointer<Int>

        public var numberOfPayloadCases: Int {
            return nominalTypeDescriptor.numberOfFields & 0xFFFFFF
        }

        public var numberOfNonPayloadCases: Int {
            return nominalTypeDescriptor.fieldOffsetVector
        }

        public var payloadOffset: Int {
            return nominalTypeDescriptor.numberOfFields & 0xFFF000000
        }

        public var cases: [EnumCase] {
            let caseNames = nominalTypeDescriptor.fieldNames
            let payloadCases = Array(zip(caseNames, caseTypes)).map({ EnumCase(name: $0.0, type: $0.1) })
            let nonPayloadCases = Array(caseNames.dropFirst(payloadCases.count)).map({ EnumCase(name: $0, type: nil) })

            return payloadCases + nonPayloadCases
        }

        public var caseTypes: [Any.Type] {
            guard numberOfPayloadCases > 0 else { return [] }
            guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return [] }

            let typePointers = function(UnsafePointer<Int>(pointer))
            let buffer = UnsafeBufferPointer<UnsafePointer<Int>>(start: typePointers, count: numberOfPayloadCases)

            return buffer.map({ unsafeBitCast($0, to: Any.Type.self) })
        }

        public var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
}

public struct EnumCase {
    public let name: String
    public let type: Any.Type?
}
