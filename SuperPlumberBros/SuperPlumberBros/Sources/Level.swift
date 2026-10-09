import SpriteKit

enum Tile: UInt8 {
    case empty = 0
    case ground, brick, questionCoin, questionMushroom, used, stone
    case pipeTopLeft, pipeTopRight, pipeBodyLeft, pipeBodyRight

    var isSolid: Bool { self != .empty }
}

enum SpawnKind {
    case goomba, koopa
}

struct Spawn {
    let kind: SpawnKind
    let col: Int
}

/// Builds the level grid and spawn list. Layout is an original design in the
/// spirit of classic side-scrolling platformers: ? blocks, pipes, pits,
/// staircases, a flagpole, and a castle at the end.
struct LevelDef {
    let width: Int
    let height: Int
    var grid: [[Tile]]
    private(set) var spawns: [Spawn] = []
    private(set) var coins: [(col: Int, row: Int)] = []
    private(set) var playerStartCol = 3
    private(set) var flagpoleCol = 0
    private(set) var castleCol = 0

    init() {
        width = 184
        height = 15
        grid = [[Tile]](repeating: [Tile](repeating: .empty, count: width), count: height)

        // Two rows of ground, with three pits.
        for c in 0 ..< width {
            grid[13][c] = .ground
            grid[14][c] = .ground
        }
        carvePit(58, 3)
        carvePit(96, 3)
        carvePit(128, 3)

        // Opening stretch: a coin block, then a brick row.
        set(20, 9, .questionCoin)
        set(24, 9, .brick)
        set(25, 9, .questionCoin)
        set(26, 9, .brick)
        set(27, 9, .questionMushroom)
        set(28, 9, .brick)
        set(26, 5, .brick)

        // Pipe run of increasing height.
        pipe(32, 2)
        pipe(38, 3)
        pipe(44, 4)
        pipe(50, 4)

        enemy(.goomba, 22)
        enemy(.goomba, 36)
        enemy(.goomba, 40)

        // Coins hanging over the first pit.
        coinRow(56, 8, 4)

        // Block island + a high brick.
        set(64, 9, .brick)
        set(65, 9, .questionCoin)
        set(66, 9, .brick)
        set(65, 5, .questionMushroom)
        enemy(.koopa, 70)

        // Twin staircases facing each other across a jump gap.
        stairs(76, [1, 2, 3, 4])
        stairs(84, [4, 3, 2, 1])

        enemy(.goomba, 90)
        enemy(.goomba, 91)

        // Mid-level brick + question cluster.
        set(102, 9, .brick)
        set(103, 9, .questionCoin)
        set(104, 9, .brick)
        set(105, 9, .brick)
        set(104, 5, .brick)
        coinRow(110, 8, 3)
        set(114, 9, .questionMushroom)
        enemy(.koopa, 118)
        set(120, 9, .brick)
        set(121, 9, .brick)
        set(122, 9, .questionCoin)
        set(123, 9, .brick)
        coinRow(121, 5, 3)

        // Second pipe section.
        pipe(134, 2)
        pipe(139, 3)
        pipe(144, 3)
        enemy(.goomba, 147)
        enemy(.goomba, 149)
        enemy(.koopa, 154)

        set(150, 9, .brick)
        set(151, 9, .questionCoin)
        set(152, 9, .brick)
        coinRow(150, 5, 3)

        // Grand staircase up to the flagpole, then the castle.
        stairs(160, [1, 2, 3, 4, 5, 6, 7, 8])
        flagpoleCol = 172
        castleCol = 176
    }

    private mutating func set(_ col: Int, _ row: Int, _ t: Tile) {
        guard col >= 0, col < width, row >= 0, row < height else { return }
        grid[row][col] = t
    }

    private mutating func carvePit(_ col: Int, _ w: Int) {
        for c in col ..< col + w {
            grid[13][c] = .empty
            grid[14][c] = .empty
        }
    }

    private mutating func pipe(_ col: Int, _ h: Int) {
        // Pipe occupies columns col..col+1 and rows 13-h..12; top row has a lip.
        let topRow = 13 - h
        set(col, topRow, .pipeTopLeft)
        set(col + 1, topRow, .pipeTopRight)
        for r in topRow + 1 ..< 13 {
            set(col, r, .pipeBodyLeft)
            set(col + 1, r, .pipeBodyRight)
        }
    }

    private mutating func stairs(_ col: Int, _ heights: [Int]) {
        for (i, h) in heights.enumerated() {
            for r in 13 - h ..< 13 {
                set(col + i, r, .stone)
            }
        }
    }

    private mutating func coinRow(_ col: Int, _ row: Int, _ n: Int) {
        for i in 0 ..< n { coins.append((col + i, row)) }
    }

    private mutating func enemy(_ kind: SpawnKind, _ col: Int) {
        spawns.append(Spawn(kind: kind, col: col))
    }

    func tile(at col: Int, row: Int) -> Tile {
        guard col >= 0, col < width, row >= 0, row < height else {
            // Left edge is a wall; everything else out of bounds is open air.
            return col < 0 ? .stone : .empty
        }
        return grid[row][col]
    }
}
