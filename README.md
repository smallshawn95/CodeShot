# CodeShot — 程式碼截圖 App

彼得潘作業 #233「結合各種輸入元件 & 顯示 alert」的 SwiftUI 版本。

輸入程式碼 → 即時預覽一張「像程式碼截圖」的卡片 → 按生成圖片 → 用 `ImageRenderer` 轉成 UIImage → 在新頁面顯示。

```
CodeShot.xcodeproj/    Xcode 專案，雙擊就能開
CodeShot/              6 個 Swift 檔 + Assets.xcassets + Info.plist
CodeShot/Fonts/        Fira Code、JetBrains Mono（已註冊，選單直接可用）
preview/               HTML 互動預覽（用瀏覽器開，不需要 Mac）
README.md
```

---

## 一、直接開啟專案（推薦）

這個資料夾本身就是一個完整的 Xcode 專案，不用自己建：

1. 雙擊 **`CodeShot.xcodeproj`**
2. 上方選一個 iPhone 模擬器（例如 iPhone 16）
3. ⌘R 執行

已經幫你設定好：

| 項目 | 值 |
|---|---|
| 部署目標 | iOS 16.0 |
| Bundle ID | `com.example.CodeShot` |
| 共用 Scheme | `CodeShot`（有附，打開就能跑） |
| 簽章 | Automatic（模擬器不需要 Team） |

### 要跑實機的話

選 Target → **Signing & Capabilities** → Team 選自己的帳號；如果 Bundle ID 撞了，改成
`com.你的名字.CodeShot` 即可。

### 如果 Xcode 打不開專案

代表 `project.pbxproj` 的格式和你的 Xcode 版本不合，改用下面「二」的手動方式，程式碼完全一樣。

---

## 二、手動建立（備案）

1. Xcode → File → New → Project → **iOS App**
   - Product Name：`CodeShot`
   - Interface：**SwiftUI**
   - Language：**Swift**
2. 建立後，**先刪掉**專案自動產生的兩個檔案
   - `CodeShotApp.swift`
   - `ContentView.swift`
3. 把 `CodeShot/` 資料夾裡的 6 個 `.swift` 拖進 Xcode 左側導覽列
   - ✅ Copy items if needed
   - ✅ Add to targets → `CodeShot`
4. Target → General → **Minimum Deployments 改為 iOS 16.0**
5. ⌘R 執行

### 不要拖進去的東西

| 檔案／資料夾 | 原因 |
|---|---|
| `README.md` | 說明文件，不是程式碼 |
| `preview/` 整個資料夾 | HTML 預覽用，拖進去只會被當成專案資源 |
| 專案原本的 `Assets.xcassets` | 不要覆蓋 |

### 兩個常見卡點

- **`Invalid redeclaration of 'ContentView'`**：步驟 2 沒做，專案裡有兩個 `ContentView`。
- **兩個 `@main` 進入點**：專案的 `CodeShotApp.swift` 沒刪，和我們的檔案撞了。
- Xcode 14 的 `#Preview { ContentView() }` 會報錯，把那 3 行刪掉即可。

> 不需要改 Info.plist，因為目前沒有用到相簿或通知權限。

---

## 三、檔案在做什麼

| 檔案 | 角色 |
|---|---|
| `CodeShotApp.swift` | App 進入點 |
| `ContentView.swift` | 主畫面：Form 表單、預覽、生成按鈕、alert |
| `CodeCardView.swift` | 被截圖的那張卡片（預覽與輸出共用同一個 View） |
| `CodeStyle.swift` | 外觀設定 + 檔名規則 + 字型列舉 |
| `CodeLanguage.swift` | 8 種語言、副檔名、Hello world 範例 |
| `ResultView.swift` | 結果頁（顯示 + 分享） |
| `Assets.xcassets` | AppIcon / AccentColor 佔位（沒有圖也可以編譯） |
| `Info.plist` | 註冊自訂字型（`UIAppFonts`）與其他基本設定 |
| `Fonts/` | Fira Code、JetBrains Mono 的 .ttf 與授權檔 |

資料流：

```
CodeStyle（單一 struct）
   ↓ 傳值
CodeCardView（畫面）
   ↓ ImageRenderer
UIImage → ResultView
```

因為預覽和輸出共用 `CodeCardView`，所以「看到的」就等於「生成的」。

---

## 四、語言與副檔名

檔名欄位只填**主檔名**，副檔名由語言決定：

