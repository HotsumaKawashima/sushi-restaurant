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

func root(_ array: inout [Int], _ x: Int) -> Int {
    if array[x] == x { return x }
    array[x] = root(&array, array[x])
    return array[x]
}

func unite(_ array: inout [Int], _ x: Int, _ y: Int) {
    var rx = root(&array, x)
    var ry = root(&array, y)
    if rx == ry { return }
    array[rx] = ry
}

func same(_ array: inout [Int], _ x: Int, _ y: Int) -> Bool {
    var rx = root(&array, x)
    var ry = root(&array, y)
    return rx == ry
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

    var union = [Int](0..<connect.count)
    for i in 0..<ways.count {
        var way = popHeap(&ways)
        if same(&union, way.a, way.b) {
            continue
        }
        unite(&union, way.a, way.b)
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
var input13 = "100 8\n25 47 93 2 69 21 46 42\n99 87\n26 73\n45 11\n88 90\n12 67\n83 15\n1 82\n89 9\n21 0\n17 64\n80 27\n8 86\n37 44\n8 92\n75 60\n5 60\n34 29\n59 62\n26 53\n64 49\n86 14\n72 74\n35 90\n66 26\n68 32\n56 52\n81 30\n22 91\n81 82\n0 41\n73 72\n71 2\n22 87\n58 83\n6 26\n61 51\n1 76\n88 19\n67 3\n4 55\n97 73\n90 56\n60 36\n75 94\n38 29\n28 10\n23 81\n91 0\n50 66\n53 65\n16 55\n89 42\n86 77\n55 18\n33 28\n43 59\n20 34\n71 45\n82 40\n20 17\n45 57\n95 17\n70 24\n70 80\n7 21\n7 57\n40 57\n72 85\n98 11\n84 80\n47 31\n18 28\n38 48\n70 20\n69 67\n69 33\n88 46\n63 37\n43 78\n47 51\n9 51\n46 25\n15 32\n47 13\n22 86\n52 68\n2 93\n36 17\n96 43\n59 15\n87 54\n90 79\n3 94\n39 21\n7 56\n50 83\n21 5\n44 21\n31 66"
// 40

//let (M, N, real, connect) = initialize(input7)
//print("min \(min(68, 23, connect))")

let (M, N, real, connect) = initialize(input0)
let tree = makeTree(real, connect)
let total = calcTotal(tree)
let from = searchLongest(real[0], tree)
let longest = searchLongest(from.to, tree)
let result = (total - longest.cost) * 2 + longest.cost

print("M: \(M)")
print("N: \(N)")
print("real: \(real)")
print("connect: \(connect)")
print("tree: \(tree)")
print("total: \(total)")
print("longest: \(longest.cost)")
print("result: \(result)")
print("minCount: \(minCount)")
print("treeCount: \(treeCount)")

//let (M, N, real, connect) = read()
//let tree = makeTree(real, connect)
//let total = calcTotal(tree)
//let from = searchLongest(real[0], tree)
//let longest = searchLongest(from.to, tree)
//let result = (total - longest.cost) * 2 + longest.cost
//print(result)

