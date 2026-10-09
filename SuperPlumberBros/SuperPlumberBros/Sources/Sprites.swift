import SpriteKit

/// All sprite art, defined as rows of characters mapped through PixelArt.palette.
/// Everything here is original pixel art drawn for this game.
enum Art {

    // MARK: - Player (small, 16x16)

    static let playerIdle = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhssssss....",
        "..hsssssksss....",
        "..hsssssssss....",
        "..hhsskkkkss....",
        "...ssssssss.....",
        "...rrbbbbbrr....",
        "..rrrbbbbbrrr...",
        "..rrrbbbybrrr...",
        "..ssrbbbbbrss...",
        "..ssbbbbbbbss...",
        "...bbbbbbb......",
        "...ooo..ooo.....",
        "..oooo..oooo....",
    ]

    static let playerRun1 = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhssssss....",
        "..hsssssksss....",
        "..hsssssssss....",
        "..hhsskkkkss....",
        "...ssssssss.....",
        "....rrbbbbbrr...",
        "..rrrrbbbbbrrr..",
        ".rrrrrbbbybrr...",
        ".ssrrbbbbbrsss..",
        "..srbbbbbbbs....",
        "...bbbbbbbb.....",
        "..oooo..oooo....",
        ".oooo.....ooo...",
    ]

    static let playerRun2 = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhssssss....",
        "..hsssssksss....",
        "..hsssssssss....",
        "..hhsskkkkss....",
        "...ssssssss.....",
        "...rrbbbbbrr....",
        "..rrrbbbbbrrr...",
        "..rrrbbbybrrr...",
        "..ssrbbbbbrss...",
        "..sssbbbbbss....",
        "...bbbbbbb......",
        "....oo.ooo......",
        "...oo....oooo...",
    ]

    static let playerJump = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhssssss....",
        "..hsssssksss....",
        "..hsssssssss....",
        "..hhsskkkkss....",
        "...ssssssss.....",
        "..rrrbbbbbrrr...",
        ".rrrrbbbybrrrr..",
        ".sssrbbbbbrsss..",
        ".sssbbbbbbsss...",
        "..bbbbbbbbbb....",
        "..oooo..oooo....",
        ".oooo....ooo....",
        "................",
    ]

    static let playerSkid = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhssssss....",
        "..hsssssksss....",
        "..hsssssssss....",
        "..hhsskkkkss....",
        "...ssssssss.....",
        "....rrbbbbbrr...",
        "...rrrbbbbbrr...",
        "..sssrbbbybr....",
        "..sssbbbbbr.....",
        "...sbbbbbbb.....",
        "....bbbbbb......",
        "....oooo.ooo....",
        "...oooo...ooo...",
    ]

    static let playerDead = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "...hhhhhhhhh....",
        "..hsskssskssh...",
        "..hsssssssssh...",
        "..hhsssssssh....",
        "...ssssssss.....",
        "...rrbbbbbrr....",
        "..rrrbbbbbrrr...",
        "..ssrbbbybrrs...",
        "..sssbbbbbsss...",
        "...bbbbbbbbb....",
        "...ooo...ooo....",
        "..ooo.....ooo...",
        "................",
    ]

    // MARK: - Player (big, 16x32)

    static let playerBigIdle = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrrrrrrrr...",
        "..hhhhssssss....",
        "..hssssskssss...",
        "..hssssssssss...",
        "..hssssssssss...",
        "...hhskkkkss....",
        "....ssssssss....",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrbbbbrrrr..",
        "..rrrbbbbbbrrr..",
        ".rrrrbbbybbbrrr.",
        ".rssbbbbbbbbssr.",
        ".sssbbbbbbbbsss.",
        ".sssbbbbybbssss.",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "...bbbbbbbbbb...",
        "...bbbbbbbbbb...",
        "...bbbb.bbbb....",
        "...bbbb..bbb....",
        "...oooo..oooo...",
        "..ooooo..ooooo..",
        "..ooooo..ooooo..",
        "................",
    ]

    static let playerBigRun1 = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrrrrrrrr...",
        "..hhhhssssss....",
        "..hssssskssss...",
        "..hssssssssss...",
        "..hssssssssss...",
        "...hhskkkkss....",
        "....ssssssss....",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrbbbbrrrr..",
        "..rrrbbbbbbrrr..",
        ".rrrrbbbybbbrrr.",
        ".rssbbbbbbbbssr.",
        ".sssbbbbbbbbsss.",
        "..ssbbbbybbss...",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "...bbbbbbbbb....",
        "...bbbb.bbbbb...",
        "..oooo....bbbb..",
        "..oooo....bbbb..",
        ".ooooo....ooooo.",
        ".ooooo....ooooo.",
        ".oooo.....oooo..",
        "................",
    ]

    static let playerBigRun2 = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrrrrrrrr...",
        "..hhhhssssss....",
        "..hssssskssss...",
        "..hssssssssss...",
        "..hssssssssss...",
        "...hhskkkkss....",
        "....ssssssss....",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrbbbbrrrr..",
        "..rrrbbbbbbrrr..",
        ".rrrrbbbybbbrrr.",
        ".rssbbbbbbbbssr.",
        ".sssbbbbbbbbsss.",
        ".sssbbbbybbssss.",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbbb...",
        "...bbbbbbbbbb...",
        "...bbbb..bbbb...",
        "...bbb....bbb...",
        "...oooo...oooo..",
        "..ooooo..ooooo..",
        "..ooooo..ooooo..",
        "..oooo....oooo..",
        "................",
    ]

    static let playerBigJump = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrrrrrrrr...",
        "..hhhhssssss....",
        "..hssssskssss...",
        "..hssssssssss...",
        "..hssssssssss...",
        "...hhskkkkss....",
        "....ssssssss....",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrbbbbrrrr..",
        "..rrrbbbbbbrrr..",
        ".rrrrbbbybbbrrr.",
        "rrssbbbbbbbbssrr",
        "sssbbbbbbbbbbsss",
        "sssbbbbybbbbbss.",
        "ss.bbbbbbbbb.ss.",
        "...bbbbbbbbbb...",
        "...bbbbbbbbbb...",
        "...bbbbbbbbbb...",
        "...bbbbbbbbbb...",
        "...bbbb.bbbbb...",
        "..oooo....bbbb..",
        "..oooo....bbb...",
        ".ooooo....bbbb..",
        ".ooooo....oooo..",
        ".oooo....ooooo..",
        "................",
        "................",
    ]

    static let playerBigSkid = [
        "................",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "..rrrrrrrrrrr...",
        "..hhhhssssss....",
        "..hssssskssss...",
        "..hssssssssss...",
        "..hssssssssss...",
        "...hhskkkkss....",
        "....ssssssss....",
        "....rrrrrrr.....",
        "...rrrrrrrrrr...",
        "....rrrbbbbrrr..",
        "....rrbbbbbbrr..",
        "...rsrbbbybbbr..",
        "..sssbbbbbbbbr..",
        "..sssbbbbybbb...",
        "..ss.bbbbbbbb...",
        ".....bbbbbbbb...",
        ".....bbbbbbb....",
        ".....bbbbbbbb...",
        ".....bbbbbbbb...",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....bbbbbbbb....",
        "....oooo.oooo...",
        "...ooooo.ooooo..",
        "..ooooo..ooooo..",
        "..oooo....ooo...",
        "................",
    ]

    // MARK: - Enemies

    static let goombaWalk1 = [
        "................",
        ".....oooooo.....",
        "....oooooooo....",
        "...oooooooooo...",
        "..ookkoooookoo..",
        ".ookwwkoowkwoo..",
        ".ookkokoookkoo..",
        ".oooooooooooo...",
        "oooooooooooooo..",
        "OooooooooooooO..",
        "OOooooooooooOO..",
        ".OOooooooooOO...",
        "..OOOooooOOO....",
        "...kkkkkkkk.....",
        "..kkkkkkkkkk....",
        ".kkkkk..kkkkk...",
    ]

    static let goombaWalk2 = [
        "................",
        ".....oooooo.....",
        "....oooooooo....",
        "...oooooooooo...",
        "..ookkoooookoo..",
        ".ookwwkoowkwoo..",
        ".ookkokoookkoo..",
        ".oooooooooooo...",
        "oooooooooooooo..",
        "OooooooooooooO..",
        "OOooooooooooOO..",
        ".OOooooooooOO...",
        "..OOOooooOOO....",
        "..kkkkkkkkk.....",
        ".kkkkkkkkkkk....",
        "kkkkk...kkkkk...",
    ]

    static let goombaSquash = [
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "................",
        "..oooooooooo....",
        ".ookkoooookkoo..",
        "oooooooooooooooo",
        "kkkkkkkkkkkkkkkk",
        "................",
    ]

    static let koopaWalk1 = [
        "................",
        ".....kkk........",
        "....kyyk........",
        "...kyyyk........",
        "..kyykyk........",
        "..kyyyyk........",
        "..kyyyykss......",
        "...kyyys.......",
        "....ggggg.......",
        "..ggggggggg.....",
        ".gwwwggggggg....",
        ".gwwwgggggggg...",
        "gggwwggggggggg..",
        "gggggggggggggg..",
        ".ggggggggggggg..",
        "....kkk..kkk....",
        "...kkk....kkk...",
        "..kkk.....kkk...",
        "..kkk.....kkk...",
        "................",
    ]

    static let koopaWalk2 = [
        "................",
        ".....kkk........",
        "....kyyk........",
        "...kyyyk........",
        "..kyykyk........",
        "..kyyyyk........",
        "..kyyyykss......",
        "...kyyys.......",
        "....ggggg.......",
        "..ggggggggg.....",
        ".gwwwggggggg....",
        ".gwwwgggggggg...",
        "gggwwggggggggg..",
        "gggggggggggggg..",
        ".ggggggggggggg..",
        "....kkk.kkk.....",
        "...kkk..kkk.....",
        "...kkk..kkk.....",
        "....kkk.kkk.....",
        "................",
    ]

    static let koopaShell = [
        "................",
        "................",
        "................",
        "................",
        "....ggggggg.....",
        "..gggggggggg....",
        ".gggggggggggg...",
        "gwwggggggggggg..",
        "gwwwgggggggggg..",
        "gggggggggggggg..",
        "gggggggggggggg..",
        ".gggggggggggg...",
        "..gggggggggg....",
        "....kkkkkkk.....",
        "................",
        "................",
    ]

    // MARK: - Items

    static let mushroom = [
        "................",
        "....mmmmmmm.....",
        "..mmmmmmmmmmm...",
        ".mmwwmmmmwwmmm..",
        ".mwwwmmmmmwwwm..",
        ".mwwwmmmmmwwwm..",
        ".mmmmmmmmmmmmm..",
        "..mmmmmmmmmmm...",
        "...sssssssss....",
        "...sksssksss....",
        "...sssssssss....",
        "...sssssssss....",
        "....sssssss.....",
        "................",
        "................",
        "................",
    ]

    static let coinSpin1 = [
        "................",
        "....dddddd......",
        "...daaaaaad.....",
        "..daaaaaaaad....",
        "..daaaawaaad....",
        "..daaaawaaad....",
        "..daaaawaaad....",
        "..daaaawaaad....",
        "..daaaawaaad....",
        "..daaaawaaad....",
        "..daaaaaaaad....",
        "...daaaaaad.....",
        "....dddddd......",
        "................",
        "................",
        "................",
    ]

    static let coinSpin2 = [
        "................",
        ".....dddd.......",
        "....daaaad......",
        "....daawad......",
        "....daawad......",
        "....daawad......",
        "....daawad......",
        "....daawad......",
        "....daawad......",
        "....daawad......",
        "....daaaad......",
        "....daaaad......",
        ".....dddd.......",
        "................",
        "................",
        "................",
    ]

    static let coinSpin3 = [
        "................",
        "......dd........",
        "......ad........",
        "......ad........",
        "......ad........",
        "......ad........",
        "......wd........",
        "......ad........",
        "......ad........",
        "......ad........",
        "......ad........",
        "......ad........",
        "......dd........",
        "................",
        "................",
        "................",
    ]

    // MARK: - Tiles (16x16)

    static let groundTop = [
        "gggggggggggggggg",
        "GggGggGggGggGggG",
        "gGggGggGggGggGgg",
        "gggggggggggggggg",
        "oooooooooooooooo",
        "ooOoooooOooooOoo",
        "oooooooooooooooo",
        "ooooOoooooooOooo",
        "oooooooooooooooo",
        "oOooooooOooooooo",
        "oooooooooooooooo",
        "oooooOooooooOooo",
        "oooooooooooooooo",
        "ooOoooooooOooooo",
        "oooooooooooooooo",
        "oooooooooooooooo",
    ]

    static let groundFill = [
        "oooooooooooooooo",
        "ooOoooooOooooOoo",
        "oooooooooooooooo",
        "ooooOoooooooOooo",
        "oooooooooooooooo",
        "oOooooooOooooooo",
        "oooooooooooooooo",
        "oooooOooooooOooo",
        "oooooooooooooooo",
        "ooOoooooooOooooo",
        "oooooooooooooooo",
        "ooooOooooooooOoo",
        "oooooooooooooooo",
        "oOooooooOooooooo",
        "oooooooooooooooo",
        "oooooooooooooooo",
    ]

    static let brick = [
        "tttttttttttttttt",
        "tTtttTTttttTTttT",
        "tttttttttttttttt",
        "ttTttTTttttTTttt",
        "tttttttttttttttt",
        "tTtttTTttttTTttT",
        "tttttttttttttttt",
        "ttTttTTttttTTttt",
        "tttttttttttttttt",
        "tTtttTTttttTTttT",
        "tttttttttttttttt",
        "ttTttTTttttTTttt",
        "tttttttttttttttt",
        "tTtttTTttttTTttT",
        "tttttttttttttttt",
        "ttTttTTttttTTttt",
    ]

    static let blockUsed = [
        "eeeeeeeeeeeeeeee",
        "eEEEEEEEEEEEEEEe",
        "eEkkEEEEEEEEkkeE",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEEEEEEEEEEEEEEe",
        "eEkkEEEEEEEEkkeE",
        "eEEEEEEEEEEEEEEe",
        "eeeeeeeeeeeeeeee",
    ]

    static let question1 = [
        "qqqqqqqqqqqqqqqq",
        "qkkqqqqqqqqqqkkq",
        "qqqqwwwwwqqqqqqq",
        "qqqwwQQQwwqqqqqq",
        "qqwwQQqqQwwqqqqq",
        "qqwwQqqqqwQqqqqq",
        "qqqqqqqqwQqqqqqq",
        "qqqqqqwwQqqqqqqq",
        "qqqqqwwQqqqqqqqq",
        "qqqqqwQqqqqqqqqq",
        "qqqqqwwqqqqqqqqq",
        "qqqqqqqqqqqqqqqq",
        "qqqqqwwqqqqqqqqq",
        "qkkqqwQqqqqqqkkq",
        "qqqqqqqqqqqqqqqq",
        "qqqqqqqqqqqqqqqq",
    ]

    static let question2 = [
        "qqqqqqqqqqqqqqqq",
        "qkkqqqqqqqqqqkkq",
        "qqqqwwwwwqqqqqqq",
        "qqqwwQQQwwqqqqqq",
        "qqwwQQqqQwwqqqqq",
        "qqwwQqqqqwQqqqqq",
        "qqqqqqqqwQqqqqqq",
        "qqqqqqwwQqqqqqqq",
        "qqqqqwwQqqqqqqqq",
        "qqqqqwQqqqqqqqqq",
        "qqqqqwwqqqqqqqqq",
        "qqqqqqqqqqqqqqqq",
        "qqqqqwwqqqqqqqqq",
        "qkkqqwQqqqqqqkkq",
        "qqqqqqqqqqqqqqqq",
        "qqqqqqqqqqqqqqqq",
    ]

    static let question3 = [
        "QQQQQQQQQQQQQQQQ",
        "QkkQQQQQQQQQQkkQ",
        "QQQQwwwwwQQQQQQQ",
        "QQQwwQQQwwQQQQQQ",
        "QQwwQQQQQwQQQQQQ",
        "QQwwQQQQQwQQQQQQ",
        "QQQQQQQQwQQQQQQQ",
        "QQQQQQwwQQQQQQQQ",
        "QQQQQwwQQQQQQQQQ",
        "QQQQQwQQQQQQQQQQ",
        "QQQQQwwQQQQQQQQQ",
        "QQQQQQQQQQQQQQQQ",
        "QQQQQwwQQQQQQQQQ",
        "QkkQQwQQQQQQQkkQ",
        "QQQQQQQQQQQQQQQQ",
        "QQQQQQQQQQQQQQQQ",
    ]

    static let stoneBlock = [
        "nnnnnnnnnnnnnnnn",
        "nNNNNNNNNNNNNNNn",
        "nNknnnnnnnnnnkNn",
        "nNNNNNNNNNNNNNNn",
        "nnnnnnnknnnnnnnn",
        "nnnnnnnknnnnnnnn",
        "nnNNNNNNNNNNNNNn",
        "nnNknnnnnnnnnkNn",
        "nnNNNNNNNNNNNNNn",
        "nnnnnnnnnnknnnnn",
        "nnnnnnnnnnknnnnn",
        "nnNNNNNNNNNNNNNn",
        "nnNknnnnnnnnnkNn",
        "nnNNNNNNNNNNNNNn",
        "nnnnnnnnnnnnnnnn",
        "nnnnnnnnnnnnnnnn",
    ]

    // MARK: - Pipe tiles (16x16 each; pipe is 2 columns wide)

    static let pipeTopLeft = [
        "pppppppppppppppp",
        "pPPPPPPPPPPPPPPp",
        "pPlllllllllllPPp",
        "pPlllllllllllPPp",
        "pPlPPPPPPPPPPPPp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
    ]

    static let pipeTopRight = [
        "pppppppppppppppp",
        "pPPPPPPPPPPPPPpP",
        "pPPllllllllllPpP",
        "pPPllllllllllPpP",
        "pPPPPPPPPPPPlPpP",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
    ]

    static let pipeBodyLeft = [
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
        "pPlPllllllllPPpp",
    ]

    static let pipeBodyRight = [
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
        "ppPPllllllllPlPp",
    ]

    // MARK: - Scenery

    static let hill = [
        "................",
        "................",
        "......gg........",
        ".....gggg.......",
        "....gggggg......",
        "...gggggggg.....",
        "..gggggggggg....",
        ".gggggggggggg...",
        "gggggggggggggg..",
        "gkgkgggkggkggkg.",
    ]

    static let cloud = [
        "................",
        "....cccc........",
        "...cccccc.......",
        "..cccccccc.cc...",
        ".ccccccccccccc..",
        "ccccccccccccccc.",
        "................",
    ]

    static let bush = [
        "................",
        "................",
        "....gg...gg.....",
        "..ggggg.gggg....",
        ".gggggggggggg...",
        "gggggggggggggg..",
    ]

    static let flagPennant = [
        "mmmmmmmm........",
        "mmmmmmmmmmmm....",
        "mmmmmmmmmmmmmmm.",
        "mmmmmmmmmmmm....",
        "mmmmmmmm........",
        "................",
    ]

    static let flagBall = [
        "..yy..",
        ".yyyy.",
        "yyyyyy",
        "yyyyyy",
        ".yyyy.",
        "..yy..",
    ]

    static let castle = [
        "..........nn............nn............nn..........",
        "..........nn............nn............nn..........",
        "..........nn............nn............nn..........",
        "......nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn......",
        "......nNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNn......",
        "......nNnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnNNn......",
        "......nNnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnNNn......",
        "......nNnnnNNnnnnnNNnnnnnnnnnNNnnnnnNNnnNNn......",
        "......nNnnnNNnnnnnNNnnnnnnnnnNNnnnnnNNnnNNn......",
        "......nNnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnNNn......",
        "......nNnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnNNn......",
        "......nNNNNNNNNNNNNNNNkkNNNNNNNNNNNNNNNNNNn......",
        "......nnnnnnnnnnnnnnnnkKknnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnnkKknnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnnkKknnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnnkKknnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnnkKknnnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
        "......nnnnnnnnnnnnnnnkkKKknnnnnnnnnnnnnnnn......",
    ]

    // MARK: - Texture accessors

    static var texPlayerIdle: SKTexture { PixelArt.texture("playerIdle", playerIdle) }
    static var texPlayerRun1: SKTexture { PixelArt.texture("playerRun1", playerRun1) }
    static var texPlayerRun2: SKTexture { PixelArt.texture("playerRun2", playerRun2) }
    static var texPlayerJump: SKTexture { PixelArt.texture("playerJump", playerJump) }
    static var texPlayerSkid: SKTexture { PixelArt.texture("playerSkid", playerSkid) }
    static var texPlayerDead: SKTexture { PixelArt.texture("playerDead", playerDead) }
    static var texPlayerBigIdle: SKTexture { PixelArt.texture("playerBigIdle", playerBigIdle) }
    static var texPlayerBigRun1: SKTexture { PixelArt.texture("playerBigRun1", playerBigRun1) }
    static var texPlayerBigRun2: SKTexture { PixelArt.texture("playerBigRun2", playerBigRun2) }
    static var texPlayerBigJump: SKTexture { PixelArt.texture("playerBigJump", playerBigJump) }
    static var texPlayerBigSkid: SKTexture { PixelArt.texture("playerBigSkid", playerBigSkid) }
    static var texGoomba1: SKTexture { PixelArt.texture("goomba1", goombaWalk1) }
    static var texGoomba2: SKTexture { PixelArt.texture("goomba2", goombaWalk2) }
    static var texGoombaSquash: SKTexture { PixelArt.texture("goombaSquash", goombaSquash) }
    static var texKoopa1: SKTexture { PixelArt.texture("koopa1", koopaWalk1) }
    static var texKoopa2: SKTexture { PixelArt.texture("koopa2", koopaWalk2) }
    static var texKoopaShell: SKTexture { PixelArt.texture("koopaShell", koopaShell) }
    static var texMushroom: SKTexture { PixelArt.texture("mushroom", mushroom) }
    static var texCoin1: SKTexture { PixelArt.texture("coin1", coinSpin1) }
    static var texCoin2: SKTexture { PixelArt.texture("coin2", coinSpin2) }
    static var texCoin3: SKTexture { PixelArt.texture("coin3", coinSpin3) }
    static var texGroundTop: SKTexture { PixelArt.texture("groundTop", groundTop) }
    static var texGroundFill: SKTexture { PixelArt.texture("groundFill", groundFill) }
    static var texBrick: SKTexture { PixelArt.texture("brick", brick) }
    static var texBlockUsed: SKTexture { PixelArt.texture("blockUsed", blockUsed) }
    static var texQuestion1: SKTexture { PixelArt.texture("question1", question1) }
    static var texQuestion2: SKTexture { PixelArt.texture("question2", question2) }
    static var texQuestion3: SKTexture { PixelArt.texture("question3", question3) }
    static var texStone: SKTexture { PixelArt.texture("stone", stoneBlock) }
    static var texPipeTL: SKTexture { PixelArt.texture("pipeTL", pipeTopLeft) }
    static var texPipeTR: SKTexture { PixelArt.texture("pipeTR", pipeTopRight) }
    static var texPipeBL: SKTexture { PixelArt.texture("pipeBL", pipeBodyLeft) }
    static var texPipeBR: SKTexture { PixelArt.texture("pipeBR", pipeBodyRight) }
    static var texHill: SKTexture { PixelArt.texture("hill", hill) }
    static var texCloud: SKTexture { PixelArt.texture("cloud", cloud) }
    static var texBush: SKTexture { PixelArt.texture("bush", bush) }
    static var texFlag: SKTexture { PixelArt.texture("flagPennant", flagPennant) }
    static var texFlagBall: SKTexture { PixelArt.texture("flagBall", flagBall) }
    static var texCastle: SKTexture { PixelArt.texture("castle", castle) }
}
