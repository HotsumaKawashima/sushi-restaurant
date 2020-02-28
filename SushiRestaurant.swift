import Foundation

var input1 = "8 2\n5 2\n0 1\n0 2\n2 3\n4 3\n6 1\n1 5\n7 3"
var input2 = "8 5\n0 6 4 3 7\n0 1\n0 2\n2 3\n4 3\n6 1\n1 5\n7 3"
var input3 = "7 2\n5 0\n4 0\n3 1\n0 6\n0 1\n2 1\n5 2"

let INF = 999999

var N = -1
var M = -1
var real = [Int]()
var connect = [[Int]]()
var path = [[Int]]()
var result = INF
var resultArray = INF

func printTable(_ name: String, _ table: [[Int]]) {
    print(name)
    print("  ", terminator: "")
    for i in 0..<table.count {
        print(NSString(format: "% 3d", i), terminator: " ")
    }
    print("")
    var i = 0
    for a in table {
        print(i, terminator: " ")
        for b in a {
            if b == INF {
                print("INF", terminator: " ")
            } else {
                print(NSString(format: "%03d", b), terminator: " ")
            }
        }
        i += 1
        print("")
    }
}

func read() {
    var first = readLine(strippingNewline: true)!
    N = Int(first.components(separatedBy: " ")[0])!
    M = Int(first.components(separatedBy: " ")[1])!
    var second = readLine(strippingNewline: true)!
    real = second.components(separatedBy: " ").map{ Int($0)! }
    connect = [[Int]](repeating: [Int](), count: N)
    for i in 2...N {
        var row = readLine(strippingNewline: true)!
        var temp = row.components(separatedBy: " ").map{ Int($0)! }
        connect[temp[0]].append(temp[1])
        connect[temp[1]].append(temp[0])
    }    
}

func initialize(_ input: String) {
    var row = input.components(separatedBy: .newlines)
    N = Int(row[0].components(separatedBy: " ")[0])!
    M = Int(row[0].components(separatedBy: " ")[1])!
    real = row[1].components(separatedBy: " ").map{ Int($0)! }
    connect = [[Int]](repeating: [Int](), count: N)
    for i in 2...N {
        var temp = row[i].components(separatedBy: " ").map{ Int($0)! }
        connect[temp[0]].append(temp[1])
        connect[temp[1]].append(temp[0])
    }    
}

var comb = [[Int]]()

func makeComb(_ array: [Int]) {
    comb = [[Int]]()
    if array.count == 2 {
        comb = [array]
        return
    }
    _makeComb([Int](array), [])
}

func _makeComb(_ array: [Int], _ progress: [Int]) {
    if array.count == 1 {
        comb.append(progress)
        return
    }
    for i in 1..<array.count {
        _makeComb([Int](array[..<i]) + [Int](array[(i + 1)...]), progress + [array[i]])
    }
}

func min(_ from: Int, _ to: Int) {
    path = [[Int]](repeating: [Int](repeating: INF, count: N), count: N)
    result = INF
    _min(from, to)
}

func _min(_ from: Int, _ to: Int, _ cost:Int = 1) {
    for middle in connect[from] {
        if middle == to {
            if path[from][middle] > cost {
                path[from][middle] = cost
                result = cost
            }
            return
        }
        if path[from][middle] > cost {
            path[from][middle] = cost
            _min(middle, to, 1 + cost)
        }
    }
}

func min(_ array: [[Int]]) {
    resultArray = INF
    for a in 0..<array.count {
        var temp = 0
        for b in 0..<array[a].count - 1 {
            min(array[a][b], array[a][b + 1])
            temp = temp + result
        }
        if temp < resultArray {
            resultArray = temp
        }
    }
}

//initialize(input1)

//print("N: \(N)")
//print("M: \(M)")
//print("real: \(real)")
//print("connect: \(connect)")

//makeComb(real)
//print("comb: \(comb)")

//min(5, 2)
//printTable("path: ", path)
//print("result: \(result)")

//initialize(input2)
//makeComb(real)
//print("comb: \(comb)")
//min(comb)
//print("result: \(resultArray)")

//initialize(input3)
//print(real)
//makeComb(real)
//print("comb: \(comb)")
//min(comb)
//print("result: \(resultArray)")

read()
makeComb(real)
min(comb)
print(resultArray)
