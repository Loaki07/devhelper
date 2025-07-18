import SwiftUI

struct ContentView: View {
    @State private var selectedTool: ToolType = .timestampConverter
    
    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DevHelper")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Developer Tools")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                List(ToolType.allCases, selection: $selectedTool) { tool in
                    Label(tool.title, systemImage: tool.iconName)
                        .tag(tool)
                }
            }
            .frame(minWidth: 250)
        } detail: {
            Group {
                switch selectedTool {
                case .timestampConverter:
                    TimestampConverterView()
                case .unitConverter:
                    UnitConverterView()
                case .jsonFormatter:
                    JSONFormatterView()
                case .base64:
                    Base64View()
                case .httpRequest:
                    HTTPRequestView()
                case .regexTester:
                    RegexTesterView()
                case .uuidGenerator:
                    UUIDGeneratorView()
                case .urlTools:
                    URLToolsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    ContentView()
}