| 語言 | 副檔名 | 範例檔名 |
|---|---|---|
| Swift | `.swift` | `Hello.swift` |
| C | `.c` | `hello.c` |
| C++ | `.cpp` | `hello.cpp` |
| Python | `.py` | `hello.py` |
| Java | `.java` | `Main.java` |
| JavaScript | `.js` | `hello.js` |
| Rust | `.rs` | `main.rs` |
| 純文字 | 不加 | `note` |

- 8 種語言的範例都是輸出 `Hello, world!`，方便互相比較。
- Java 檔名慣例是大寫開頭的 `Main`，按「載入範例」會自動帶入。
- 自己打了 `main.swift` 不會變成 `main.swift.swift`（有防呆）。

---

## 五、字型

選單共 8 種：

| 種類 | 字型 | 需要準備什麼 |
|---|---|---|
| iOS 內建 | SF Mono、Menlo、Monaco、Courier New、Andale Mono、系統字型 | 不用，選了就有 |
| 已附在專案 | Fira Code、JetBrains Mono | 不用，已設定完成 |

### 附帶的兩種字型是怎麼接上去的

這三件事都已經做完了，明天 clone 下來直接選就能用：

1. 字型檔放在 `CodeShot/Fonts/`，並加入 **Build Phases → Copy Bundle Resources**
2. `CodeShot/Info.plist` 的 `UIAppFonts` 已列出四個檔名
3. `CodeStyle.swift` 的 `CodeFontFamily` 已加好 case，並**直接指定 PostScript 名稱**
   `FiraCode-Regular` / `FiraCode-Bold` / `JetBrainsMono-Regular` / `JetBrainsMono-Bold`

> 為什麼不靠 `.weight(.bold)`？靜態字型不一定會自動換成 Bold 字面，直接指定 PostScript 名稱最保險。

### 想再加字型（例如 IBM Plex Mono）

1. `.ttf` 拖進 Xcode 的 `Fonts` group → ✅ Copy items if needed、✅ Add to targets
2. `Info.plist` 的 `UIAppFonts` 陣列補上檔名（含 `.ttf`）
3. `CodeFontFamily` 加一個 case，字型名稱填 **PostScript 名稱**

PostScript 名稱要用「字型書（Font Book）→ 右鍵 → 顯示字型資訊」查，**不是檔名**。
名稱打錯不會報錯，只會默默變回系統字型。

### 授權

- Fira Code、JetBrains Mono 都是 SIL Open Font License 1.1，可以隨 App 一起散布。
- 授權檔放在 `CodeShot/Fonts/LICENSE-*.txt`，公開發佈時建議一起附上。

---

## 六、作業需求對照表

| 文章列出的元件 | 在這個 App 的哪裡 |
|---|---|
| `TextEditor` | 程式碼輸入區 |
| `TextField` | 卡片標題列的檔名（不含副檔名） |
| `Picker` | 語言（8 種）、字型（6 種） |
| `Slider` | 字體大小、卡片圓角 |
| `Stepper` | 內距、行距 |
| `Toggle` | 粗體、顯示標題列、顯示三色點、顯示行號 |
| `ColorPicker` | 字體顏色、背景顏色、標題列顏色 |
| `contextMenu` | 長按預覽卡片 → 複製程式碼／載入範例／重設 |
| `alert` | 沒有程式碼、生成失敗、已複製、已重設 |
| `confirmationDialog` | 重設確認（加分） |
| `ShareLink` | 結果頁分享圖片（加分） |
| `DatePicker` | 未使用（可做時間浮水印，但與用途不太相關） |
| `MultiDatePicker` | 未使用（與本 App 使用情境不符，可寫在報告說明） |

---

## 七、之後可以加的功能

1. **語法高亮**：把 `CodeCardView` 裡的 `Text(style.code)` 換成 `Text(AttributedString(...))`，用 `NSRegularExpression` 標記關鍵字／字串／註解。只要改這一個地方。
2. **存到相簿**：`ResultView` 加一顆按鈕呼叫 `UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)`，並在 Info.plist 加 `NSPhotoLibraryAddUsageDescription`。
3. **背景照片**：`PhotosPicker` 選圖後當卡片底色，再蓋一層半透明遮罩。
4. **主題預設**：把幾組常用配色做成陣列，用 `Picker` 一鍵套用。

---

## 八、已知限制

- 不做語法高亮，整段程式碼是單色。
- 程式碼很長時，生成的圖片會很高，這是正常的。
- 行號是用「一個多行 `Text`」對齊的，如果某一行太長自動換行，行號會和內容錯開。範例程式碼都很短，不會遇到。
