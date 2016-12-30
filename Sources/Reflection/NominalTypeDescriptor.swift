public struct NominalTypeDescriptor : PointerType {
    public var pointer: UnsafePointer<_NominalTypeDescriptor>

    public var mangledName: String {
        return String(cString: relativePointer(base: pointer, offset: pointer.pointee.mangledName) as UnsafePointer<CChar>)
    }

    public var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }

    public var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }

    public var fieldNames: [String] {
        let p = UnsafePointer<Int32>(self.pointer)
        return Array(utf8Strings: relativePointer(base: p.advanced(by: 3), offset: self.pointer.pointee.fieldNames))
    }

    public typealias FieldsTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<UnsafePointer<Int>>

    public var fieldTypesAccessor: FieldsTypeAccessor? {
        let offset = pointer.pointee.fieldTypesAccessor
        guard offset != 0 else { return nil }
        let p = UnsafePointer<Int32>(self.pointer)
        let offsetPointer: UnsafePointer<Int> = relativePointer(base: p.advanced(by: 4), offset: offset)
        return unsafeBitCast(offsetPointer, to: FieldsTypeAccessor.self)
    }
}

public struct _NominalTypeDescriptor {
    var mangledName: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
    var fieldNames: Int32
    var fieldTypesAccessor: Int32
}
