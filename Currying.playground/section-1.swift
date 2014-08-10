// ----------------------------------------------------
// Experimenting with curried functions
// Based off of Chris Eidhof's JSON article:
// http://chris.eidhof.nl/posts/json-parsing-in-swift.html
// https://gist.github.com/chriseidhof/4c071de50461a802874e
// ----------------------------------------------------

import Foundation


// basic function that takes 3 arguments
func triple(a: Int, b: String, c: Character) -> String {
    return "\(a) \(b) \(c)"
}

// curried function expanded by hand
func triple2() -> (Int -> (String -> (Character -> String))) {
    return { a in { b in { c in "\(a) \(b) \(c)" }}}
}

// invoking hand-expanded curried function
triple2()(101)("love")("!")


// Apparently `->` is right associative, so you can also
// declarate it just as in Haskell
func triple3() -> Int -> String -> Character -> String {
    return { a in { b in { c in "\(a) \(b) \(c)" }}}
}

triple3()(0x7f)("blah")(".")

// using special Swift syntax to declare a curried function
func triple4(a: Int)(b: String)(c: Character) -> String {
    return "\(a) \(b) \(c)"
}
// for some reason you need to provide keyword args for subsequent calls
// but the nice thing is that you don't need to do the initial, empty
// function call.
triple4(0xff)(b:"compassion")(c:"s")

// ----------------------------------------------------

// generic curry function for functions with 2 and 3 arguments, respectively
func curry<A,B,R>(f: ((A,B) -> R)) -> A -> B -> R {
    return { a in { b in f(a,b) }}
}
func curry<A,B,C,R>(f: ((A,B,C) -> R)) -> A -> B -> C -> R {
    return { a in { b in { c in f(a,b,c) }}}
}

// using the generic `curry` function to curry an existing function
let triple5 = curry(triple)
triple5(555)("fancy")("#")

// ----------------------------------------

// using the generic curry function on a closure that takes 2 args
let f = curry { (a: Int, b: String) -> String in
    println(a)
    println(b)
    return "\(a) and \(b)"
}
f(99)("love")

// using the generic curry function on a closure that takes 3 args
let g = curry { (a: Int, b: String, c: Character) -> String in
    return "\(a) and \(b) and \(c)"
}

g(-1)("heart")("!")

// ----------------------------------------------------

// Now we get into Chris Eidhof's actual example
// In his case, the arguments to mkBlog were each
// optionals obtained by attempting to parse a field
// out of a JSON dictionary.

infix operator <*> { associativity left precedence 150 }
func <*><A, B>(f: (A -> B)?, x: A?) -> B? {
    if let f1 = f {
        if let x1 = x {
            return f1(x1)
        }
    }
    return nil
}

struct Blog {
    let title: String
    let author: String
    let url: NSURL
}

let mkBlog = curry { title, author, url in
    Blog(title: title, author: author, url: url)
}

// Applicative: all 3 arguments are ok: success
mkBlog <*> "Life Kid"
       <*> "Keith"
       <*> NSURL(string: "http://klazuka.tumblr.com")

// Applicative: the second argument is nil: so the whole thing fails
mkBlog <*> "Life Kid"
       <*> nil
       <*> NSURL(string: "http://klazuka.tumblr.com")




