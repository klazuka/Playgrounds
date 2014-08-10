// Demonstrates how to store functions with varying type signatures
// in a Swift collection (such as a Dictionary)

import Cocoa

// Create a box/thunk to workaround Swift compiler bugs/limitations
public final class Box<T> {
    private let _value : () -> T
    
    public init(_ value : T) {
        self._value = { value }
    }
    
    public var value: T {
        return _value()
    }
    
    public func map<U>(fn: T -> U) -> Box<U> {
        return Box<U>(fn(value))
    }
}

//MARK: basic example

// Define some basic functions with incompatible type signatures
func f(a: Int) -> Int {
    return a + 100
}

func g(a: String) -> String {
    return a + "!"
}

// Store these functions in a lookup table
let table: [String:Any] = ["f":Box(f), "g":Box(g)]

// Lookup and then invoke each function
let f2 = (table["f"] as Box<Int->Int>).value
f2(42)

let g2 = (table["g"] as Box<String->String>).value
g2("allo")


// demonstrate lookup failure
if let h2 = table["h"] as? Box<Int->Int> {
    h2.value(42)
} else {
    println("`h` not found")
}

// MARK: - define some functions to hide the boxing from the caller
func store<T>(f: T, key:String, inout table:[String:Any]) {
    table[key] = Box(f)
}

func lookup<T>(key: String, table: [String:Any]) -> T? {
    if let boxed = table[key] as? Box<T> {
        return boxed.value
    } else {
        return nil
    }
}

// create the lookup table
var table2 = [String:Any]()
store(f, "f", &table2)
store(g, "g", &table2)

// lookup the functions by name and invoke them if found
if let f3: (Int->Int) = lookup("f", table2) {
    f3(101)
}

if let f4: (String->String) = lookup("g", table2) {
    f4("hello")
}




