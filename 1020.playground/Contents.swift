import UIKit

var str = "Hello, playground"
var result = 123

if result < 100 {
    print("100 미만")
} else if result > 100 {
    print("100 초과")
} else {
    print("100")
}

switch result {
case 0:
    print("zero")
case 1..<100:
    print("1~99")
case 100:
    print("100")
case 101...Int.max:
    print("over 100")
default:
    print("unknown")
}

var integers = [1, 2, 3]
let people = ["hyejin":22, "toin":14]

for a in integers{
    print(a)
}
for (name, age) in people{
    print("\(name): \(age)")
}
while integers.count > 0 {
    //print(integers.last)
    integers.removeLast()
}

func printName(_ name: String) {
    print(name)
}
var myName: String! = nil
if let name: String = myName {
    printName(name)
} else {
    print("myName == nill")
}

var me: String? = "hyejin"
var you: String? = nil

if let name = me, let friend = you {
    print("myName: \(name), yourName: \(friend)")
} else {
    print("nil")
}
