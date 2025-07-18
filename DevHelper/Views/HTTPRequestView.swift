import SwiftUI

struct HTTPRequestView: View {
    @State private var selectedMethod: HTTPMethod = .get
    @State private var urlString: String = ""
    @State private var headers: [HTTPHeader] = []
    @State private var requestBody: String = ""
    @State private var selectedBodyType: BodyType = .json
    @State private var response: HTTPResponse?
    @State private var isLoading: Bool = false
    @State private var showAuthSection: Bool = false
    @State private var authType: AuthType = .none
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var bearerToken: String = ""
    @State private var requestHistory: [HTTPRequestItem] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("HTTP Request Tool")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                // Request Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Request")
                        .font(.headline)
                    
                    // Method and URL
                    HStack {
                        Picker("Method", selection: $selectedMethod) {
                            ForEach(HTTPMethod.allCases, id: \.self) { method in
                                Text(method.rawValue)
                                    .tag(method)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                        
                        TextField("Enter URL", text: $urlString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(.body, design: .monospaced))
                        
                        Button("Send") {
                            sendRequest()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(urlString.isEmpty || isLoading)
                    }
                    
                    // Headers Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Headers")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Button("Add Header") {
                                headers.append(HTTPHeader(key: "", value: ""))
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        if headers.isEmpty {
                            Text("No headers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(headers.indices, id: \.self) { index in
                                HStack {
                                    TextField("Key", text: $headers[index].key)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    TextField("Value", text: $headers[index].value)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    Button("Remove") {
                                        headers.remove(at: index)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                    
                    // Authentication Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Authentication")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Button(showAuthSection ? "Hide" : "Show") {
                                showAuthSection.toggle()
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        if showAuthSection {
                            Picker("Auth Type", selection: $authType) {
                                ForEach(AuthType.allCases, id: \.self) { type in
                                    Text(type.title)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            switch authType {
                            case .none:
                                EmptyView()
                            case .basic:
                                HStack {
                                    TextField("Username", text: $username)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    SecureField("Password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            case .bearer:
                                TextField("Bearer Token", text: $bearerToken)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                    
                    // Body Section
                    if selectedMethod.hasBody {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Body")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Type", selection: $selectedBodyType) {
                                    ForEach(BodyType.allCases, id: \.self) { type in
                                        Text(type.title)
                                            .tag(type)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            TextEditor(text: $requestBody)
                                .font(.system(.body, design: .monospaced))
                                .border(Color.gray, width: 1)
                                .frame(height: 100)
                            
                            HStack {
                                Button("Sample JSON") {
                                    requestBody = sampleJSON
                                }
                                .buttonStyle(.borderless)
                                
                                Button("Clear") {
                                    requestBody = ""
                                }
                                .buttonStyle(.borderless)
                                
                                Spacer()
                                
                                Text("\(requestBody.count) characters")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Response Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Response")
                            .font(.headline)
                        Spacer()
                        if let response = response {
                            Text("Status: \(response.statusCode)")
                                .font(.caption)
                                .foregroundColor(response.statusCode < 300 ? .green : .red)
                        }
                    }
                    
                    if isLoading {
                        VStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Sending request...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let response = response {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                // Response Headers
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Headers:")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    ForEach(Array(response.headers.keys.sorted()), id: \.self) { key in
                                        HStack {
                                            Text(key)
                                                .fontWeight(.medium)
                                                .foregroundColor(.secondary)
                                            Text(response.headers[key] ?? "")
                                                .font(.system(.caption, design: .monospaced))
                                            Spacer()
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                // Response Body
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("Body:")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Button("Copy") {
                                            copyToClipboard(response.body)
                                        }
                                        .buttonStyle(.borderless)
                                    }
                                    
                                    Text(response.body.isEmpty ? "Empty response" : response.body)
                                        .font(.system(.caption, design: .monospaced))
                                        .textSelection(.enabled)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .frame(height: 300)
                    } else {
                        VStack {
                            Image(systemName: "network")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("Response will appear here")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            // Quick Actions
            HStack(spacing: 20) {
                Button("GET Example") {
                    setExampleGET()
                }
                .buttonStyle(.bordered)
                
                Button("POST Example") {
                    setExamplePOST()
                }
                .buttonStyle(.bordered)
                
                Button("Clear All") {
                    clearAll()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Export cURL") {
                    exportToCURL()
                }
                .buttonStyle(.bordered)
                .disabled(urlString.isEmpty)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            addCommonHeaders()
        }
    }
    
    private func sendRequest() {
        guard let url = URL(string: urlString) else {
            response = HTTPResponse(statusCode: 0, headers: [:], body: "Invalid URL")
            return
        }
        
        isLoading = true
        var request = URLRequest(url: url)
        request.httpMethod = selectedMethod.rawValue
        
        // Add headers
        for header in headers {
            if !header.key.isEmpty && !header.value.isEmpty {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        // Add authentication
        switch authType {
        case .none:
            break
        case .basic:
            if !username.isEmpty && !password.isEmpty {
                let credentials = "\(username):\(password)"
                if let data = credentials.data(using: .utf8) {
                    let base64 = data.base64EncodedString()
                    request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
                }
            }
        case .bearer:
            if !bearerToken.isEmpty {
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            }
        }
        
        // Add body
        if selectedMethod.hasBody && !requestBody.isEmpty {
            request.httpBody = requestBody.data(using: .utf8)
            
            // Set content type based on body type
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(selectedBodyType.contentType, forHTTPHeaderField: "Content-Type")
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    response = HTTPResponse(statusCode: 0, headers: [:], body: "Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    response = HTTPResponse(statusCode: 0, headers: [:], body: "Invalid response")
                    return
                }
                
                let statusCode = httpResponse.statusCode
                let headers = httpResponse.allHeaderFields.compactMap { key, value -> (String, String)? in
                    guard let keyString = key as? String else { return nil }
                    return (keyString, "\(value)")
                }.reduce(into: [String: String]()) { result, pair in
                    result[pair.0] = pair.1
                }
                let body = data != nil ? String(data: data!, encoding: .utf8) ?? "Binary data" : ""
                
                response = HTTPResponse(statusCode: statusCode, headers: headers, body: body)
                
                // Add to history
                let requestItem = HTTPRequestItem(
                    method: selectedMethod,
                    url: urlString,
                    timestamp: Date()
                )
                requestHistory.append(requestItem)
                if requestHistory.count > 10 {
                    requestHistory.removeFirst()
                }
            }
        }.resume()
    }
    
    private func setExampleGET() {
        selectedMethod = .get
        urlString = "https://jsonplaceholder.typicode.com/posts/1"
        clearHeaders()
        addCommonHeaders()
        requestBody = ""
    }
    
    private func setExamplePOST() {
        selectedMethod = .post
        urlString = "https://jsonplaceholder.typicode.com/posts"
        clearHeaders()
        addCommonHeaders()
        selectedBodyType = .json
        requestBody = """
        {
          "title": "foo",
          "body": "bar",
          "userId": 1
        }
        """
    }
    
    private func clearAll() {
        selectedMethod = .get
        urlString = ""
        clearHeaders()
        requestBody = ""
        response = nil
        authType = .none
        username = ""
        password = ""
        bearerToken = ""
    }
    
    private func clearHeaders() {
        headers.removeAll()
    }
    
    private func addCommonHeaders() {
        if headers.isEmpty {
            headers.append(HTTPHeader(key: "User-Agent", value: "DevHelper/1.0"))
            headers.append(HTTPHeader(key: "Accept", value: "application/json"))
        }
    }
    
    private func exportToCURL() {
        var curlCommand = "curl -X \(selectedMethod.rawValue) \\\n"
        curlCommand += "  '\(urlString)' \\\n"
        
        for header in headers {
            if !header.key.isEmpty && !header.value.isEmpty {
                curlCommand += "  -H '\(header.key): \(header.value)' \\\n"
            }
        }
        
        if selectedMethod.hasBody && !requestBody.isEmpty {
            curlCommand += "  -d '\(requestBody)' \\\n"
        }
        
        curlCommand = String(curlCommand.dropLast(3)) // Remove last " \\\n"
        
        copyToClipboard(curlCommand)
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
}

enum HTTPMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    
    var hasBody: Bool {
        switch self {
        case .get, .head, .options:
            return false
        case .post, .put, .patch, .delete:
            return true
        }
    }
}

enum BodyType: CaseIterable {
    case json, xml, form, text
    
    var title: String {
        switch self {
        case .json: return "JSON"
        case .xml: return "XML"
        case .form: return "Form"
        case .text: return "Text"
        }
    }
    
    var contentType: String {
        switch self {
        case .json: return "application/json"
        case .xml: return "application/xml"
        case .form: return "application/x-www-form-urlencoded"
        case .text: return "text/plain"
        }
    }
}

enum AuthType: CaseIterable {
    case none, basic, bearer
    
    var title: String {
        switch self {
        case .none: return "None"
        case .basic: return "Basic"
        case .bearer: return "Bearer"
        }
    }
}

struct HTTPHeader {
    var key: String
    var value: String
}

struct HTTPResponse {
    let statusCode: Int
    let headers: [String: String]
    let body: String
}

struct HTTPRequestItem {
    let method: HTTPMethod
    let url: String
    let timestamp: Date
}

private let sampleJSON = """
{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "active": true
}
"""

#Preview {
    HTTPRequestView()
}