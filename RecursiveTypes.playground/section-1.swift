// Playground - noun: a place where people can play

import Cocoa

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


enum Unop {
    case Not
}

enum Duop {
    case And
    case Iff
}

enum Expr {
    case Var(String)
    case Con(Bool)
    case Uno(Unop, Box<Expr>)
    case Duo(Duop, Box<Expr>, Box<Expr>)
}

enum Stmt {
    case Nop
    case Assign(String, Expr)
    case If(Expr, Box<Stmt>, Box<Stmt>)
    case While(Expr, Box<Stmt>)
    case Seq([Box<Stmt>])
}

Unop.Not

Expr.Uno(.Not, Box(.Var("foo")))


