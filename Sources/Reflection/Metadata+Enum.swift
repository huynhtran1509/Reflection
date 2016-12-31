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
            let payloadCases = Array(zip(caseNames, caseTypes)).map({
                EnumCase(indirect: $1.indirect, name: $0, type: $1.type)
            })
            let nonPayloadCases = Array(caseNames.dropFirst(payloadCases.count)).map({
                EnumCase(indirect: false, name: $0, type: nil)
            })

            return payloadCases + nonPayloadCases
        }

        private var caseTypes: [(type: Any.Type, indirect: Bool)] {
            guard numberOfPayloadCases > 0 else { return [] }
            guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return [] }

            let typePointers = function(UnsafePointer<Int>(pointer))
            let buffer = UnsafeBufferPointer<UnsafePointer<Int>>(start: typePointers, count: numberOfPayloadCases)

            return buffer.map({pointer in
                var pointer = pointer
                let address = Int(bitPattern: pointer)
                let isIndirect = address & 1 == 1

                if isIndirect {
                    pointer = UnsafePointer<Int>(bitPattern: address - 1)!
                }

                return (unsafeBitCast(pointer, to: Any.Type.self), isIndirect)
            })
        }

        public var nominalTypeDescriptorOffsetLocation: Int {
            return 1
        }
    }
}

public struct EnumCase {
    public let indirect: Bool
    public let name: String
    public let type: Any.Type?
}
