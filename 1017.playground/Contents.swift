import UIKit

var str = "Hello, playground"
let age: Int=10
print("나이는 \(age)살 입니다")

var arr: Array<Int> = Array<Int>()
arr.append(1)
arr.append(10)
print(arr)

var arr2: Array<Int> = [Int]()
arr2.append(2)
arr2.append(20)
print(arr2)

var arr3: [Int] = [Int]()
arr3.append(3)
arr3.append(30)
print(arr3)

var arr4: [Int] = []
arr4.append(4)
arr4.append(40)
print(arr4)

var dic: Dictionary<String, Any>=Dictionary<String, Any>()
print(dic)

var dic2: Dictionary<String, Any>=[String: Any]()
print(dic2)

var dic3: [String: Any] = [String: Any]()
print(dic3)

var dic4: [String: Any] = [:]
print(dic4)

var set: Set<Int>=Set<Int>()
set.insert(1)
set.insert(2)
set.insert(3)
print(set)
set.removeFirst()
print(set)

var set2: Set<Int> = []
print(set2)

let setA: Set<Int> = [1, 2, 3, 4, 5]
let setB: Set<Int> = [3, 4, 5, 6, 7]
let union: Set<Int> = setA.union(setB) // union 메소드로 합집합을 구함
let sortedUnion: [Int] = union.sorted() // 오름차순 정렬해서 배열에 넣어줌
let intersection: Set<Int> = setA.intersection(setB) // intersection 메소드로 교집합을 구함
let subtracting: Set<Int> = setA.subtracting(setB) // subtracting 메소드로 차집합을 구함

func sum(a: Int, b: Int) -> Int {
    return a+b
}

var result=sum(a: 10, b: 66)
print(result)

func printFun(text: String){
    print(text)
}
printFun(text: "hyejin")

func sub() -> Int{
    return 10-5
}
print(sub())

func printText() {
    print("test")
}
printText()
