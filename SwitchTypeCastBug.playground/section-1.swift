// Playground - noun: a place where people can play

import Foundation

enum Inner {
    case A
    case B
}

enum Outer {
    case C(Inner, Any)
}

let x = Outer.C(Inner.A, "hello")

switch x {
case .C(.A, let foo as String):
    println("C/A string '\(foo)'")
case .C(.B, let foo as String):
    println("C/B string '\(foo)'")
default:
    println("default")
}







