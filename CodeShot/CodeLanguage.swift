import Foundation

/// 程式語言種類。
///
/// 目前不做語法高亮，所以這個列舉的用途是：
/// 1. 顯示在 Picker 裡讓使用者選擇。
/// 2. 決定「載入範例」時要放哪一段程式碼。
/// 3. 決定卡片上的副檔名與預設檔名。
enum CodeLanguage: String, CaseIterable, Identifiable {
    case swift
    case c
    case cpp
    case python
    case java
    case javascript
    case rust
    case plainText

    var id: String { rawValue }

    var title: String {
        switch self {
        case .swift: return "Swift"
        case .c: return "C"
        case .cpp: return "C++"
        case .python: return "Python"
        case .java: return "Java"
        case .javascript: return "JavaScript"
        case .rust: return "Rust"
        case .plainText: return "純文字"
        }
    }

    /// 卡片上顯示的副檔名，純文字不帶副檔名。
    var fileExtension: String {
        switch self {
        case .swift: return "swift"
        case .c: return "c"
        case .cpp: return "cpp"
        case .python: return "py"
        case .java: return "java"
        case .javascript: return "js"
        case .rust: return "rs"
        case .plainText: return ""
        }
    }

    /// 按「載入範例」時，檔名要跟著換成該語言習慣的名稱。
    var defaultBaseName: String {
        switch self {
        case .swift: return "Hello"
        case .c: return "hello"
        case .cpp: return "hello"
        case .python: return "hello"
        case .java: return "Main"
        case .javascript: return "hello"
        case .rust: return "main"
        case .plainText: return "note"
        }
    }

    /// 每個語言都輸出 Hello, world!，方便互相對照。
    ///
    /// 注意：Swift 字串裡的 `\\n` 代表畫面上要看到一個反斜線加 n，
    /// 所以 C 的 printf 要這樣寫，才會顯示 `printf("Hello, world!\n");`。
    var sampleCode: String {
        switch self {
        case .swift:
            return """
            import Foundation

            print("Hello, world!")
            """

        case .c:
            return """
            #include <stdio.h>

            int main(void) {
                printf("Hello, world!\\n");
                return 0;
            }
            """

        case .cpp:
            return """
            #include <iostream>

            int main() {
                std::cout << "Hello, world!" << std::endl;
                return 0;
            }
            """

        case .python:
            return """
            def main():
                print("Hello, world!")


            if __name__ == "__main__":
                main()
            """

        case .java:
            return """
            public class Main {
                public static void main(String[] args) {
                    System.out.println("Hello, world!");
                }
            }
            """

        case .javascript:
            return """
            function main() {
              console.log("Hello, world!");
            }

            main();
            """

        case .rust:
            return """
            fn main() {
                println!("Hello, world!");
            }
            """

        case .plainText:
            return """
            Hello, world!

            這是一段純文字，不會有任何語法著色。
            """
        }
    }
}
