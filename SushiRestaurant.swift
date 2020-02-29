import Foundation

let INF = 999999
var minCount = 0
var treeCount = 0

func read() -> (N: Int, M: Int, real: [Int], connect: [[Int]]) {
    var line = readLine(strippingNewline: true)!
    let N = Int(line.components(separatedBy: " ")[0])!
    let M = Int(line.components(separatedBy: " ")[1])!
    line = readLine(strippingNewline: true)!
    let real = line.components(separatedBy: " ").map{ Int($0)! }
    var connect = [[Int]](repeating: [Int](), count: N)
    for i in 0..<N - 1 {
        line = readLine(strippingNewline: true)!
        var temp = line.components(separatedBy: " ").map{ Int($0)! }
        connect[temp[0]].append(temp[1])
        connect[temp[1]].append(temp[0])
    }
    return (N, M, real, connect)
}

func initialize(_ input: String) -> (N: Int, M: Int, real: [Int], connect: [[Int]]) {
    let row = input.components(separatedBy: .newlines)
    let N = Int(row[0].components(separatedBy: " ")[0])!
    let M = Int(row[0].components(separatedBy: " ")[1])!
    let real = row[1].components(separatedBy: " ").map{ Int($0)! }
    var connect = [[Int]](repeating: [Int](), count: N)
    for i in 2...N {
        var temp = row[i].components(separatedBy: " ").map{ Int($0)! }
        connect[temp[0]].append(temp[1])
        connect[temp[1]].append(temp[0])
    }
    return (N, M, real, connect)
}

func pushHeap(_ array: inout [(a: Int, b: Int, cost: Int)], _ v: (a: Int, b: Int, cost: Int)) {
    var n = array.count
    array.append(v)

    while n != 0 {
        let i = (n - 1) / 2
        if array[i].cost > array[n].cost {
            (array[i], array[n]) = (array[n], array[i])
        }
        n = i
    }
}

func popHeap(_ array: inout [(a: Int, b: Int, cost: Int)]) -> (a: Int, b: Int, cost: Int) {
    let n = array.count - 1
    let small = array[0]
    array[0] = array[n]
    array.removeLast()
    minHeapify(&array)
    return small
}

func minHeapify(_ array: inout [(a: Int, b: Int, cost: Int)], _ i: Int = 0) {
    let l = 2 * i + 1
    let r = 2 * i + 2
    let n = array.count - 1
    var small = i

    if l <= n && array[i].cost > array[l].cost {
        small = l
    }
    if r <= n && array[small].cost > array[r].cost {
        small = r
    }
    if small != i {
        (array[i], array[small]) = (array[small], array[i])
        minHeapify(&array, small)
    }

}

func makeTree(_ real: [Int], _ connect:[[Int]]) -> ([[(to: Int, cost: Int)]]) {
    var E = real
    var tree = [[(to: Int, cost:Int)]](repeating: [(to: Int, cost:Int)](), count: connect.count)

    var ways = [(a: Int, b: Int, cost: Int)]()
    for a in 0..<E.count {
        for b in a+1..<E.count {
            treeCount = treeCount + 1
            pushHeap(&ways, (a: E[a], b: E[b], cost: min(E[a], E[b], connect)))
        }
    }

    var seen = [Bool](repeating: false, count: connect.count)
    for i in 0..<ways.count {
        var way = popHeap(&ways)
        if seen[way.a] && seen[way.b] {
            continue
        }
        seen[way.a] = true
        seen[way.b] = true
        tree[way.a].append((to: way.b, cost: way.cost))
        tree[way.b].append((to: way.a, cost: way.cost))
    }
    
    return tree
}

func searchLongest(_ at: Int, _ tree: [[(to: Int, cost: Int)]], _ cost: Int = 0, _ from: Int = -1) -> (to: Int, cost: Int) {
    var result = (to: at, cost: 0)
    for p in tree[at] {
        if p.to == from { continue }
        var temp = searchLongest(p.to, tree, p.cost, at)
        if result.cost < temp.cost {
            result = temp
        }
    }
    return (to: result.to, cost: result.cost + cost)
}

