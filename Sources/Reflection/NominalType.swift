public protocol NominalType : MetadataType {
    var nominalTypeDescriptorOffsetLocation: Int { get }
}

public extension NominalType {
    public var nominalTypeDescriptor: NominalTypeDescriptor {
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: nominalTypeDescriptorOffsetLocation)
        return NominalTypeDescriptor(pointer: relativePointer(base: base, offset: base.pointee))
    }

    public var fieldTypes: [Any.Type] {
        guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return [] }

        let typePointers = function(UnsafePointer<Int>(pointer))
        let buffer = UnsafeBufferPointer<UnsafePointer<Int>>(start: typePointers,
                                                             count: nominalTypeDescriptor.numberOfFields)

        return buffer.map({ unsafeBitCast($0, to: Any.Type.self) })
    }

    public var fieldOffsets: [Int] {
        let vectorOffset = nominalTypeDescriptor.fieldOffsetVector
        guard vectorOffset != 0 else { return [] }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return UnsafePointer<Int>(pointer)[vectorOffset + $0]
        }
    }
}
