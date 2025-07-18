# DevHelper - Design Document

## Overview
DevHelper is a native macOS application built with SwiftUI that provides essential developer utilities in a single, easy-to-use interface. The app follows Apple's Human Interface Guidelines and provides a consistent, professional experience across all tools.

## Architecture

### Project Structure
```
DevHelper/
├── DevHelper.xcodeproj/          # Xcode project files
├── DevHelper/
│   ├── DevHelperApp.swift        # Main app entry point
│   ├── ContentView.swift         # Main navigation interface
│   ├── Models/
│   │   └── ToolType.swift        # Tool definitions and metadata
│   ├── Views/                    # Individual tool implementations
│   │   ├── TimestampConverterView.swift
│   │   ├── UnitConverterView.swift
│   │   ├── JSONFormatterView.swift
│   │   ├── Base64View.swift
│   │   ├── UUIDGeneratorView.swift
│   │   ├── URLToolsView.swift
│   │   └── RegexTesterView.swift
│   ├── Assets.xcassets/          # App icons and assets
│   └── Preview Content/          # SwiftUI preview assets
└── README.md                     # Project documentation
```

### Technical Stack
- **Platform**: macOS 14.0+
- **Framework**: SwiftUI
- **Language**: Swift 5.0
- **Architecture Pattern**: MVVM (Model-View-ViewModel)
- **Data Binding**: Combine framework with @Published and @State

## App Architecture

### Main Navigation
- **NavigationSplitView**: Primary navigation structure
- **Sidebar**: Tool selection with icons and titles, **search functionality**
- **Detail View**: Selected tool interface
- **Window Configuration**: Resizable with minimum size constraints
- **Search Bar**: Integrated search to filter tools by name

### Tool Integration Pattern
Each tool follows a consistent pattern:
1. **Enum Definition**: Added to `ToolType` enum
2. **Icon Assignment**: SF Symbols icon
3. **View Implementation**: SwiftUI view with consistent styling
4. **Navigation Integration**: Switch case in `ContentView`

## Tool Specifications

### 1. Timestamp Converter
**File**: `TimestampConverterView.swift`

**Features**:
- Auto-detection of timestamp formats (10/13/16/19 digits)
- Bidirectional conversion (timestamp ↔ human-readable)
- Timezone support (Local/UTC)
- Current timestamp generation
- Real-time conversion

**UI Components**:
- Two-column layout (timestamp input/output)
- Toggle for timezone selection
- Current timestamp button
- Copy functionality

**Implementation Details**:
- Uses `Date` and `DateFormatter` for conversions
- Automatic format detection based on digit count
- TimeInterval calculations for different precisions

### 2. Unit Converter
**File**: `UnitConverterView.swift`

**Features**:
- 7 unit categories: Length, Weight, Temperature, Data, Time, Area, Volume
- Real-time bidirectional conversion
- Swap units functionality
- Special temperature conversion logic

**UI Components**:
- Segmented picker for categories
- Dropdown menus for unit selection
- Numeric input with real-time updates
- Swap button for quick unit exchange

**Implementation Details**:
- `UnitCategory` enum with associated units
- `UnitData` struct for conversion multipliers
- Special handling for temperature conversions (C/F/K)
- Base unit conversion pattern

### 3. JSON Formatter
**File**: `JSONFormatterView.swift`

**Features**:
- Format (pretty print)
- Minify (remove whitespace)
- Validate with detailed feedback
- Escape for string embedding
- Syntax error highlighting

**UI Components**:
- Segmented picker for modes
- Two-panel layout (input/output)
- Validation status indicator
- Sample JSON button

**Implementation Details**:
- `JSONSerialization` for parsing and formatting
- Error handling with descriptive messages
- Real-time processing with input validation
- Character count tracking

### 4. Base64 Encoder/Decoder
**File**: `Base64View.swift`

**Features**:
- Text encoding/decoding
- URL-safe Base64 variant
- Real-time conversion
- Swap functionality between modes
- Sample data for testing

**UI Components**:
- Tab-based interface (Encode/Decode)
- URL-safe toggle
- Two-panel layout per mode
- Sample and swap buttons

**Implementation Details**:
- `Data.base64EncodedString()` for encoding
- `Data(base64Encoded:)` for decoding
- URL-safe character substitution
- UTF-8 encoding/decoding

### 5. UUID Generator
**File**: `UUIDGeneratorView.swift`

**Features**:
- Multiple UUID versions (V1, V4, V5)
- Bulk generation (1-100 UUIDs)
- Multiple format options
- UUID validation
- Common pattern examples

**UI Components**:
- Version picker
- Format dropdown
- Bulk count stepper
- Scrollable UUID list with individual copy buttons
- Validation section with examples

**Implementation Details**:
- `UUID()` for generation
- Format transformations (hyphens, case, braces)
- Validation using `UUID(uuidString:)`
- Version detection from UUID structure

