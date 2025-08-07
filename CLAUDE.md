# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# DevHelper - Claude Context

## Project Overview
DevHelper is a native macOS application built with SwiftUI that provides essential developer utilities in a single, unified interface. The app contains 11 fully-functional tools commonly used by developers, with search functionality and modern UI design.

## Current Status
**✅ COMPLETE** - All 11 tools are fully implemented and working. Version 1.7+ released.

## Tools Implemented

### 1. Timestamp Converter (`TimestampConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: Auto-detection of timestamp formats (seconds/milliseconds/microseconds/nanoseconds), bidirectional conversion, timezone support (Local/UTC), current timestamp generation
- **UI**: Two-column layout with real-time conversion, **selectable text results**
- **Recent Updates**: Fixed result selectability issue - users can now select and copy results

### 2. Unit Converter (`UnitConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: 6 categories (Data, Length, Weight, Temperature, Area, Volume), real-time conversion, special temperature handling
- **UI**: Category picker with from/to unit selection, **Data category moved to first position**
- **Recent Updates**: Removed Time category, Data now default selection

### 3. JSON Formatter (`JSONFormatterView.swift`)
- **Status**: ✅ Complete
- **Features**: Format (pretty print), minify, validate, escape/unescape for strings, JSON diff/compare mode, syntax error highlighting
- **UI**: Two-panel layout with mode selection, three-panel layout for diff mode
- **Recent Updates**: Added unescape functionality for escaped JSON strings, diff mode for JSON comparison with side-by-side view

### 4. Base64 Encode/Decode (`Base64View.swift`)
- **Status**: ✅ Complete
- **Features**: Text encoding/decoding, URL-safe Base64 variant, swap functionality
- **UI**: Tabbed interface with encode/decode modes
- **Recent Updates**: Renamed from "Base64 Encoder/Decoder" to "Base64 Encode/Decode"

### 5. Regex Test (`RegexTestView.swift`)
- **Status**: ✅ Complete
- **Features**: Pattern matching, capture groups, replacement, common patterns library, regex flags
- **UI**: Pattern input with results display and common pattern buttons

### 6. UUID Generator (`UUIDGeneratorView.swift`)
- **Status**: ✅ Complete
- **Features**: Multiple UUID versions (v1, v4, v5, v7), multiple formats, bulk generation (1-100), UUID validation, common pattern examples, **UUID v7 timestamp extraction**
- **UI**: Generation controls with scrollable results list
- **Recent Updates**: Added UUID v7 support with timestamp-ordered generation and automatic timestamp extraction from v7 UUIDs

### 7. URL Tools (`URLToolsView.swift`)
- **Status**: ✅ Complete
- **Features**: URL encoding/decoding, comprehensive URL parsing, query parameter breakdown
- **UI**: Three-tab interface (Encoder/Decoder/Parser)

### 8. IP Query (`IPQueryView.swift`)
- **Status**: ✅ Complete
- **Features**: Dual IP detection (international vs China networks), current IP discovery, IP geolocation query, comprehensive location information
- **UI**: Two-column layout with smart dual IP display, sample IP buttons, detailed location breakdown
- **Recent Updates**: Added User-Agent headers for bot detection avoidance, uses Baidu API for reliable China IP detection

### 9. HTTP Request (`HTTPRequestView.swift`)
- **Status**: ✅ Complete
- **Features**: Full HTTP client with all methods (GET/POST/PUT/DELETE/etc), headers management, Basic/Bearer authentication, request body support, TLS verification skip, response timing, SSE streaming support, binary download, JSON tree view, request history
- **UI**: Split layout with request configuration (headers/auth/body tabs) and response display (body/headers/tree), real-time timer, status code indicators, copy/save functionality
- **Recent Updates**: Added JSON tree view for structured response exploration, improved request history display

### 10. QR Code (`QRCodeView.swift`)
- **Status**: ✅ Complete
- **Features**: QR code generation with multiple sizes (128x128 to 1024x1024+ custom), error correction levels, QR code scanning from files/clipboard, URL detection and opening
- **UI**: Tabbed interface (Generate/Scan), two-column layouts with visual flow indicators, size-aware generation, image preview for scanning
- **Generation**: Real-time QR code creation, copy to clipboard, save to file with proper entitlements, dynamic sizing with pixel indicators
- **Scanning**: File selection, clipboard paste, image preview with scan results, automatic URL recognition

### 11. Parquet Viewer (`ParquetViewerView.swift`)
- **Status**: ✅ Complete (with limitations)
- **Features**: Parquet file validation, file structure verification, basic metadata display, sample data preview
- **UI**: Tabbed interface (Data/Schema/Metadata), file selection with drag-and-drop support, table view for data preview
- **Validation**: Checks PAR1 magic bytes, validates file structure, reads footer length, provides file size and format info
- **Limitations**: Full data extraction requires external libraries (DuckDB/Arrow). Current implementation validates format and shows file structure only
- **Recent Updates**: Added as requested in GitHub issue #4, provides basic Parquet file inspection without external dependencies

## Architecture

