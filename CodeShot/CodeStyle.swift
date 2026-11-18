import SwiftUI

/// 程式碼卡片的內容與外觀設定。
struct CodeStyle {
    // 內容
    var code: String = CodeLanguage.swift.sampleCode

    /// 檔名欄位的原始輸入。
    var baseName: String = "main"
    var language: CodeLanguage = .swift

    /// 卡片標題列顯示的完整檔名。
    var fileName: String {
        let name = baseName.trimmingCharacters(in: .whitespacesAndNewlines)
        let shown = name.isEmpty ? "未命名" : name
        let ext = language.fileExtension

        guard !ext.isEmpty else { return shown }

        // 保留已含相同副檔名的檔名。
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

/// 卡片可選用的字型。
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
            // 隨附字型以 PostScript 名稱選擇對應字重。
            return .custom(isBold ? "FiraCode-Bold" : "FiraCode-Regular", size: size)
        case .jetBrainsMono:
            return .custom(isBold ? "JetBrainsMono-Bold" : "JetBrainsMono-Regular", size: size)
        case .system:
            return .system(size: size, weight: weight, design: .default)
        }
    }
}
