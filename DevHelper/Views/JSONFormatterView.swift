import SwiftUI
import AppKit

struct JSONFormatterView: View {
    @State private var jsonInput: String = ""
    @State private var jsonInput2: String = ""
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
            
            if selectedMode == .diff {
                // Diff Mode Layout - Three columns
                HStack(alignment: .top, spacing: 15) {
                    // Left JSON Input
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("JSON 1 (Original)")
                                .font(.headline)
                            Spacer()
                            Button("Clear") {
                                jsonInput = ""
                                processJSON()
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        CodeTextEditor(text: $jsonInput)
                            .padding(5)
                            .frame(maxHeight: .infinity)
                            .onChange(of: jsonInput) { _, _ in
                                processJSON()
                            }
                        
                        Text("\(jsonInput.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Right JSON Input
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("JSON 2 (Comparison)")
                                .font(.headline)
                            Spacer()
                            Button("Clear") {
                                jsonInput2 = ""
                                processJSON()
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        CodeTextEditor(text: $jsonInput2)
                            .padding(5)
                            .frame(maxHeight: .infinity)
                            .onChange(of: jsonInput2) { _, _ in
                                processJSON()
                            }
                        
                        Text("\(jsonInput2.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Diff Results
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Differences")
                                .font(.headline)
                            Spacer()
                            Button("Copy") {
                                copyToClipboard(jsonOutput)
                            }
                            .buttonStyle(.borderless)
                            .disabled(jsonOutput.isEmpty)
                        }
                        
                        ScrollView {
                            Text(jsonOutput.isEmpty ? "Differences will appear here" : jsonOutput)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        .padding(5)
                        .frame(maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .font(.caption)
                                .foregroundColor(isValid ? .green : .red)
                        }
                    }
                }
                .padding(.horizontal, 0)
            } else {
                // Standard Mode Layout - Two columns
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
                            .frame(maxHeight: .infinity)
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
                        .frame(maxHeight: .infinity, alignment: .center)
                    
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
                        .frame(maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("\(jsonOutput.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 0)
            }
            
            // Action Buttons
            HStack(spacing: 20) {
                Button("Sample") {
                    if selectedMode == .diff {
                        jsonInput = sampleJSON1
                        jsonInput2 = sampleJSON2
                    } else {
                        jsonInput = sampleJSON
                    }
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
                
                Button("Diff") {
                    selectedMode = .diff
                    processJSON()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadState()
        }
        .onDisappear {
            saveState()
        }
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
        case .diff:
            diffJSON()
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
    
    private func diffJSON() {
        // Handle empty inputs
        guard !jsonInput.isEmpty || !jsonInput2.isEmpty else {
            jsonOutput = ""
            validationMessage = "Enter JSON in both fields to compare"
            isValid = false
            return
        }
        
        if jsonInput.isEmpty {
            jsonOutput = "JSON 1 is empty"
            validationMessage = "JSON 1 is empty"
            isValid = false
            return
        }
        
        if jsonInput2.isEmpty {
            jsonOutput = "JSON 2 is empty"
            validationMessage = "JSON 2 is empty"
            isValid = false
            return
        }
        
        // Parse both JSON inputs
        guard let data1 = jsonInput.data(using: .utf8),
              let data2 = jsonInput2.data(using: .utf8) else {
            jsonOutput = "Error: Unable to process input"
            validationMessage = "❌ Invalid input"
            isValid = false
            return
        }
        
        do {
            let json1 = try JSONSerialization.jsonObject(with: data1, options: [])
            let json2 = try JSONSerialization.jsonObject(with: data2, options: [])
            
            let differences = findDifferences(json1: json1, json2: json2, path: "")
            
            if differences.isEmpty {
                jsonOutput = "✅ JSONs are identical"
                validationMessage = "✅ No differences found"
                isValid = true
            } else {
                let diffReport = differences.joined(separator: "\n\n")
                jsonOutput = "❌ Found \(differences.count) difference(s):\n\n\(diffReport)"
                validationMessage = "❌ Found \(differences.count) difference(s)"
                isValid = false
            }
            
        } catch let error1 {
            // Try to parse second JSON to give more specific error
            do {
                _ = try JSONSerialization.jsonObject(with: data2, options: [])
                jsonOutput = "❌ JSON 1 is invalid\n\nError: \(error1.localizedDescription)"
                validationMessage = "❌ JSON 1 is invalid"
            } catch {
                jsonOutput = "❌ Both JSONs are invalid\n\nJSON 1 Error: \(error1.localizedDescription)\nJSON 2 Error: \(error.localizedDescription)"
                validationMessage = "❌ Both JSONs are invalid"
            }
            isValid = false
        }
    }
    
    private func findDifferences(json1: Any, json2: Any, path: String) -> [String] {
        var differences: [String] = []
        
        // Check if types are different
        let type1 = type(of: json1)
        let type2 = type(of: json2)
        
        if String(describing: type1) != String(describing: type2) {
            differences.append("📍 Path: \(path.isEmpty ? "root" : path)\n🔄 Type mismatch:\n   JSON 1: \(String(describing: type1))\n   JSON 2: \(String(describing: type2))")
            return differences
        }
        
        // Compare based on type
        if let dict1 = json1 as? [String: Any], let dict2 = json2 as? [String: Any] {
            differences.append(contentsOf: compareDictionaries(dict1: dict1, dict2: dict2, path: path))
        } else if let array1 = json1 as? [Any], let array2 = json2 as? [Any] {
            differences.append(contentsOf: compareArrays(array1: array1, array2: array2, path: path))
        } else {
            // Compare primitive values
            let value1Str = formatValue(json1)
            let value2Str = formatValue(json2)
            
            if value1Str != value2Str {
                differences.append("📍 Path: \(path.isEmpty ? "root" : path)\n🔄 Value changed:\n   JSON 1: \(value1Str)\n   JSON 2: \(value2Str)")
            }
        }
        
        return differences
    }
    
    private func compareDictionaries(dict1: [String: Any], dict2: [String: Any], path: String) -> [String] {
        var differences: [String] = []
        
        // Find keys only in dict1 (removed keys)
        let onlyInDict1 = Set(dict1.keys).subtracting(Set(dict2.keys))
        for key in onlyInDict1.sorted() {
            let keyPath = path.isEmpty ? key : "\(path).\(key)"
            differences.append("📍 Path: \(keyPath)\n➖ Removed from JSON 2:\n   \(formatValue(dict1[key]!))")
        }
        
        // Find keys only in dict2 (added keys)
        let onlyInDict2 = Set(dict2.keys).subtracting(Set(dict1.keys))
        for key in onlyInDict2.sorted() {
            let keyPath = path.isEmpty ? key : "\(path).\(key)"
            differences.append("📍 Path: \(keyPath)\n➕ Added in JSON 2:\n   \(formatValue(dict2[key]!))")
        }
        
        // Compare common keys
        let commonKeys = Set(dict1.keys).intersection(Set(dict2.keys))
        for key in commonKeys.sorted() {
            let keyPath = path.isEmpty ? key : "\(path).\(key)"
            differences.append(contentsOf: findDifferences(json1: dict1[key]!, json2: dict2[key]!, path: keyPath))
        }
        
        return differences
    }
    
    private func compareArrays(array1: [Any], array2: [Any], path: String) -> [String] {
        var differences: [String] = []
        
        if array1.count != array2.count {
            differences.append("📍 Path: \(path.isEmpty ? "root" : path)\n📏 Array length changed:\n   JSON 1: \(array1.count) items\n   JSON 2: \(array2.count) items")
        }
        
        let maxCount = max(array1.count, array2.count)
        for i in 0..<maxCount {
            let indexPath = path.isEmpty ? "[\(i)]" : "\(path)[\(i)]"
            
            if i >= array1.count {
                differences.append("📍 Path: \(indexPath)\n➕ Added in JSON 2:\n   \(formatValue(array2[i]))")
            } else if i >= array2.count {
                differences.append("📍 Path: \(indexPath)\n➖ Removed from JSON 2:\n   \(formatValue(array1[i]))")
            } else {
                differences.append(contentsOf: findDifferences(json1: array1[i], json2: array2[i], path: indexPath))
            }
        }
        
        return differences
    }
    
    private func formatValue(_ value: Any) -> String {
        if let str = value as? String {
            return "\"\(str)\""
        } else if let num = value as? NSNumber {
            // Check if it's a boolean
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        } else if value is NSNull {
            return "null"
        } else if let dict = value as? [String: Any] {
            return "{ \(dict.count) properties }"
        } else if let array = value as? [Any] {
            return "[ \(array.count) items ]"
        } else {
            return "\(value)"
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
    
    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(jsonInput, forKey: "JSONFormatter.jsonInput")
        defaults.set(jsonInput2, forKey: "JSONFormatter.jsonInput2")
        defaults.set(jsonOutput, forKey: "JSONFormatter.jsonOutput")
        defaults.set(selectedMode.title, forKey: "JSONFormatter.selectedMode")
        defaults.set(validationMessage, forKey: "JSONFormatter.validationMessage")
        defaults.set(isValid, forKey: "JSONFormatter.isValid")
    }
    
    private func loadState() {
        let defaults = UserDefaults.standard
        jsonInput = defaults.string(forKey: "JSONFormatter.jsonInput") ?? ""
        jsonInput2 = defaults.string(forKey: "JSONFormatter.jsonInput2") ?? ""
        jsonOutput = defaults.string(forKey: "JSONFormatter.jsonOutput") ?? ""
        validationMessage = defaults.string(forKey: "JSONFormatter.validationMessage") ?? ""
        isValid = defaults.bool(forKey: "JSONFormatter.isValid")
        
        if let modeTitle = defaults.string(forKey: "JSONFormatter.selectedMode") {
            selectedMode = JSONMode.allCases.first { $0.title == modeTitle } ?? .format
        }
        
        // If we have input, trigger processing
        if !jsonInput.isEmpty || !jsonInput2.isEmpty {
            processJSON()
        }
    }
}

enum JSONMode: CaseIterable {
    case format, minify, validate, escape, diff
    
    var title: String {
        switch self {
        case .format: return "Format"
        case .minify: return "Minify"
        case .validate: return "Validate"
        case .escape: return "Escape"
        case .diff: return "Diff"
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

private let sampleJSON1 = """
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

private let sampleJSON2 = """
{
  "name": "Jane Smith",
  "age": 28,
  "isActive": true,
  "address": {
    "street": "456 Oak Ave",
    "city": "San Francisco",
    "zipCode": "94102",
    "country": "USA"
  },
  "hobbies": ["reading", "photography", "traveling"],
  "contact": {
    "email": "jane@example.com",
    "phone": "+1-555-0123"
  },
  "preferences": {
    "theme": "dark",
    "notifications": true
  }
}
"""

#Preview {
    JSONFormatterView()
}
