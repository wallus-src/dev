import SpriteKit

/// Renders pixel-art textures from string rows. Each character maps to a color
/// in `palette`; '.' or any unmapped character is transparent. Textures are
/// rendered at 1pt-per-pixel and scaled with nearest-neighbor for a crisp
/// retro look.
enum PixelArt {

    /// Shared color palette used by all sprite definitions.
    static let palette: [Character: UIColor] = [
        "k": UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1), // near-black outline
        "r": UIColor(red: 0.92, green: 0.15, blue: 0.18, alpha: 1), // red (cap/shirt)
        "R": UIColor(red: 0.60, green: 0.08, blue: 0.10, alpha: 1), // dark red
        "b": UIColor(red: 0.17, green: 0.36, blue: 0.90, alpha: 1), // blue (overalls)
        "B": UIColor(red: 0.10, green: 0.22, blue: 0.60, alpha: 1), // dark blue
        "s": UIColor(red: 1.00, green: 0.80, blue: 0.62, alpha: 1), // skin
        "S": UIColor(red: 0.88, green: 0.62, blue: 0.44, alpha: 1), // skin shadow
        "h": UIColor(red: 0.40, green: 0.22, blue: 0.07, alpha: 1), // hair brown
        "w": UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1), // white
        "y": UIColor(red: 1.00, green: 0.84, blue: 0.20, alpha: 1), // yellow
        "g": UIColor(red: 0.24, green: 0.75, blue: 0.24, alpha: 1), // green
        "G": UIColor(red: 0.10, green: 0.48, blue: 0.12, alpha: 1), // dark green
        "o": UIColor(red: 0.80, green: 0.48, blue: 0.17, alpha: 1), // goomba orange
        "O": UIColor(red: 0.52, green: 0.29, blue: 0.09, alpha: 1), // dark brown
        "t": UIColor(red: 0.78, green: 0.35, blue: 0.18, alpha: 1), // brick
        "T": UIColor(red: 0.55, green: 0.22, blue: 0.10, alpha: 1), // brick dark
        "p": UIColor(red: 0.36, green: 0.73, blue: 0.27, alpha: 1), // pipe green
        "P": UIColor(red: 0.16, green: 0.49, blue: 0.14, alpha: 1), // pipe dark
        "l": UIColor(red: 0.64, green: 0.89, blue: 0.56, alpha: 1), // pipe highlight
        "c": UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1), // cloud white
        "n": UIColor(red: 0.56, green: 0.40, blue: 0.30, alpha: 1), // castle tan
        "N": UIColor(red: 0.40, green: 0.26, blue: 0.16, alpha: 1), // castle dark
        "u": UIColor(red: 0.42, green: 0.26, blue: 0.14, alpha: 1), // hill dark
        "q": UIColor(red: 0.95, green: 0.62, blue: 0.10, alpha: 1), // question block gold
        "Q": UIColor(red: 0.75, green: 0.45, blue: 0.05, alpha: 1), // question dark
        "e": UIColor(red: 0.93, green: 0.55, blue: 0.24, alpha: 1), // metal block
        "E": UIColor(red: 0.68, green: 0.36, blue: 0.12, alpha: 1), // metal dark
        "a": UIColor(red: 0.99, green: 0.92, blue: 0.55, alpha: 1), // coin light
        "d": UIColor(red: 0.80, green: 0.56, blue: 0.10, alpha: 1), // coin dark
        "m": UIColor(red: 0.92, green: 0.28, blue: 0.20, alpha: 1), // mushroom cap
    ]

    private static var cache: [String: SKTexture] = [:]

    /// Build (or fetch) a texture for the given string-art rows.
    /// `rows` is top-to-bottom; row 0 is the top of the sprite.
    static func texture(_ name: String, _ rows: [String]) -> SKTexture {
        if let t = cache[name] { return t }
        let height = rows.count
        let width = rows.map { $0.count }.max() ?? 0
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        for (r, row) in rows.enumerated() {
            for (c, ch) in row.enumerated() where c < width {
                guard let col = palette[ch] else { continue }
                var rr: CGFloat = 0, gg: CGFloat = 0, bb: CGFloat = 0, aa: CGFloat = 0
                col.getRed(&rr, green: &gg, blue: &bb, alpha: &aa)
                let i = (r * width + c) * 4
                pixels[i] = UInt8(rr * 255)
                pixels[i + 1] = UInt8(gg * 255)
                pixels[i + 2] = UInt8(bb * 255)
                pixels[i + 3] = UInt8(aa * 255)
            }
        }
        let data = Data(pixels)
        let provider = CGDataProvider(data: data as CFData)!
        let image = CGImage(
            width: width, height: height,
            bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue),
            provider: provider, decode: nil,
            shouldInterpolate: false, intent: .defaultIntent
        )!
        let tex = SKTexture(cgImage: image)
        tex.filteringMode = .nearest
        cache[name] = tex
        return tex
    }

    /// Horizontal flip of a cached texture.
    static func flipped(_ name: String, _ rows: [String]) -> SKTexture {
        texture(name + "_flip", rows.map { String($0.reversed()) })
    }

    /// Convenience: make an animation action over named frames.
    static func animate(_ textures: [SKTexture], timePerFrame: Double) -> SKAction {
        SKAction.animate(with: textures, timePerFrame: timePerFrame, resize: false, restore: true)
    }
}

extension SKTexture {
    /// Create a sprite sized so `pixelWidth` game pixels occupy `points` points.
    func spriteNode(pixelHeight pts: CGFloat) -> SKSpriteNode {
        let node = SKSpriteNode(texture: self)
        node.texture?.filteringMode = .nearest
        let scale = pts / size().height
        node.size = CGSize(width: size().width * scale, height: pts)
        return node
    }
}
