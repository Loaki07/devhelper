import Foundation

enum ToolType: String, CaseIterable, Identifiable {
    case timestampConverter = "timestamp"
    case unitConverter = "unit"
    case jsonFormatter = "json"
    case base64 = "base64"
    case urlTools = "url"
    case regexTester = "regex"
    case uuidGenerator = "uuid"
    case ipQuery = "ip"
    
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
            return "Base64 Encode/Decode"
        case .urlTools:
            return "URL Tools"
        case .regexTester:
            return "Regex Tester"
        case .uuidGenerator:
            return "UUID Generator"
        case .ipQuery:
            return "IP Query"
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
            return "6.circle"
        case .urlTools:
            return "link"
        case .regexTester:
            return "magnifyingglass"
        case .uuidGenerator:
            return "dice"
        case .ipQuery:
            return "globe"
        }
    }
}