func calcTotal(_ tree: [[(to: Int, cost: Int)]]) -> Int {
    var cost = 0
    for ps in tree {
        for p in ps {
            cost = cost + p.cost
        }
    }
    return cost / 2
}

func min(_ from: Int, _ to: Int, _ connect: [[Int]]) -> Int {
    var table = [[Int]](repeating: [Int](repeating: INF, count: connect.count), count: connect.count)
    var result = INF
    _min(from, to, connect, 1, &table, &result)
    return result
}

func _min(_ from: Int, _ to: Int, _ connect: [[Int]], _ cost: Int, _ table: inout [[Int]], _ result: inout Int) {
    minCount = minCount + 1
    var temp = [Int]()
    for middle in connect[from] {
        if table[from][middle] > cost {
            table[from][middle] = cost
            if middle == to {
                if result > cost {
                    result = cost
                }
                return
            }
            //_min(middle, to, connect, 1 + cost, &table, &result)
            temp.append(middle)
        }
    }

    for middle in temp {
        _min(middle, to, connect, 1 + cost, &table, &result)
    }
}


var input0 = "8 5\n0 6 4 3 7\n0 1\n0 2\n2 3\n4 3\n6 1\n1 5\n7 3"
// 7
var input1 = "2 2\n0 1\n1 0"
// 1
var input6 = "9 3\n0 8 1\n7 6\n7 2\n8 3\n1 2\n2 5\n3 4\n0 6\n2 3"
// 7
var input7 = "100 3\n68 30 23\n78 81\n51 0\n69 40\n60 38\n66 15\n54 4\n73 97\n22 11\n3 91\n18 59\n93 47\n80 64\n84 85\n75 92\n7 29\n5 73\n96 58\n53 25\n62 5\n75 7\n32 67\n28 65\n95 21\n86 59\n56 78\n58 48\n76 52\n8 76\n99 22\n19 70\n29 60\n6 50\n12 30\n9 86\n45 83\n49 89\n23 97\n26 15\n56 67\n92 87\n98 58\n8 16\n54 95\n26 90\n20 85\n7 51\n25 3\n89 1\n72 10\n17 3\n28 93\n83 44\n44 11\n72 42\n69 65\n45 19\n87 43\n68 79\n33 27\n77 13\n55 36\n82 52\n79 31\n71 41\n43 37\n77 14\n80 34\n36 68\n33 71\n91 94\n64 32\n49 16\n31 35\n39 90\n24 60\n30 35\n59 2\n4 74\n96 61\n40 39\n22 52\n88 50\n98 63\n97 18\n9 38\n66 84\n23 61\n36 6\n63 88\n71 46\n46 57\n13 33\n71 34\n14 53\n89 20\n42 94\n78 95\n47 74\n70 12"
// 14


//let (M, N, real, connect) = initialize(input7)
//let tree = makeTree(real, connect)
//let total = calcTotal(tree)
//let from = searchLongest(real[0], tree)
//let longest = searchLongest(from.to, tree)
//let result = (total - longest.cost) * 2 + longest.cost
//
//print("M: \(M)")
//print("N: \(N)")
//print("real: \(real)")
//print("connect: \(connect)")
//print("tree: \(tree)")
//print("total: \(total)")
//print("longest: \(longest.cost)")
//print("result: \(result)")
//print("minCount: \(minCount)")
//print("treeCount: \(treeCount)")

let (M, N, real, connect) = read()
let tree = makeTree(real, connect)
let total = calcTotal(tree)
let from = searchLongest(real[0], tree)
let longest = searchLongest(from.to, tree)
let result = (total - longest.cost) * 2 + longest.cost
print(result)