### 6. URL Tools
**File**: `URLToolsView.swift`

**Features**:
- URL encoding/decoding
- Complete URL parsing
- Query parameter breakdown
- URL reconstruction
- Component extraction

**UI Components**:
- Three-tab interface (Encoder/Decoder/Parser)
- Component breakdown tables
- Query parameter list
- URL reconstruction display

**Implementation Details**:
- `String.addingPercentEncoding()` for encoding
- `String.removingPercentEncoding()` for decoding
- `URLComponents` for parsing
- Query parameter array management

### 7. HTTP Request Tool (Planned)
**File**: `HTTPRequestView.swift`

**Planned Features**:
- HTTP method selection (GET, POST, PUT, DELETE, etc.)
- Header management
- Request body support (JSON, form data, raw)
- Response display with formatting
- Request history
- Authentication support

**UI Design**:
- Request builder interface
- Response viewer with syntax highlighting
- History sidebar
- Export to cURL functionality

### 8. Regex Tester (Planned)
**File**: `RegexTesterView.swift`

**Planned Features**:
- Pattern testing with highlighting
- Capture group display
- Flag support (global, case-insensitive, etc.)
- Match replacement
- Common pattern library

**UI Design**:
- Pattern input field
- Test string area with highlighting
- Match results panel
- Replace mode interface

## UI Design Principles

### Color Scheme
- **Primary**: System accent color
- **Secondary**: Gray tones for subtle elements
- **Success**: Green for valid states
- **Error**: Red for invalid states
- **Background**: System background colors

### Typography
- **Headers**: `.largeTitle`, `.headline` weights
- **Body**: `.body` with monospace for code/data
- **Captions**: `.caption` for metadata
- **Monospace**: Used for all technical data display

### Layout Patterns
- **Two-Column**: Input/output sections with arrow indicator
- **Tabbed**: Multiple related tools in single view
- **Sidebar**: Main navigation with SF Symbols
- **Split View**: Resizable panels for complex tools

### Interactive Elements
- **Buttons**: Consistent styling with `.bordered` and `.borderedProminent`
- **Text Fields**: Rounded border style
- **Pickers**: Segmented for modes, menu for options
- **Copy Buttons**: Ubiquitous copy-to-clipboard functionality

## Data Models

### ToolType Enum
```swift
enum ToolType: String, CaseIterable, Identifiable {
    case timestampConverter, unitConverter, jsonFormatter, 
         base64, httpRequest, regexTester, uuidGenerator, urlTools
    
    var title: String { /* Display names */ }
    var iconName: String { /* SF Symbols */ }
}
```

### Supporting Models
- `UnitCategory` and `UnitData` for unit conversions
- `JSONMode` for JSON operations
- `Base64Tab` for encoding modes
- `UUIDVersion` and `UUIDFormat` for UUID options
- `URLTab` for URL tool modes

## Build Configuration

### Target Settings
- **Minimum macOS**: 14.0
- **Bundle Identifier**: com.devhelper.DevHelper
- **App Sandbox**: Enabled
- **Network Access**: Enabled (for HTTP tool)
- **File Access**: User-selected read-only

### Dependencies
- **SwiftUI**: UI framework
- **Combine**: Reactive programming
- **Foundation**: Core utilities
- **AppKit**: macOS integration (clipboard access)

## Testing Strategy

### Manual Testing
- Each tool has sample data for quick testing
- Real-time feedback for immediate validation
- Error cases handled gracefully

### UI Testing
- SwiftUI Previews for rapid development
- Different window sizes and orientations
- Accessibility compliance

## Future Enhancements

### Planned Features
1. **HTTP Request Tool**: Complete implementation with advanced features
2. **Regex Tester**: Pattern matching with visual feedback
3. **Preferences**: User customization options
4. **Themes**: Light/dark mode preferences
5. **Export/Import**: Save tool configurations
6. **Shortcuts**: Keyboard shortcuts for common actions

### Technical Improvements
- **Performance**: Optimize for large data processing
- **Memory**: Efficient handling of large text inputs
- **Accessibility**: VoiceOver support
- **Localization**: Multi-language support

## Maintenance Guidelines

### Code Organization
- Each tool in separate Swift file
- Consistent naming conventions
- Comprehensive documentation
- SwiftUI best practices

### Adding New Tools
1. Add case to `ToolType` enum
2. Create new SwiftUI view file
3. Add to ContentView switch statement
4. Update this design document
5. Add appropriate tests

### Styling Updates
- Modify shared UI components
- Update color scheme in Assets.xcassets
- Maintain consistency across all tools

## Deployment

### App Store Requirements
- Code signing configuration
- App icon in all required sizes
- Privacy policy for network access
- App Store Connect metadata

### Distribution Options
- Mac App Store
- Direct distribution with notarization
- Developer ID signing for enterprise

---

*This design document should be updated whenever significant changes are made to the app architecture or individual tools.*