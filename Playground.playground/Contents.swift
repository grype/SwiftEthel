import Cocoa

protocol Named {
    var typeName: String {get}
}

extension Named {
    var typeName: String {
        return String(describing: type(of: self))
    }
}

class Foo : Named {}
struct Bar : Named {}

let foo = Foo()
foo.typeName

let bar = Bar()
bar.typeName
