import SwiftUI
import CodeMirror_SwiftUI

struct CodeEditor: View {
    @Binding var text: String
    let mode: Mode
    let theme: CodeViewTheme
    let fontSize: Int
    let showInvisibleCharacters: Bool
    let lineWrapping: Bool
    
    init(
        text: Binding<String>,
        mode: Mode = CodeMode.javascript.mode(),
        theme: CodeViewTheme = .materialPalenight,
        fontSize: Int = 14,
        showInvisibleCharacters: Bool = false,
        lineWrapping: Bool = true
    ) {
        self._text = text
        self.mode = mode
        self.theme = theme
        self.fontSize = fontSize
        self.showInvisibleCharacters = showInvisibleCharacters
        self.lineWrapping = lineWrapping
    }
    
    var body: some View {
        CodeView(
            theme: theme,
            code: $text,
            mode: mode,
            fontSize: fontSize,
            showInvisibleCharacters: showInvisibleCharacters,
            lineWrapping: lineWrapping
        )
        .onLoadSuccess {
            print("CodeMirror loaded successfully")
        }
        .onContentChange { newCode in
            text = newCode
        }
        .onLoadFail { error in
            print("CodeMirror load failed: \(error.localizedDescription)")
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
    }
}

// Convenience initializers for common use cases
extension CodeEditor {
    // For JSON editing with syntax highlighting
    static func json(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.json.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For plain text (no syntax highlighting)
    static func plain(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.text.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For HTTP request body (JSON/XML)
    static func httpBody(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.javascript.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For Swift code
    static func swift(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.swift.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For JavaScript code
    static func javascript(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.javascript.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For Python code
    static func python(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.python.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For HTML code
    static func html(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.html.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For CSS code
    static func css(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.css.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For SQL code
    static func sql(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.sql.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For XML code
    static func xml(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.xml.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For YAML code
    static func yaml(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.yaml.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For Markdown
    static func markdown(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.markdown.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
    
    // For Shell scripts
    static func shell(text: Binding<String>) -> CodeEditor {
        CodeEditor(
            text: text,
            mode: CodeMode.shell.mode(),
            theme: .materialPalenight,
            fontSize: 14
        )
    }
}
