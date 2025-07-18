import SwiftUI

struct UUIDGeneratorView: View {
    @State private var selectedVersion: UUIDVersion = .v4
    @State private var uuidFormat: UUIDFormat = .standard
    @State private var generatedUUIDs: [String] = []
    @State private var bulkCount: Int = 1
    @State private var validationInput: String = ""
    @State private var validationResult: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("UUID Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                // Generator Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Generate UUIDs")
                        .font(.headline)
                    
                    // UUID Version Selection
                    Picker("Version", selection: $selectedVersion) {
                        ForEach(UUIDVersion.allCases, id: \.self) { version in
                            Text(version.title)
                                .tag(version)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Format Selection
                    Picker("Format", selection: $uuidFormat) {
                        ForEach(UUIDFormat.allCases, id: \.self) { format in
                            Text(format.title)
                                .tag(format)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Bulk Generation
                    HStack {
                        Text("Count:")
                        Stepper(value: $bulkCount, in: 1...100) {
                            Text("\(bulkCount)")
                        }
                        .frame(width: 100)
                    }
                    
                    // Generate Button
                    Button("Generate UUID\(bulkCount > 1 ? "s" : "")") {
                        generateUUIDs()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Generated UUIDs List
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(generatedUUIDs, id: \.self) { uuid in
                                HStack {
                                    Text(uuid)
                                        .font(.system(.body, design: .monospaced))
                                        .textSelection(.enabled)
                                    
                                    Spacer()
                                    
                                    Button("Copy") {
                                        copyToClipboard(uuid)
                                    }
                                    .buttonStyle(.borderless)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                            }
                        }
                    }
                    .frame(height: 200)
                    
                    if !generatedUUIDs.isEmpty {
                        Button("Copy All") {
                            let allUUIDs = generatedUUIDs.joined(separator: "\n")
                            copyToClipboard(allUUIDs)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                // Validation Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Validate UUID")
                        .font(.headline)
                    
                    TextField("Enter UUID to validate", text: $validationInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: validationInput) { _, newValue in
                            validateUUID(newValue)
                        }
                    
                    ScrollView {
                        Text(validationResult.isEmpty ? "Validation result will appear here" : validationResult)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(height: 100)
                    
                    // Common UUID Patterns
                    Text("Common Patterns:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(commonPatterns, id: \.name) { pattern in
                            Button(pattern.name) {
                                validationInput = pattern.example
                            }
                            .buttonStyle(.borderless)
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            generateUUIDs()
        }
    }
    
    private func generateUUIDs() {
        generatedUUIDs.removeAll()
        
        for _ in 0..<bulkCount {
            let uuid = UUID()
            let formattedUUID = formatUUID(uuid, format: uuidFormat)
            generatedUUIDs.append(formattedUUID)
        }
    }
    
    private func formatUUID(_ uuid: UUID, format: UUIDFormat) -> String {
        let uuidString = uuid.uuidString
        
        switch format {
        case .standard:
            return uuidString
        case .noHyphens:
            return uuidString.replacingOccurrences(of: "-", with: "")
        case .uppercase:
            return uuidString.uppercased()
        case .lowercase:
            return uuidString.lowercased()
        case .braces:
            return "{\(uuidString)}"
        }
    }
    
    private func validateUUID(_ input: String) {
        guard !input.isEmpty else {
            validationResult = ""
            return
        }
        
        let cleanedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove braces if present
        let uuidString = cleanedInput.hasPrefix("{") && cleanedInput.hasSuffix("}") 
            ? String(cleanedInput.dropFirst().dropLast())
            : cleanedInput
        
        // Check if it's a valid UUID format
        if let _ = UUID(uuidString: uuidString) {
            validationResult = """
            ✅ Valid UUID
            
            Format: \(detectFormat(cleanedInput))
            Length: \(cleanedInput.count) characters
            Version: \(detectVersion(uuidString))
            """
        } else {
            validationResult = """
            ❌ Invalid UUID
            
            A valid UUID should be in format:
            XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
            
            Where X is a hexadecimal digit (0-9, A-F)
            """
        }
    }
    
    private func detectFormat(_ input: String) -> String {
        if input.hasPrefix("{") && input.hasSuffix("}") {
            return "Braces"
        } else if input.contains("-") {
            return input.uppercased() == input ? "Standard (Uppercase)" : "Standard (Lowercase)"
        } else {
            return "No Hyphens"
        }
    }
    
    private func detectVersion(_ uuidString: String) -> String {
        let versionIndex = uuidString.index(uuidString.startIndex, offsetBy: 14)
        let versionChar = uuidString[versionIndex]
        
        switch versionChar {
        case "1":
            return "Version 1 (Time-based)"
        case "4":
            return "Version 4 (Random)"
        case "5":
            return "Version 5 (Name-based SHA-1)"
        default:
            return "Version \(versionChar)"
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
}

enum UUIDVersion: CaseIterable {
    case v1, v4, v5
    
    var title: String {
        switch self {
        case .v1: return "V1 (Time)"
        case .v4: return "V4 (Random)"
        case .v5: return "V5 (Name)"
        }
    }
}

enum UUIDFormat: CaseIterable {
    case standard, noHyphens, uppercase, lowercase, braces
    
    var title: String {
        switch self {
        case .standard: return "Standard"
        case .noHyphens: return "No Hyphens"
        case .uppercase: return "Uppercase"
        case .lowercase: return "Lowercase"
        case .braces: return "Braces"
        }
    }
}

struct UUIDPattern {
    let name: String
    let example: String
}

private let commonPatterns = [
    UUIDPattern(name: "Standard UUID", example: "550e8400-e29b-41d4-a716-446655440000"),
    UUIDPattern(name: "No Hyphens", example: "550e8400e29b41d4a716446655440000"),
    UUIDPattern(name: "With Braces", example: "{550e8400-e29b-41d4-a716-446655440000}"),
    UUIDPattern(name: "Nil UUID", example: "00000000-0000-0000-0000-000000000000")
]

#Preview {
    UUIDGeneratorView()
}