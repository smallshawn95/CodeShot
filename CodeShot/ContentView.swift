import SwiftUI
import UIKit

struct ContentView: View {
    @State private var style = CodeStyle()

    @State private var renderedImage: UIImage?
    @State private var showResult = false

    @State private var activeAlert: AppAlert?
    @State private var showResetDialog = false

    private var alertBinding: Binding<Bool> {
        Binding(
            get: { activeAlert != nil },
            set: { isPresented in
                if !isPresented { activeAlert = nil }
            }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                previewSection
                codeSection
                fontSection
                colorSection
                layoutSection
                generateSection
            }
            .navigationTitle("程式碼截圖")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("重設") { showResetDialog = true }
                }
            }
            .navigationDestination(isPresented: $showResult) {
                if let renderedImage {
                    ResultView(image: renderedImage)
                }
            }
            .alert(
                activeAlert?.title ?? "",
                isPresented: alertBinding,
                presenting: activeAlert
            ) { _ in
                Button("好", role: .cancel) { }
            } message: { alert in
                Text(alert.message)
            }
            .confirmationDialog(
                "要重設所有設定嗎？",
                isPresented: $showResetDialog,
                titleVisibility: .visible
            ) {
                Button("重設", role: .destructive) {
                    style = CodeStyle()
                    activeAlert = .resetDone
                }
                Button("取消", role: .cancel) { }
            }
        }
    }

    // MARK: - 預覽

    private var previewSection: some View {
        Section {
            CodeCardView(style: style)
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = style.code
                        activeAlert = .copied
                    } label: {
                        Label("複製程式碼", systemImage: "doc.on.doc")
                    }

                    Button {
                        style.code = style.language.sampleCode
                    } label: {
                        Label("載入範例程式碼", systemImage: "text.badge.plus")
                    }

                    Button(role: .destructive) {
                        showResetDialog = true
                    } label: {
                        Label("重設外觀", systemImage: "arrow.counterclockwise")
                    }
                }
        } header: {
            Text("預覽（長按可開啟選單）")
        }
    }

    // MARK: - 程式碼

    private var codeSection: some View {
        Section {
            TextEditor(text: $style.code)
                .font(.system(.body, design: .monospaced))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(minHeight: 150)
                .overlay(alignment: .topLeading) {
                    if style.code.isEmpty {
                        Text("在這裡貼上程式碼…")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }

            TextField("檔名", text: $style.baseName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            Picker("語言", selection: $style.language) {
                ForEach(CodeLanguage.allCases) { language in
                    Text(language.title).tag(language)
                }
            }

            Button {
                style.code = style.language.sampleCode
                style.baseName = style.language.defaultBaseName
            } label: {
                Label("載入 \(style.language.title) 範例", systemImage: "doc.text")
            }
        } header: {
            Text("程式碼")
        }
    }

    // MARK: - 字型

    private var fontSection: some View {
        Section {
            Picker("字型", selection: $style.fontFamily) {
                ForEach(CodeFontFamily.allCases) { family in
                    Text(family.title).tag(family)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("字體大小")
                    Spacer()
                    Text("\(Int(style.fontSize)) pt")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $style.fontSize, in: 10...32, step: 1)
            }

            Toggle("粗體", isOn: $style.isBold)
        } header: {
            Text("字型")
        }
    }

    // MARK: - 顏色

    private var colorSection: some View {
        Section("顏色") {
            ColorPicker("字體顏色", selection: $style.textColor, supportsOpacity: false)
            ColorPicker("背景顏色", selection: $style.backgroundColor, supportsOpacity: false)
            ColorPicker("標題列顏色", selection: $style.headerColor, supportsOpacity: false)
        }
    }

    // MARK: - 版面

    private var layoutSection: some View {
        Section("版面") {
            Toggle("顯示標題列", isOn: $style.showsHeader)
            Toggle("顯示視窗三色點", isOn: $style.showsWindowButtons)
            Toggle("顯示行號", isOn: $style.showsLineNumbers)

            Stepper("內距：\(Int(style.padding))", value: $style.padding, in: 8...48, step: 4)
            Stepper("行距：\(Int(style.lineSpacing))", value: $style.lineSpacing, in: 0...16, step: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("圓角")
                    Spacer()
                    Text("\(Int(style.cornerRadius))")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $style.cornerRadius, in: 0...40, step: 1)
            }
        }
    }

    // MARK: - 輸出按鈕

    private var generateSection: some View {
        Section {
            Button {
                generate()
            } label: {
                Text("生成圖片")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } footer: {
            Text("按下後會把上面的預覽卡片轉成圖片，並開啟結果頁。")
        }
    }

    // MARK: - 圖片輸出

    @MainActor
    private func generate() {
        guard !style.code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            activeAlert = .emptyCode
            return
        }

        // 以固定寬度在各裝置輸出卡片。
        let card = CodeCardView(style: style).frame(width: 640)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3

        guard let image = renderer.uiImage else {
            activeAlert = .renderFailed
            return
        }

        renderedImage = image
        showResult = true
    }
}

// MARK: - 提示訊息

enum AppAlert: Identifiable {
    case emptyCode
    case renderFailed
    case copied
    case resetDone

    var id: String { title }

    var title: String {
        switch self {
        case .emptyCode: return "還沒有程式碼"
        case .renderFailed: return "生成失敗"
        case .copied: return "已複製"
        case .resetDone: return "已重設"
        }
    }

    var message: String {
        switch self {
        case .emptyCode:
            return "請先在「程式碼」區貼上或輸入一些內容。"
        case .renderFailed:
            return "無法把畫面轉成圖片，請確認程式碼內容不要太長。"
        case .copied:
            return "程式碼已經複製到剪貼簿。"
        case .resetDone:
            return "外觀設定已恢復預設值。"
        }
    }
}

#Preview {
    ContentView()
}
