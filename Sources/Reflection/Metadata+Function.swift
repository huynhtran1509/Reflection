extension Metadata {
    public struct Function : MetadataType {
        public static let kind: Kind? = .function
        public var pointer: UnsafePointer<Int>

        public var argumentTypes: [FunctionArgument] {
            var argTypes = [FunctionArgument]()

            for i in 0..<numberOfArguments {
                let argumentsVectorStart = pointer[3 + i]
                let isInout = argumentsVectorStart & 1 == 1
                let pointerToMetadata = isInout ? argumentsVectorStart - 1 : argumentsVectorStart

                guard let argumentPointer = UnsafePointer<Int>(bitPattern: pointerToMetadata) else { continue }

                argTypes.append(FunctionArgument(isInout: isInout, type: unsafeBitCast(argumentPointer, to: Any.Type.self)))
            }

            return argTypes
        }

        public var numberOfArguments: Int {
            return Int(pointer[1])
        }

        public var returnType: Any.Type {
            guard let meta = UnsafePointer<Int>(bitPattern: pointer[2]) else { return Never.self }

            return unsafeBitCast(meta, to: Any.Type.self)
        }
    }
}

public struct FunctionArgument {
    public let isInout: Bool
    public let type: Any.Type
}
