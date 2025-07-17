import Foundation

class ClaudeAPIService {
    static let shared = ClaudeAPIService()
    
    private init() {}
    
    // MARK: - API Key Configuration
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["CLAUDE_API_KEY"] as? String else {
            return ""
        }
        return key
    }
    
    func analyzeGrievance(_ grievance: String, locale: String = "en-US") async throws -> AnalysisResult {
        // Check if API key is configured
        guard !apiKey.isEmpty && apiKey != "YOUR_CLAUDE_API_KEY_HERE" else {
            // Fall back to mock data if no API key
            return try await mockAnalysis()
        }
        
        let prompt = """
        You are a humorous but fair judge of pettiness. Analyze the following grievance and rate it on a scale from 0 to 100, where:
        - 0-20: Legitimate concern (This is actually serious!)
        - 21-40: Reasonable gripe (Fair enough, that's annoying)
        - 41-60: Getting petty (Okay, but maybe chill a bit?)
        - 61-80: Pretty petty (You might want to let this one go...)
        - 81-100: Peak pettiness (Seriously? Let it go!)

        Grievance: "\(grievance)"

        Respond ONLY with a valid JSON object in this exact format:
        {
            "score": [number between 0-100],
            "category": "[one of the category names above]",
            "judgment": "[A funny but not mean 1-2 sentence judgment about their grievance]",
            "advice": "[A humorous but helpful suggestion in 1 sentence]"
        }

        DO NOT OUTPUT ANYTHING OTHER THAN VALID JSON.

        Please respond in \(locale) language
        """
        
        return try await makeClaudeAPICall(prompt)
    }
    
    // MARK: - Real API Implementation
    private func makeClaudeAPICall(_ prompt: String) async throws -> AnalysisResult {
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let requestBody = ClaudeRequest(
            model: "claude-3-sonnet-20240229",
            max_tokens: 1000,
            messages: [
                ClaudeMessage(role: "user", content: prompt)
            ]
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            // Log error for debugging
            if let errorData = try? JSONSerialization.jsonObject(with: data) {
                print("API Error: \(errorData)")
            }
            throw APIError.invalidResponse
        }
        
        let claudeResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        guard let jsonString = claudeResponse.content.first?.text else {
            throw APIError.invalidJSON
        }
        
        // Clean up the response to extract JSON
        let cleanedResponse = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let jsonData = cleanedResponse.data(using: .utf8) else {
            throw APIError.invalidJSON
        }
        
        do {
            return try JSONDecoder().decode(AnalysisResult.self, from: jsonData)
        } catch {
            print("JSON Decode Error: \(error)")
            print("Response: \(cleanedResponse)")
            throw APIError.invalidJSON
        }
    }
    
    // MARK: - Mock Implementation (fallback)
    private func mockAnalysis() async throws -> AnalysisResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let mockResponses = [
            AnalysisResult(
                score: 75,
                category: "Pretty petty",
                judgment: "This is definitely in the realm of minor annoyances that probably shouldn't ruin your day, but hey, we've all been there!",
                advice: "Maybe try some deep breathing exercises or just accept that people are wonderfully weird in their own ways."
            ),
            AnalysisResult(
                score: 45,
                category: "Getting petty",
                judgment: "Okay, this is mildly annoying but not worth losing sleep over!",
                advice: "Consider that everyone has their quirks - including you!"
            ),
            AnalysisResult(
                score: 85,
                category: "Peak pettiness",
                judgment: "Really? This is what's keeping you up at night? Come on!",
                advice: "Time to take a step back and focus on the bigger picture."
            ),
            AnalysisResult(
                score: 25,
                category: "Reasonable gripe",
                judgment: "Fair enough, that would be genuinely annoying to deal with.",
                advice: "Have a calm conversation about it - communication is key!"
            )
        ]
        
        return mockResponses.randomElement() ?? mockResponses[0]
    }
}

// MARK: - API Models
struct ClaudeRequest: Codable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeMessage]
}

struct ClaudeMessage: Codable {
    let role: String
    let content: String
}

struct ClaudeResponse: Codable {
    let content: [ClaudeContent]
}

struct ClaudeContent: Codable {
    let text: String
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidJSON
    case noAPIKey
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid API response"
        case .invalidJSON:
            return "Invalid JSON in response"
        case .noAPIKey:
            return "No API key configured"
        }
    }
} 