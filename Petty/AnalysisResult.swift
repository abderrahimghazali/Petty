import Foundation

struct AnalysisResult: Codable {
    let score: Int
    let category: String
    let judgment: String
    let advice: String
}

struct ExampleGrievance {
    let label: String
    let text: String
} 