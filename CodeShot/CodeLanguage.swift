import Foundation

/// 定義語言選項、檔名規則與範例內容。
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

    /// 卡片檔名使用的副檔名。
    var fileExtension: String {
        switch self {
        case .swift: return "swift"
        case .c: return "c"
        case .cpp: return "cpp"
        case .python: return "py"
        case .java: return "java"
        case .javascript: return "js"
        case .rust: return "rs"
        case .plainText: return "txt"
        }
    }

    /// 從表單載入範例時使用的主檔名。
    var defaultBaseName: String {
        switch self {
        case .swift: return "Main"
        case .c: return "main"
        case .cpp: return "main"
        case .python: return "main"
        case .java: return "Main"
        case .javascript: return "main"
        case .rust: return "main"
        case .plainText: return "main"
        }
    }

    /// 各語言的「Hello, world!」範例。
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
            """
        }
    }
}
