import SwiftUI
import AppKit

struct JSONFormatterView: View {
    @State private var jsonInput: String = ""
    @State private var jsonOutput: String = ""
    @State private var selectedMode: JSONMode = .format
    @State private var validationMessage: String = ""
    @State private var isValid: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("JSON Formatter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Mode Selection
            Picker("Mode", selection: $selectedMode) {
                ForEach(JSONMode.allCases, id: \.self) { mode in
                    Text(mode.title)
                        .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedMode) { _, _ in
                processJSON()
            }
            
            HStack(alignment: .top, spacing: 20) {
                // Input Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("JSON Input")
                            .font(.headline)
                        Spacer()
                        Button("Clear") {
                            jsonInput = ""
                            jsonOutput = ""
                            validationMessage = ""
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    CodeTextEditor(text: $jsonInput)
                        .padding(5)
                        .frame(height: 320)
                        .onChange(of: jsonInput) { _, _ in
                            processJSON()
                        }
                    
                    HStack {
                        Text("\(jsonInput.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .font(.caption)
                                .foregroundColor(isValid ? .green : .red)
                        }
                    }
                }
                
                Image(systemName: "arrow.right")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(height: 320, alignment: .center)
                
                // Output Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("JSON Output")
                            .font(.headline)
                        Spacer()
                        Button("Copy") {
                            copyToClipboard(jsonOutput)
                        }
                        .buttonStyle(.borderless)
                        .disabled(jsonOutput.isEmpty)
                    }
                    
                    ScrollView {
                        Text(jsonOutput.isEmpty ? "Formatted JSON will appear here" : jsonOutput)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                    .padding(5)
                    .frame(height: 320)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    Text("\(jsonOutput.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button("Sample") {
                    jsonInput = sampleJSON
                    processJSON()
                }
                .buttonStyle(.bordered)
                
                Button("Format") {
                    selectedMode = .format
                    processJSON()
                }
                .buttonStyle(.bordered)
                
                Button("Minify") {
                    selectedMode = .minify
                    processJSON()
                }
                .buttonStyle(.bordered)
                
                Button("Validate") {
                    selectedMode = .validate
                    processJSON()
                }
                .buttonStyle(.bordered)
                
                Button("Escape") {
                    selectedMode = .escape
                    processJSON()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func processJSON() {
        guard !jsonInput.isEmpty else {
            jsonOutput = ""
            validationMessage = ""
            return
        }
        
        switch selectedMode {
        case .format:
            formatJSON()
        case .minify:
            minifyJSON()
        case .validate:
            validateJSON()
        case .escape:
            escapeJSON()
        }
    }
    
    private func formatJSON() {
        guard let data = jsonInput.data(using: .utf8) else {
            jsonOutput = "Error: Unable to process input"
            isValid = false
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let formattedData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
            jsonOutput = String(data: formattedData, encoding: .utf8) ?? "Error: Unable to format JSON"
            isValid = true
            validationMessage = "✅ Valid JSON"
        } catch {
            jsonOutput = "Error: \(error.localizedDescription)"
            isValid = false
            validationMessage = "❌ Invalid JSON"
        }
    }
    
    private func minifyJSON() {
        guard let data = jsonInput.data(using: .utf8) else {
            jsonOutput = "Error: Unable to process input"
            isValid = false
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let minifiedData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            jsonOutput = String(data: minifiedData, encoding: .utf8) ?? "Error: Unable to minify JSON"
            isValid = true
            validationMessage = "✅ Valid JSON (minified)"
        } catch {
            jsonOutput = "Error: \(error.localizedDescription)"
            isValid = false
            validationMessage = "❌ Invalid JSON"
        }
    }
    
    private func validateJSON() {
        guard let data = jsonInput.data(using: .utf8) else {
            jsonOutput = "❌ Invalid JSON: Unable to process input"
            isValid = false
            validationMessage = "❌ Invalid JSON"
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            var info = "✅ Valid JSON\n\n"
            
            if let dictionary = jsonObject as? [String: Any] {
                info += "Type: Object\n"
                info += "Properties: \(dictionary.keys.count)\n"
                info += "Keys: \(dictionary.keys.sorted().joined(separator: ", "))"
            } else if let array = jsonObject as? [Any] {
                info += "Type: Array\n"
                info += "Items: \(array.count)"
            } else {
                info += "Type: \(type(of: jsonObject))"
            }
            
            jsonOutput = info
            isValid = true
            validationMessage = "✅ Valid JSON"
        } catch {
            jsonOutput = "❌ Invalid JSON\n\nError: \(error.localizedDescription)"
            isValid = false
            validationMessage = "❌ Invalid JSON"
        }
    }
    
    private func escapeJSON() {
        let escapedJSON = jsonInput
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
        
        jsonOutput = "\"\(escapedJSON)\""
        isValid = true
        validationMessage = "JSON escaped for string use"
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
}

enum JSONMode: CaseIterable {
    case format, minify, validate, escape
    
    var title: String {
        switch self {
        case .format: return "Format"
        case .minify: return "Minify"
        case .validate: return "Validate"
        case .escape: return "Escape"
        }
    }
}

private let sampleJSON = """
{
  "name": "John Doe",
  "age": 30,
  "isActive": true,
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zipCode": "10001"
  },
  "hobbies": ["reading", "coding", "hiking"],
  "contact": {
    "email": "john@example.com",
    "phone": null
  }
}
"""

#Preview {
    JSONFormatterView()
}
