extension Metadata {
    public struct Function : NominalType {
        public static let kind: Kind? = .function

        public var _kind: Int {
            return pointer.pointee.kind
        }

        public var argumentTypes: [Any.Type] {
            var argTypes = [Any.Type]()

            for i in 0..<numberOfArguments {
                guard let meta = pointer.pointee.argumentsVector?.advanced(by: i) else { break }

                switch Metadata.Kind(flag: meta.pointee) {
                case .tuple:
                    argTypes += Metadata.Tuple(pointer: meta).elementTypes
                default:
                    argTypes.append(unsafeBitCast(meta, to: Any.Type.self))
                }
            }

            return argTypes
        }

        public var numberOfArguments: Int {
            return Int(pointer.pointee.numberOfArguments)
        }

        public var returnType: Any.Type {
            guard let meta = pointer.pointee.returnVector else { return Never.self }

            return unsafeBitCast(meta, to: Any.Type.self)
        }

        public var pointer: UnsafePointer<_Metadata._Function>

        public var nominalTypeDescriptorOffsetLocation: Int {
            return -3
        }
    }
}

public extension _Metadata {
    public struct _Function {
        public var kind: Int
        public var numberOfArguments: Int
        var returnVector: UnsafePointer<Int>?
        var argumentsVector: UnsafePointer<Int>?
    }
}
