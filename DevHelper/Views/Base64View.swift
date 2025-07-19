import SwiftUI
import AppKit

struct Base64View: View {
    @State private var textInput: String = ""
    @State private var base64Output: String = ""
    @State private var base64Input: String = ""
    @State private var decodedOutput: String = ""
    @State private var isURLSafe: Bool = false
    @State private var selectedTab: Base64Tab = .encode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Base64 Encoder/Decoder")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Tab Selection
            Picker("Mode", selection: $selectedTab) {
                ForEach(Base64Tab.allCases, id: \.self) { tab in
                    Text(tab.title)
                        .tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            HStack(alignment: .top, spacing: 20) {
                if selectedTab == .encode {
                    // Encode Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Text Input")
                                .font(.headline)
                            Spacer()
                            Button("Clear") {
                                textInput = ""
                                base64Output = ""
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        CodeTextEditor(text: $textInput)
                            .padding(5)
                            .frame(maxHeight: .infinity)
                            .onChange(of: textInput) { _, _ in
                                encodeText()
                            }
                        
                        Text("\(textInput.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Base64 Output")
                                .font(.headline)
                            Spacer()
                            Button("Copy") {
                                copyToClipboard(base64Output)
                            }
                            .buttonStyle(.borderless)
                            .disabled(base64Output.isEmpty)
                        }
                        
                        ScrollView {
                            Text(base64Output.isEmpty ? "Base64 encoded text will appear here" : base64Output)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        .padding(5)
                        .frame(maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("\(base64Output.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // Decode Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Base64 Input")
                                .font(.headline)
                            Spacer()
                            Button("Clear") {
                                base64Input = ""
                                decodedOutput = ""
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        CodeTextEditor(text: $base64Input)
                            .padding(5)
                            .frame(maxHeight: .infinity)
                            .onChange(of: base64Input) { _, _ in
                                decodeBase64()
                            }
                        
                        Text("\(base64Input.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Decoded Output")
                                .font(.headline)
                            Spacer()
                            Button("Copy") {
                                copyToClipboard(decodedOutput)
                            }
                            .buttonStyle(.borderless)
                            .disabled(decodedOutput.isEmpty)
                        }
                        
                        ScrollView {
                            Text(decodedOutput.isEmpty ? "Decoded text will appear here" : decodedOutput)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        .padding(5)
                        .frame(maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("\(decodedOutput.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 0)
            
            // Additional Tools
            HStack(spacing: 20) {
                Button("Sample") {
                    if selectedTab == .encode {
                        textInput = "Hello, World! This is a sample text for Base64 encoding."
                    } else {
                        base64Input = "SGVsbG8sIFdvcmxkISBUaGlzIGlzIGEgc2FtcGxlIHRleHQgZm9yIEJhc2U2NCBlbmNvZGluZy4="
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Swap") {
                    if selectedTab == .encode && !base64Output.isEmpty {
                        base64Input = base64Output
                        selectedTab = .decode
                    } else if selectedTab == .decode && !decodedOutput.isEmpty {
                        textInput = decodedOutput
                        selectedTab = .encode
                    }
                }
                .buttonStyle(.bordered)
                .disabled((selectedTab == .encode && base64Output.isEmpty) || 
                         (selectedTab == .decode && decodedOutput.isEmpty))
                
                Spacer()
                
                Toggle("URL-Safe Base64", isOn: $isURLSafe)
                    .onChange(of: isURLSafe) { _, _ in
                        if selectedTab == .encode {
                            encodeText()
                        } else {
                            decodeBase64()
                        }
                    }
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: selectedTab) { _, _ in
            if selectedTab == .encode {
                encodeText()
            } else {
                decodeBase64()
            }
        }
    }
    
    private func encodeText() {
        guard !textInput.isEmpty else {
            base64Output = ""
            return
        }
        
        guard let data = textInput.data(using: .utf8) else {
            base64Output = "Error: Unable to encode text"
            return
        }
        
        if isURLSafe {
            let base64 = data.base64EncodedString()
            base64Output = base64
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        } else {
            base64Output = data.base64EncodedString()
        }
    }
    
    private func decodeBase64() {
        guard !base64Input.isEmpty else {
            decodedOutput = ""
            return
        }
        
        var base64String = base64Input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isURLSafe {
            // Convert URL-safe Base64 to standard Base64
            base64String = base64String
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            // Add padding if needed
            while base64String.count % 4 != 0 {
                base64String += "="
            }
        }
        
        guard let data = Data(base64Encoded: base64String) else {
            decodedOutput = "Error: Invalid Base64 input"
            return
        }
        
        if let decodedString = String(data: data, encoding: .utf8) {
            decodedOutput = decodedString
        } else {
            decodedOutput = "Error: Unable to decode as UTF-8 text"
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
}

enum Base64Tab: CaseIterable {
    case encode, decode
    
    var title: String {
        switch self {
        case .encode: return "Encode"
        case .decode: return "Decode"
        }
    }
}

#Preview {
    Base64View()
}