### Project Structure
```
DevHelper/
├── DevHelper.xcodeproj/
├── DevHelper/
│   ├── DevHelperApp.swift          # Main app entry point
│   ├── ContentView.swift           # Navigation split view
│   ├── Models/
│   │   └── ToolType.swift          # Tool definitions
│   └── Views/                      # All 9 tool implementations
│       ├── TimestampConverterView.swift
│       ├── UnitConverterView.swift
│       ├── JSONFormatterView.swift
│       ├── Base64View.swift
│       ├── UUIDGeneratorView.swift
│       ├── URLToolsView.swift
│       ├── RegexTestView.swift
│       ├── IPQueryView.swift
│       ├── HTTPRequestView.swift
│       ├── QRCodeView.swift
│       └── ParquetViewerView.swift
└── DESIGN.md                       # Comprehensive design document
```

### Technical Stack
- **Platform**: macOS 14.0+
- **Framework**: SwiftUI
- **Language**: Swift 5.0
- **Architecture**: MVVM pattern with @State and @Published
- **Navigation**: NavigationSplitView with sidebar

## Key Implementation Details

### Navigation Pattern
- All tools are defined in `ToolType` enum with titles and SF Symbols icons
- `ContentView` uses NavigationSplitView with sidebar selection and **search functionality**
- Each tool is a separate SwiftUI view with consistent styling
- **Search bar** in sidebar allows filtering tools by title

### Common UI Patterns
- **Two-column layouts**: Input/output sections with arrow indicators
- **Tabbed interfaces**: Multiple related functions in single tool
- **Copy functionality**: Ubiquitous copy-to-clipboard buttons
- **Sample data**: Quick testing with provided examples
- **Real-time processing**: Instant results as user types

### Shared Components
- Consistent button styling (`.bordered`, `.borderedProminent`)
- Monospace fonts for technical data
- Color coding (green for success, red for errors)
- Rounded border text field styling

## Build Configuration

### Target Settings
- **Bundle ID**: com.devhelper.DevHelper
- **Minimum macOS**: 14.0
- **Version**: 1.6 (Build 7)
- **Entitlements**: App Sandbox enabled, Hardened Runtime enabled

### Dependencies
- **SwiftUI**: UI framework
- **Foundation**: Core utilities and networking
- **AppKit**: Clipboard access (NSPasteboard), file dialogs
- **CoreImage**: QR code generation with CIFilter.qrCodeGenerator()
- **Vision**: QR code scanning with VNDetectBarcodesRequest
- **UniformTypeIdentifiers**: Modern file type handling for save dialogs
- **No external packages**: Pure Apple frameworks only

## Recent Updates (Version 1.7+)

### Latest Features (Version 1.7+)
- **Parquet Viewer Tool**: Basic Parquet file validation and inspection functionality
  - **File Validation**: Checks PAR1 magic bytes at header and footer for valid Parquet format
  - **Structure Analysis**: Reads footer length and validates file structure integrity
  - **Preview Interface**: Three-tab view for Data, Schema, and Metadata inspection
  - **Sample Data Display**: Shows sample data grid for file preview (not actual data)
  - **File Metadata**: Displays file size, format version, and structure information
  - **Limitations Notice**: Clearly indicates that full parsing requires external libraries
  - **Recommendations**: Provides guidance on tools for complete Parquet analysis (DuckDB, Arrow, Python)

### Previous Features (Version 1.6)
- **QR Code Tool**: Comprehensive QR code generation and scanning functionality
  - **Generation**: Multiple sizes (Small 128x128, Medium 256x256, Large 512x512, Extra Large 1024x1024, Custom size)
  - **Error Correction**: Configurable levels (L/M/Q/H) for different use cases
  - **File Operations**: Copy to clipboard, save to PNG with proper entitlements (read-write access)
  - **Scanning**: File selection, clipboard paste, image preview with scan results
  - **UI Enhancement**: Two-column layout with visual flow indicators, buttons positioned below QR code
- **UUID v7 Support**: Added timestamp-ordered UUID generation to UUID Generator
  - **UUID v7 Generation**: Creates timestamp-ordered UUIDs with embedded millisecond timestamps
  - **Timestamp Extraction**: Automatically extracts and displays embedded timestamps from UUID v7
  - Lexicographically sortable UUIDs for time-based ordering
- **JSON Unescape**: Enhanced JSON Formatter with bidirectional string processing
  - Handles all standard JSON escape sequences and Unicode sequences

### Previous Updates (Version 1.5)
- **JSON Differ**: Added comprehensive JSON comparison functionality to JSON Formatter
  - Side-by-side comparison view with three panels (JSON 1, JSON 2, Differences)
  - Real-time diff highlighting and detailed change detection
  - Integrated into existing JSON Formatter with seamless mode switching
- **JSON Tree View**: Enhanced HTTP Request tool with structured JSON response exploration
  - Interactive tree view for JSON responses with expand/collapse functionality
  - Hierarchical display of JSON objects and arrays
  - Improved readability for complex API responses

## Previous Updates (Version 1.4)

