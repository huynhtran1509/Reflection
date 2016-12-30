public extension Metadata {
    public struct Tuple : MetadataType {
        public static let kind: Kind? = .tuple
        public var pointer: UnsafePointer<Int>

        public var numberOfElements: Int {
            return pointer.advanced(by: 1).pointee
        }

        public var elementTypes: [Any.Type] {
            var types = [Any.Type]()

            for i in 0..<numberOfElements {
                guard let meta = UnsafePointer<Int>(bitPattern: pointer.advanced(by: 3 + 2 * i).pointee) else {
                    break
                }

                types.append(unsafeBitCast(meta, to: Any.Type.self))
            }


            return types
        }

        public var labels: [String?] {
            guard var pointer = UnsafePointer<CChar>(bitPattern: pointer[2]) else { return [] }
            var labels = [String?]()
            var string = ""

            while pointer.pointee != 0 {
                guard pointer.pointee != 32 else {
                    labels.append(string.isEmpty ? nil : string)
                    string = ""
                    pointer.advance()
                    continue
                }

                string.append(String(UnicodeScalar(UInt8(bitPattern: pointer.pointee))))
                pointer.advance()
            }

            return labels
        }
    }
}
