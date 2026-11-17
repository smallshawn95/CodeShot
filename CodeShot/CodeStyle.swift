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
/// 這裡列的都是 iOS 內建、不需要另外安裝的字型，
/// 所以每一種選了都一定看得到效果。
///
/// 想加 Fira Code / JetBrains Mono 這類字型的話，只要三步：
/// 1. 把字型的 .ttf 拖進 Xcode 專案（勾 Copy items if needed、Add to target）。
/// 2. 在 Info.plist 加一把 `UIAppFonts` 陣列，填入檔名，例如 `FiraCode-Regular.ttf`。
/// 3. 在下面加一個 case，並用 PostScript 名稱建立字型：
///    ```
///    case firaCode
///    ...
///    case .firaCode: return .custom("FiraCode-Regular", size: size).weight(weight)
///    ```
///    名字打錯不會報錯，只會默默變回系統字型，所以要對照字型書（Font Book）確認名稱。
enum CodeFontFamily: String, CaseIterable, Identifiable {
    case sfMono
    case menlo
    case monaco
    case courierNew
    case andaleMono
    case system

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sfMono: return "SF Mono"
        case .menlo: return "Menlo"
        case .monaco: return "Monaco"
        case .courierNew: return "Courier New"
        case .andaleMono: return "Andale Mono"
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
        case .system:
            return .system(size: size, weight: weight, design: .default)
        }
    }
}
