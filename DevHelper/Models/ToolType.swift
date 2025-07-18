import Foundation

enum ToolType: String, CaseIterable, Identifiable {
    case timestampConverter = "timestamp"
    case unitConverter = "unit"
    case jsonFormatter = "json"
    case base64 = "base64"
    case httpRequest = "http"
    case regexTester = "regex"
    case uuidGenerator = "uuid"
    case urlTools = "url"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .timestampConverter:
            return "Timestamp Converter"
        case .unitConverter:
            return "Unit Converter"
        case .jsonFormatter:
            return "JSON Formatter"
        case .base64:
            return "Base64 Encoder/Decoder"
        case .httpRequest:
            return "HTTP Request"
        case .regexTester:
            return "Regex Tester"
        case .uuidGenerator:
            return "UUID Generator"
        case .urlTools:
            return "URL Tools"
        }
    }
    
    var iconName: String {
        switch self {
        case .timestampConverter:
            return "clock"
        case .unitConverter:
            return "scalemass"
        case .jsonFormatter:
            return "doc.text"
        case .base64:
            return "textformat.abc"
        case .httpRequest:
            return "network"
        case .regexTester:
            return "magnifyingglass"
        case .uuidGenerator:
            return "dice"
        case .urlTools:
            return "link"
        }
    }
}