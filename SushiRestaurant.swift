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

func calcWays(_ real: [Int], _ connect:[[Int]]) -> ([[Int]]) {
    var E = real
    var ways = [[Int]]()

    for a in 0..<E.count {
        for b in a+1..<E.count {
            treeCount = treeCount + 1
            ways.append(min(E[a], E[b], connect))
        }
    }

    return ways
}

func calcTotal(_ ways: [[Int]], _ M: Int) -> Int {
    var seen = [[Bool]](repeating: [Bool](repeating: false, count: M), count: M)
    var a = 0
    var b = 0
    var count = 0
    for way in ways {
        for i in 1..<way.count {
            if way[i - 1] > way[i] {
                a = way[i]
                b = way[i - 1]
            } else {
                a = way[i - 1]
                b = way[i]
            }

            if seen[a][b] {
                continue
            }

            seen[a][b] = true
            count = count + 1
        }
    }
    
    return count
}

func min(_ from: Int, _ to: Int, _ connect: [[Int]]) -> [Int] {
    var table = [[Int]](repeating: [Int](repeating: INF, count: connect.count), count: connect.count)
    var result = [Int]()
    _min(from, to, connect, 1, &table, &result, [from])
    return result
}

func _min(_ from: Int, _ to: Int, _ connect: [[Int]], _ cost: Int, _ table: inout [[Int]], _ result: inout [Int], _ ways: [Int]) {
    if result.count != 0 { return }
    minCount = minCount + 1
    var temp = [[Int]]()
    for middle in connect[from] {
        if table[from][middle] > cost {
            table[from][middle] = cost
            if middle == to {
                result = ways + [to]
                return
            }
            //_min(middle, to, connect, 1 + cost, &table, &result)
            temp.append(ways + [middle])
        }
    }

    for t in temp {
        _min(t[t.count - 1], to, connect, 1 + cost, &table, &result, t)
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
var input12 = "100 7\n58 94 36 37 69 6 65\n29 37\n2 31\n31 48\n79 31\n15 4\n51 31\n31 45\n31 6\n72 39\n31 36\n4 31\n77 31\n42 0\n49 42\n31 84\n33 31\n31 24\n31 20\n31 95\n17 31\n7 31\n31 90\n31 53\n16 31\n98 31\n47 31\n3 64\n31 60\n21 31\n31 13\n52 31\n88 31\n23 46\n55 74\n31 68\n31 86\n61 31\n8 31\n31 49\n41 31\n31 96\n99 31\n87 31\n19 31\n95 63\n38 31\n34 31\n66 31\n82 81\n12 31\n31 35\n92 31\n31 89\n30 31\n52 83\n31 75\n31 25\n43 31\n31 11\n31 57\n91 31\n80 31\n14 31\n50 28\n31 76\n31 54\n71 31\n31 85\n31 69\n92 58\n31 27\n94 28\n23 31\n97 31\n31 1\n31 29\n67 31\n40 31\n44 31\n31 59\n31 65\n70 31\n31 93\n64 31\n18 31\n31 81\n31 26\n42 9\n32 39\n31 73\n5 40\n31 94\n31 56\n31 10\n39 60\n22 54\n64 55\n31 78\n31 62"
// 14
var input13 = "100 8\n25 47 93 2 69 21 46 42\n99 87\n26 73\n45 11\n88 90\n12 67\n83 15\n1 82\n89 9\n21 0\n17 64\n80 27\n8 86\n37 44\n8 92\n75 60\n5 60\n34 29\n59 62\n26 53\n64 49\n86 14\n72 74\n35 90\n66 26\n68 32\n56 52\n81 30\n22 91\n81 82\n0 41\n73 72\n71 2\n22 87\n58 83\n6 26\n61 51\n1 76\n88 19\n67 3\n4 55\n97 73\n90 56\n60 36\n75 94\n38 29\n28 10\n23 81\n91 0\n50 66\n53 65\n16 55\n89 42\n86 77\n55 18\n33 28\n43 59\n20 34\n71 45\n82 40\n20 17\n45 57\n95 17\n70 24\n70 80\n7 21\n7 57\n40 57\n72 85\n98 11\n84 80\n47 31\n18 28\n38 48\n70 20\n69 67\n69 33\n88 46\n63 37\n43 78\n47 51\n9 51\n46 25\n15 32\n47 13\n22 86\n52 68\n2 93\n36 17\n96 43\n59 15\n87 54\n90 79\n3 94\n39 21\n7 56\n50 83\n21 5\n44 21\n31 66"
// 40

//let (M, N, real, connect) = initialize(input13)
//print("min \(min(0, 50, connect))")

//let (M, N, real, connect) = initialize(input13)
//let ways = calcWays(real, connect)
//let longest = ways.max(by: { $0.count < $1.count })!
//let total = calcTotal(ways, M)
//let result = (total - (longest.count - 1)) * 2 + longest.count - 1
//
//print("M: \(M)")
//print("N: \(N)")
//print("real: \(real)")
//print("connect: \(connect)")
//print("ways: \(ways)")
//print("total: \(total)")
//print("longest: \(longest)")
//print("min \(min(36, 65, connect))")
//print("result: \(result)")
//print("minCount: \(minCount)")
//print("treeCount: \(treeCount)")

let (M, N, real, connect) = read()
let ways = calcWays(real, connect)
let longest = ways.max(by: { $0.count < $1.count })!
let total = calcTotal(ways, M)
let result = (total - (longest.count - 1)) * 2 + longest.count - 1
print(result)
