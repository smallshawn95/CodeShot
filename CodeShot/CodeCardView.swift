import SwiftUI

/// 真正被「截圖」的那張卡片。
///
/// 這個 View 同時用在兩個地方：
/// 1. 主畫面的即時預覽。
/// 2. `ImageRenderer` 產生 UIImage 時的內容。
///
/// 因為兩邊共用同一個 View，所以「看到的」就等於「輸出的」。
struct CodeCardView: View {
    let style: CodeStyle

    private var lines: [String] {
        style.code.components(separatedBy: "\n")
    }

    /// 行號用「一個多行 Text」畫，而不是 ForEach 一堆 Text。
    /// 這樣行號和程式碼用的是同一個字型與 lineSpacing，
    /// 每一行的基準線才會對得整整齊齊。
    private var numberColumn: String {
        guard !lines.isEmpty else { return "1" }
        return lines.indices.map { "\($0 + 1)" }.joined(separator: "\n")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if style.showsHeader {
                header
            }
            codeBody
        }
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.10), lineWidth: 1)
        )
    }

    private var header: some View {
        ZStack {
            Text(style.fileName)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(style.textColor.opacity(0.60))
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            HStack(spacing: 6) {
                if style.showsWindowButtons {
                    Circle().fill(Color(red: 1.00, green: 0.37, blue: 0.34))
                        .frame(width: 11, height: 11)
                    Circle().fill(Color(red: 1.00, green: 0.74, blue: 0.20))
                        .frame(width: 11, height: 11)
                    Circle().fill(Color(red: 0.15, green: 0.79, blue: 0.25))
                        .frame(width: 11, height: 11)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(style.headerColor)
    }

    private var codeBody: some View {
        HStack(alignment: .top, spacing: 12) {
            if style.showsLineNumbers {
                Text(numberColumn)
                    .font(style.fontFamily.font(size: style.fontSize, isBold: style.isBold))
                    .lineSpacing(style.lineSpacing)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(style.textColor.opacity(0.35))
                    .frame(minWidth: 18, alignment: .trailing)
            }

            Text(style.code.isEmpty ? " " : style.code)
                .font(style.fontFamily.font(size: style.fontSize, isBold: style.isBold))
                .lineSpacing(style.lineSpacing)
                .foregroundStyle(style.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(style.padding)
    }
}
