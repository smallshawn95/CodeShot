import SwiftUI

/// 一張程式碼截圖的所有外觀設定。
///
/// 把所有設定集中在一個 struct 裡，好處是：
/// - 預覽卡片只要接收一個參數就好。
/// - 「重設」只要 `style = CodeStyle()` 一行。
/// - 之後要存檔（Codable）也很容易加。
struct CodeStyle {
    // 內容
    var code: String = CodeLanguage.swift.sampleCode

    /// 使用者只輸入主檔名，不含副檔名。
    var baseName: String = "Hello"
    var language: CodeLanguage = .swift

    /// 卡片標題列真正顯示的檔名，副檔名由語言決定。
    var fileName: String {
        let name = baseName.trimmingCharacters(in: .whitespacesAndNewlines)
        let shown = name.isEmpty ? "未命名" : name
        let ext = language.fileExtension

        guard !ext.isEmpty else { return shown }

        // 使用者如果自己打了副檔名，就不要重複加一次。
        if shown.lowercased().hasSuffix("." + ext) { return shown }
        return shown + "." + ext
    }

    // 字型
    var fontFamily: CodeFontFamily = .sfMono
    var fontSize: Double = 16
    var isBold: Bool = false

    // 顏色
    var textColor: Color = Color(red: 0.87, green: 0.91, blue: 1.00)
    var backgroundColor: Color = Color(red: 0.10, green: 0.11, blue: 0.15)
    var headerColor: Color = Color(red: 0.15, green: 0.16, blue: 0.21)

    // 版面
    var showsHeader: Bool = true
    var showsWindowButtons: Bool = true
    var showsLineNumbers: Bool = true
    var padding: Double = 24
    var lineSpacing: Double = 6
    var cornerRadius: Double = 20
}

/// 可選的等寬字型。
///
/// 前 6 種是 iOS 內建的。Fira Code 和 JetBrains Mono 的 .ttf 已經放在
/// `CodeShot/Fonts/`，也已經加進 Copy Bundle Resources、並在
/// Info.plist 的 UIAppFonts 註冊過，所以選單選了就有效。
///
/// 之後想再加字型（例如 IBM Plex Mono）只要三步：
/// 1. 把 .ttf 拖進 Xcode 的 Fonts group（勾 Copy items if needed、Add to targets）。
/// 2. 到 Info.plist 的 UIAppFonts 陣列補上檔名。
/// 3. 下面加一個 case，填入該字型的 PostScript 名稱。
///
/// 注意：PostScript 名稱不是檔名，要用「字型書（Font Book）」查。
/// 名稱打錯不會報錯，只會默默變回系統字型。
enum CodeFontFamily: String, CaseIterable, Identifiable {
    case sfMono
    case menlo
    case monaco
    case courierNew
    case andaleMono
    case firaCode
    case jetBrainsMono
    case system

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sfMono: return "SF Mono"
        case .menlo: return "Menlo"
        case .monaco: return "Monaco"
        case .courierNew: return "Courier New"
        case .andaleMono: return "Andale Mono"
        case .firaCode: return "Fira Code"
        case .jetBrainsMono: return "JetBrains Mono"
        case .system: return "系統字型"
        }
    }

    func font(size: Double, isBold: Bool) -> Font {
        let weight: Font.Weight = isBold ? .bold : .regular

        switch self {
        case .sfMono:
            return .system(size: size, weight: weight, design: .monospaced)
        case .menlo:
            return .custom("Menlo", size: size).weight(weight)
        case .monaco:
            return .custom("Monaco", size: size).weight(weight)
        case .courierNew:
            return .custom("Courier New", size: size).weight(weight)
        case .andaleMono:
            return .custom("Andale Mono", size: size).weight(weight)
        case .firaCode:
            // 這兩個是自己附帶的字型，直接指定 PostScript 名稱最保險。
            return .custom(isBold ? "FiraCode-Bold" : "FiraCode-Regular", size: size)
        case .jetBrainsMono:
            return .custom(isBold ? "JetBrainsMono-Bold" : "JetBrainsMono-Regular", size: size)
        case .system:
            return .system(size: size, weight: weight, design: .default)
        }
    }
}
