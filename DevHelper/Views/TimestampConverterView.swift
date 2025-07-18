import SwiftUI

struct TimestampConverterView: View {
    @State private var timestampInput: String = ""
    @State private var dateInput: String = ""
    @State private var convertedDate: String = ""
    @State private var convertedTimestamp: String = ""
    @State private var isLocalTime: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Timestamp Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                // Timestamp to Date
                VStack(alignment: .leading, spacing: 10) {
                    Text("Timestamp to Date")
                        .font(.headline)
                    
                    TextField("Enter timestamp", text: $timestampInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: timestampInput) { _, newValue in
                            convertTimestampToDate(newValue)
                        }
                    
                    Button("Current Timestamp") {
                        timestampInput = String(Int(Date().timeIntervalSince1970))
                    }
                    .buttonStyle(.bordered)
                    
                    ScrollView {
                        Text(convertedDate.isEmpty ? "Converted date will appear here" : convertedDate)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(height: 100)
                }
                
                // Date to Timestamp
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date to Timestamp")
                        .font(.headline)
                    
                    TextField("Enter date (YYYY-MM-DD HH:MM:SS)", text: $dateInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: dateInput) { _, newValue in
                            convertDateToTimestamp(newValue)
                        }
                    
                    Button("Current Date") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        dateInput = formatter.string(from: Date())
                    }
                    .buttonStyle(.bordered)
                    
                    ScrollView {
                        Text(convertedTimestamp.isEmpty ? "Converted timestamp will appear here" : convertedTimestamp)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(height: 100)
                }
            }
            .padding()
            
            Toggle("Use Local Time", isOn: $isLocalTime)
                .onChange(of: isLocalTime) { _, _ in
                    if !timestampInput.isEmpty {
                        convertTimestampToDate(timestampInput)
                    }
                    if !dateInput.isEmpty {
                        convertDateToTimestamp(dateInput)
                    }
                }
            
            Spacer()
        }
        .padding()
    }
    
    private func convertTimestampToDate(_ timestamp: String) {
        guard !timestamp.isEmpty else {
            convertedDate = ""
            return
        }
        
        // Auto-detect timestamp format based on length
        var timeInterval: TimeInterval = 0
        
        if let timestampInt = Int64(timestamp) {
            switch timestamp.count {
            case 10: // seconds
                timeInterval = TimeInterval(timestampInt)
            case 13: // milliseconds
                timeInterval = TimeInterval(timestampInt) / 1000
            case 16: // microseconds
                timeInterval = TimeInterval(timestampInt) / 1_000_000
            case 19: // nanoseconds
                timeInterval = TimeInterval(timestampInt) / 1_000_000_000
            default:
                convertedDate = "Invalid timestamp format"
                return
            }
        } else {
            convertedDate = "Invalid timestamp"
            return
        }
        
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        
        if isLocalTime {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        } else {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        }
        
        convertedDate = formatter.string(from: date)
    }
    
    private func convertDateToTimestamp(_ dateString: String) {
        guard !dateString.isEmpty else {
            convertedTimestamp = ""
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if isLocalTime {
            formatter.timeZone = TimeZone.current
        } else {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        
        if let date = formatter.date(from: dateString) {
            let timestamp = Int64(date.timeIntervalSince1970)
            convertedTimestamp = """
            Seconds: \(timestamp)
            Milliseconds: \(timestamp * 1000)
            Microseconds: \(timestamp * 1_000_000)
            Nanoseconds: \(timestamp * 1_000_000_000)
            """
        } else {
            convertedTimestamp = "Invalid date format. Use: YYYY-MM-DD HH:MM:SS"
        }
    }
}

#Preview {
    TimestampConverterView()
}