### Major New Feature
- **HTTP Request Tool**: Professional-grade HTTP client with comprehensive functionality
  - All HTTP methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
  - Advanced headers management with common header shortcuts
  - Authentication support (Basic Auth, Bearer Token)
  - Request body support for JSON, XML, form data
  - TLS verification bypass option for development
  - Real-time request timer and response time measurement
  - Server-Sent Events (SSE) streaming support with real-time updates
  - Response viewing modes (Preview/Raw) with automatic JSON formatting
  - Binary data download functionality with file save dialog
  - Comprehensive error handling and status code visualization
  - Copy/save functionality for requests and responses

### Previous Updates (Version 1.3)
- **IP Query Tool**: Complete IP address discovery and geolocation
- **Dual IP detection**: International vs China network awareness
- **User-Agent headers**: Bot detection avoidance for API calls

## Common Development Tasks

### Adding a New Tool
1. Add case to `ToolType` enum in `Models/ToolType.swift`
2. Create new SwiftUI view file in `Views/`
3. Add switch case in `ContentView.swift`
4. Follow established UI patterns and styling

### Modifying Existing Tools
- Each tool is self-contained in its own file
- Use established state management patterns
- Maintain consistent UI styling and copy functionality

### Testing
- Each tool has sample data/examples for quick testing
- SwiftUI Previews available for all views
- Manual testing covers error cases and edge conditions

## Key Architecture Notes

### Tool Implementation Pattern
Each tool follows a consistent pattern:
1. **Enum definition** in `ToolType.swift` with title and SF Symbol icon
2. **SwiftUI View** in `Views/` directory with @State management
3. **Switch case** in `ContentView.swift` for navigation
4. **Common UI patterns**: Two-column layouts, copy buttons, sample data

### State Management
- Uses `@State` for local view state (input text, results, UI state)
- No complex state management - each tool is self-contained
- Real-time updates via `onChange` modifiers

### File Operations & Entitlements
- **Save operations** require `com.apple.security.files.user-selected.read-write` entitlement
- **Network requests** require `com.apple.security.network.client` entitlement  
- **Clipboard access** uses `NSPasteboard` (macOS) not `UIPasteboard` (iOS)

### Common Development Issues
- **Xcode project updates**: When adding new Swift files, must manually update `.pbxproj` file
- **macOS vs iOS APIs**: Avoid iOS-specific modifiers like `.keyboardType(.decimalPad)`
- **File type handling**: Use `UniformTypeIdentifiers` for modern file operations
- **Image operations**: Use `CoreImage` for generation, `Vision` for recognition

## Future Enhancements

### Potential Features
- **Preferences window**: User customization options
- **Themes**: Light/dark mode preferences
- **Keyboard shortcuts**: Quick access to common functions
- **Export/Import**: Save tool configurations
- **IP Query history**: Persistent storage for IP queries
- **Additional geolocation providers**: More IP data sources

### Technical Improvements
- **Performance**: Optimize for large text processing
- **Accessibility**: Enhanced VoiceOver support
- **Localization**: Multi-language support

## Development Commands

### Build & Run
```bash
# Open project in Xcode (recommended)
open DevHelper.xcodeproj

# Build for macOS from command line
xcodebuild -project DevHelper.xcodeproj -scheme DevHelper -configuration Debug

# Clean build artifacts
xcodebuild -project DevHelper.xcodeproj -scheme DevHelper clean

# Build and launch app (using Claude Code MCP tools)
# 1. Build: mcp__XcodeBuildMCP__build_mac_proj
# 2. Get app path: mcp__XcodeBuildMCP__get_mac_app_path_proj  
# 3. Launch: mcp__XcodeBuildMCP__launch_mac_app
```

### Xcode Project Management
- **Adding new tools**: Must add both the Swift file AND update the Xcode project file (.pbxproj)
- **Entitlements**: Located in `DevHelper.entitlements` - includes sandbox, network, and file read-write permissions
- **Target settings**: Bundle ID `com.devhelper.DevHelper`, minimum macOS 14.0

### Key Development Notes
- **No external dependencies**: Project uses only native SwiftUI, Foundation, and AppKit
- **No package managers**: No CocoaPods, SPM packages, or Carthage dependencies
- **App Sandbox enabled**: Network client access granted for IP Query tool
- **Target**: macOS 14.0+, requires Xcode 15.4+

### Project Management
- **Design Document**: `DESIGN.md` contains comprehensive architecture details
- **This File**: `CLAUDE.md` provides context for future Claude sessions
- **README**: `README.md` contains user-facing project information

## Success Metrics
- ✅ All 11 essential tools fully implemented
- ✅ Consistent UI/UX across all tools
- ✅ Real-time processing and feedback
- ✅ Professional macOS native experience
- ✅ Comprehensive error handling
- ✅ Copy-to-clipboard functionality throughout
- ✅ Search functionality for quick tool access
- ✅ Selectable text in results areas
- ✅ File save/load operations with proper entitlements
- ✅ Streamlined feature set focused on core developer needs

---

**Last Updated**: Version 1.7+ with Parquet Viewer tool implementation.
**Latest Addition**: Parquet file validation and inspection tool with format verification, structure analysis, and metadata display.
**Architecture**: Pure Swift implementation for file validation, provides guidance for full parsing with external libraries.