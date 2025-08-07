import SwiftUI
import UniformTypeIdentifiers
import AppKit
import DuckDB

// Data row structure for Table view
struct ParquetRow: Identifiable {
    let id = UUID()
    let values: [String]
    
    subscript(index: Int) -> String {
        guard index < values.count else { return "" }
        return values[index]
    }
}

// Schema information structure
struct SchemaInfo: Identifiable {
    let id = UUID()
    let columnName: String
    let dataType: String
    let nullable: String
}

struct ParquetViewerView: View {
    @State private var selectedTab = "data"
    @State private var fileURL: URL?
    @State private var fileName: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var tableRows: [ParquetRow] = []
    @State private var columnNames: [String] = []
    @State private var columnTypes: [String] = []
    @State private var schemaRows: [SchemaInfo] = []
    @State private var metadata: String = ""
    
    @State private var rowCount: Int = 0
    @State private var columnCount: Int = 0
    @State private var fileSize: String = ""
    
    @State private var selectedRows = Set<ParquetRow.ID>()
    
    private let maxPreviewRows = 100
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parquet Viewer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                Button(action: selectFile) {
                    Label("Select Parquet File", systemImage: "doc.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                
                if fileURL != nil {
                    Button(action: clearFile) {
                        Label("Clear", systemImage: "xmark.circle")
                    }
                    .buttonStyle(.bordered)
                }
            }

            if fileURL != nil {
                TabView(selection: $selectedTab) {
                    dataView
                        .tabItem {
                            Label("Data", systemImage: "tablecells")
                        }
                        .tag("data")
                    
                    schemaView
                        .tabItem {
                            Label("Schema", systemImage: "list.bullet.rectangle")
                        }
                        .tag("schema")
                    
                    metadataView
                        .tabItem {
                            Label("Metadata", systemImage: "info.circle")
                        }
                        .tag("metadata")
                }
                .frame(maxHeight: .infinity)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("Select a Parquet file to view its contents")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            }
            
            if let errorMessage = errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var dataView: some View {
        VStack(alignment: .leading, spacing: 10) {
            dataHeaderView
            
            if isLoading {
                ProgressView("Loading data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !tableRows.isEmpty {
                tableContentView
                
                if rowCount > maxPreviewRows {
                    Text("Showing first \(maxPreviewRows) rows of \(rowCount) total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                }
            } else {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private var dataHeaderView: some View {
        HStack {
            Text("Data Preview")
                .font(.headline)
            
            Spacer()
            
            if rowCount > 0 {
                Text("\(rowCount) rows × \(columnCount) columns")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button(action: exportToCSV) {
                Label("Export CSV", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.bordered)
            .disabled(tableRows.isEmpty)
            
            Button(action: exportToJSON) {
                Label("Export JSON", systemImage: "doc.text")
            }
            .buttonStyle(.bordered)
            .disabled(tableRows.isEmpty)
        }
        .padding(.horizontal)
    }
    
    private var tableContentView: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 0) {
                // Header row
                tableHeaderRow
                
                // Data rows
                ForEach(Array(tableRows.enumerated()), id: \.element.id) { rowIndex, row in
                    tableDataRow(row: row, rowIndex: rowIndex)
                }
            }
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
    
    private var tableHeaderRow: some View {
        HStack(spacing: 0) {
            ForEach(Array(columnNames.enumerated()), id: \.offset) { index, columnName in
                headerCell(columnName: columnName, index: index)
            }
        }
    }
    
    @ViewBuilder
    private func headerCell(columnName: String, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(columnName)
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
            if index < columnTypes.count {
                Text(columnTypes[index])
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(8)
        .frame(width: 150, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .overlay(
            Rectangle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    private func tableDataRow(row: ParquetRow, rowIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<columnNames.count, id: \.self) { colIndex in
                dataCell(value: row[colIndex], rowIndex: rowIndex)
            }
        }
    }
    
    private func dataCell(value: String, rowIndex: Int) -> some View {
        Text(value)
            .font(.system(.caption, design: .monospaced))
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(8)
            .frame(width: 150, alignment: .leading)
            .background(rowIndex % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
            .overlay(
                Rectangle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .textSelection(.enabled)
            .help(value) // Show full text on hover
    }
    
    private var schemaView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Schema Information")
                    .font(.headline)
                
                Spacer()
                
                if !schemaRows.isEmpty {
                    Text("\(schemaRows.count) columns")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button(action: exportSchemaToCSV) {
                    Label("Export CSV", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
                .disabled(schemaRows.isEmpty)
                
                Button(action: exportSchemaToJSON) {
                    Label("Export JSON", systemImage: "doc.text")
                }
                .buttonStyle(.bordered)
                .disabled(schemaRows.isEmpty)
            }
            .padding(.horizontal)
            
            if schemaRows.isEmpty {
                Text("No schema information available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header row
                        HStack(spacing: 0) {
                            Text("Column Name")
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.bold)
                                .padding(8)
                                .frame(width: 500, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                )
                            
                            Text("Data Type")
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.bold)
                                .padding(8)
                                .frame(width: 150, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                )
                            
                            Text("Nullable")
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.bold)
                                .padding(8)
                                .frame(width: 100, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                )
                        }
                        
                        // Data rows
                        ForEach(Array(schemaRows.enumerated()), id: \.element.id) { index, row in
                            HStack(spacing: 0) {
                                Text(row.columnName)
                                    .font(.system(.caption, design: .monospaced))
                                    .padding(8)
                                    .frame(width: 500, alignment: .leading)
                                    .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                    )
                                    .textSelection(.enabled)
                                
                                Text(row.dataType)
                                    .font(.system(.caption, design: .monospaced))
                                    .padding(8)
                                    .frame(width: 150, alignment: .leading)
                                    .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                    )
                                    .textSelection(.enabled)
                                
                                Text(row.nullable)
                                    .font(.system(.caption, design: .monospaced))
                                    .padding(8)
                                    .frame(width: 100, alignment: .leading)
                                    .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                    )
                                    .textSelection(.enabled)
                            }
                        }
                    }
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
        }
    }
    
    private var metadataView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("File Metadata")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { copyToClipboard(metadata) }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .buttonStyle(.bordered)
                .disabled(metadata.isEmpty)
            }
            .padding(.horizontal)
            
            ScrollView {
                Text(metadata.isEmpty ? "No metadata available" : metadata)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
    
    private func selectFile() {
        let panel = NSOpenPanel()
        panel.title = "Select Parquet File"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [UTType(filenameExtension: "parquet") ?? .data]
        
        if panel.runModal() == .OK, let url = panel.url {
            loadParquetFile(url)
        }
    }
    
    private func clearFile() {
        fileURL = nil
        fileName = ""
        tableRows = []
        columnNames = []
        columnTypes = []
        schemaRows = []
        metadata = ""
        rowCount = 0
        columnCount = 0
        fileSize = ""
        errorMessage = nil
        selectedRows = Set<ParquetRow.ID>()
    }
    
    private func loadParquetFile(_ url: URL) {
        fileURL = url
        fileName = url.lastPathComponent
        isLoading = true
        errorMessage = nil
        
        // Get file size
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attributes[.size] as? Int64 {
                fileSize = formatFileSize(size)
            }
        } catch {
            print("Failed to get file attributes: \(error)")
        }
        
        Task {
            await parseParquetFileWithDuckDB(url)
        }
    }
    
    private func parseParquetFileWithDuckDB(_ url: URL) async {
        do {
            // Create in-memory database
            let database = try Database(store: .inMemory)
            let connection = try database.connect()
            
            // Get row count first
            let countResult = try connection.query("""
                SELECT COUNT(*) FROM read_parquet('\(url.path)')
            """)
            
            if let countColumn = countResult.first {
                let count = countColumn.cast(to: Int64.self)[DBInt(0)] ?? 0
                await MainActor.run {
                    self.rowCount = Int(count)
                }
            }
            
            // Get schema information
            let schemaResult = try connection.query("""
                DESCRIBE SELECT * FROM read_parquet('\(url.path)')
            """)
            
            var colNames: [String] = []
            var colTypes: [String] = []
            var schemaInfoRows: [SchemaInfo] = []
            
            if schemaResult.count >= 3 {
                let columnNameCol = schemaResult[0]
                let columnTypeCol = schemaResult[1]
                let nullableCol = schemaResult[2]
                
                let nameStrings = columnNameCol.cast(to: String.self)
                let typeStrings = columnTypeCol.cast(to: String.self)
                let nullableStrings = nullableCol.cast(to: String.self)
                
                for i in 0..<nameStrings.count {
                    let idx = DBInt(i)
                    let name = nameStrings[idx] ?? "unknown"
                    let type = typeStrings[idx] ?? "unknown"
                    let nullable = nullableStrings[idx] ?? "unknown"
                    
                    colNames.append(name)
                    colTypes.append(type)
                    
                    // Create schema info row for table display
                    schemaInfoRows.append(SchemaInfo(
                        columnName: name,
                        dataType: type,
                        nullable: nullable == "YES" ? "Yes" : "No"
                    ))
                }
            }
            
            await MainActor.run {
                self.columnNames = colNames
                self.columnTypes = colTypes
                self.columnCount = colNames.count
                self.schemaRows = schemaInfoRows
            }
            
            // Get data preview (limited to maxPreviewRows)
            let dataResult = try connection.query("""
                SELECT * FROM read_parquet('\(url.path)') LIMIT \(maxPreviewRows)
            """)
            
            var rows: [ParquetRow] = []
            
            // Check if we have results
            if !dataResult.isEmpty {
                let numRows = dataResult[0].count
                
                // Iterate through rows
                for rowIdx in 0..<numRows {
                    var rowValues: [String] = []
                    
                    // Iterate through columns in the order they appear
                    for column in dataResult {
                        let value = extractValueFromColumn(column, at: rowIdx)
                        rowValues.append(value)
                    }
                    
                    rows.append(ParquetRow(values: rowValues))
                }
            }
            
            await MainActor.run {
                self.tableRows = rows
            }
            
            // Get Parquet file metadata
            var metadataLines: [String] = []
            metadataLines.append("═══════════════════════════════════════════")
            metadataLines.append("FILE METADATA")
            metadataLines.append("═══════════════════════════════════════════")
            metadataLines.append("")
            
            // Query parquet_metadata function
            let fileMetadataResult = try connection.query("""
                SELECT * FROM parquet_file_metadata('\(url.path)')
            """)
            
            if !fileMetadataResult.isEmpty && fileMetadataResult[0].count > 0 {
                // Extract metadata fields
                if fileMetadataResult.count >= 6 {
                    let fileNameCol = fileMetadataResult[0].cast(to: String.self)  
                    let createdByCol = fileMetadataResult[1].cast(to: String.self)
                    let numRowsCol = fileMetadataResult[2].cast(to: Int64.self) 
                    let numRowGroupsCol = fileMetadataResult[3].cast(to: Int64.self)
                    let formatVersionCol = fileMetadataResult[4].cast(to: Int64.self)
                    let encryptionAlgorithmCol = fileMetadataResult[5].cast(to: String.self)
                    
                    metadataLines.append("File Name: \(fileNameCol[0] ?? "Unknown")")
                    if let createdBy = createdByCol[0] {
                        metadataLines.append("Created By: \(createdBy)")
                    }
                    metadataLines.append("File Size: \(fileSize)")
                    if let numRows = numRowsCol[0] {
                        metadataLines.append("Total Rows: \(numRows)")
                    }
                    if let numRowGroups = numRowGroupsCol[0] {
                        metadataLines.append("Total Row Groups: \(numRowGroups)")
                    }
                    metadataLines.append("Total Columns: \(columnCount)")
                    if let formatVersion = formatVersionCol[0] {
                        metadataLines.append("Format Version: \(formatVersion)")
                    }
                    if let encryptionAlgorithm = encryptionAlgorithmCol[0] {
                        metadataLines.append("Encryption Algorithm: \(encryptionAlgorithm)")
                    } 
                }
            }
            
            metadataLines.append("")
            metadataLines.append("═══════════════════════════════════════════")
            metadataLines.append("KEY-VALUE METADATA")
            metadataLines.append("═══════════════════════════════════════════")
            metadataLines.append("")
            
            // Query parquet_kv_metadata function
            let kvMetadataResult = try connection.query("""
                SELECT file_name::STRING, key::STRING, value::STRING FROM (SELECT * FROM parquet_kv_metadata('\(url.path)'))
            """)
            
            if !kvMetadataResult.isEmpty && kvMetadataResult.count > 0 {
                _ = kvMetadataResult[0].cast(to: String.self) // file_name column
                let keyCol = kvMetadataResult[1].cast(to: String.self)
                let valueCol = kvMetadataResult[2].cast(to: String.self)
                
                var kvPairs: [(String, String)] = []
                
                // Iterate through all rows in the result set
                for i in 0..<keyCol.count {
                    let idx = DBInt(i)
                    if let key = keyCol[idx], let value = valueCol[idx] {
                        kvPairs.append((key, value))
                    }
                }
                
                if !kvPairs.isEmpty {
                    // Find the maximum key length for formatting
                    let maxKeyLength = kvPairs.map { $0.0.count }.max() ?? 0
                    
                    for (key, value) in kvPairs {
                        let paddedKey = key.padding(toLength: max(maxKeyLength, 20), withPad: " ", startingAt: 0)
                        metadataLines.append("\(paddedKey): \(value)")
                    }
                } else {
                    metadataLines.append("No key-value metadata found")
                }
            } else {
                metadataLines.append("No key-value metadata found")
            }
            
            await MainActor.run {
                self.metadata = metadataLines.joined(separator: "\n")
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load Parquet file: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    private func exportToCSV() {
        let savePanel = NSSavePanel()
        savePanel.title = "Export as CSV"
        savePanel.nameFieldStringValue = fileName.replacingOccurrences(of: ".parquet", with: ".csv")
        savePanel.allowedContentTypes = [UTType.commaSeparatedText]
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            var csvContent = columnNames.map { "\"\($0)\"" }.joined(separator: ",") + "\n"
            
            for row in tableRows {
                csvContent += row.values.map { "\"\($0)\"" }.joined(separator: ",") + "\n"
            }
            
            do {
                try csvContent.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                self.errorMessage = "Failed to export CSV: \(error.localizedDescription)"
            }
        }
    }
    
    private func exportSchemaToCSV() {
        let savePanel = NSSavePanel()
        savePanel.title = "Export Schema as CSV"
        savePanel.nameFieldStringValue = fileName.replacingOccurrences(of: ".parquet", with: "_schema.csv")
        savePanel.allowedContentTypes = [UTType.commaSeparatedText]
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            var csvContent = "Column Name,Data Type,Nullable\n"
            
            for row in schemaRows {
                csvContent += "\"\(row.columnName)\",\"\(row.dataType)\",\"\(row.nullable)\"\n"
            }
            
            do {
                try csvContent.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                self.errorMessage = "Failed to export schema: \(error.localizedDescription)"
            }
        }
    }
    
    private func exportSchemaToJSON() {
        let savePanel = NSSavePanel()
        savePanel.title = "Export Schema as JSON"
        savePanel.nameFieldStringValue = fileName.replacingOccurrences(of: ".parquet", with: "_schema.json")
        savePanel.allowedContentTypes = [UTType.json]
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            var jsonArray: [[String: String]] = []
            
            for row in schemaRows {
                let jsonObject: [String: String] = [
                    "column_name": row.columnName,
                    "data_type": row.dataType,
                    "nullable": row.nullable
                ]
                jsonArray.append(jsonObject)
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [.prettyPrinted, .sortedKeys])
                try jsonData.write(to: url)
            } catch {
                self.errorMessage = "Failed to export schema as JSON: \(error.localizedDescription)"
            }
        }
    }
    
    private func exportToJSON() {
        let savePanel = NSSavePanel()
        savePanel.title = "Export as JSON"
        savePanel.nameFieldStringValue = fileName.replacingOccurrences(of: ".parquet", with: ".json")
        savePanel.allowedContentTypes = [UTType.json]
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            var jsonArray: [[String: String]] = []
            
            for row in tableRows {
                var jsonObject: [String: String] = [:]
                for (index, columnName) in columnNames.enumerated() {
                    if index < row.values.count {
                        jsonObject[columnName] = row.values[index]
                    }
                }
                jsonArray.append(jsonObject)
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [.prettyPrinted, .sortedKeys])
                try jsonData.write(to: url)
            } catch {
                self.errorMessage = "Failed to export JSON: \(error.localizedDescription)"
            }
        }
    }
    
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    private func extractValueFromColumn(_ column: DuckDB.Column<Void>, at index: Int) -> String {
        let idx = DBInt(index)
        
        // Try to cast to various types and extract the value
        // The cast method doesn't return optional, so we access directly
        
        // First try String as it's most common
        let stringColumn = column.cast(to: String.self)
        if let value = stringColumn[idx] {
            return value
        }
        
        // Try Int64
        let int64Column = column.cast(to: Int64.self)
        if let value = int64Column[idx] {
            return String(value)
        }
        
        // Try Int32
        let int32Column = column.cast(to: Int32.self)
        if let value = int32Column[idx] {
            return String(value)
        }
        
        // Try Double
        let doubleColumn = column.cast(to: Double.self)
        if let value = doubleColumn[idx] {
            // Format double with reasonable precision
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return String(Int(value))
            } else {
                return String(value)
            }
        }
        
        // Try Float
        let floatColumn = column.cast(to: Float.self)
        if let value = floatColumn[idx] {
            return String(value)
        }
        
        // Try Bool
        let boolColumn = column.cast(to: Bool.self)
        if let value = boolColumn[idx] {
            return value ? "true" : "false"
        }
        
        // Try DuckDB.Date (not Foundation.Date)
        let dateColumn = column.cast(to: DuckDB.Date.self)
        if let value = dateColumn[idx] {
            // DuckDB.Date has a description property
            return String(describing: value)
        }
        
        // If all else fails, return NULL
        return "NULL"
    }
    
    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}

#Preview {
    ParquetViewerView()
        .frame(width: 800, height: 600)
}