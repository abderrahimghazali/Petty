import SwiftUI

struct PettinessMeterView: View {
    @State private var grievance: String = ""
    @State private var isLoading: Bool = false
    @State private var result: AnalysisResult?
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let localization = Localization.shared
    
    private var exampleGrievances: [ExampleGrievance] {
        [
            ExampleGrievance(label: localization.t("exampleLoudBreathing"), text: localization.t("grievanceLoudBreathing")),
            ExampleGrievance(label: localization.t("exampleDoorHolding"), text: localization.t("grievanceDoorHolding")),
            ExampleGrievance(label: localization.t("exampleFishMicrowaver"), text: localization.t("grievanceFishMicrowaver")),
            ExampleGrievance(label: localization.t("exampleWrongTP"), text: localization.t("grievanceWrongTP"))
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 8) {
                            Text(localization.t("title"))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                .multilineTextAlignment(.center)
                            
                            Text(localization.t("subtitle"))
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 40)
                        .padding(.bottom, 32)
                        
                        // Main container
                        VStack(spacing: 32) {
                            // Gauge meter
                            GaugeView(score: result?.score ?? 0, category: result?.category)
                                .padding(.top, 32)
                            
                            // Input section
                            VStack(alignment: .leading, spacing: 16) {
                                Text(localization.t("inputLabel"))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                
                                if result == nil {
                                    // Text input
                                    VStack(alignment: .leading, spacing: 12) {
                                        ZStack(alignment: .topLeading) {
                                            TextEditor(text: $grievance)
                                                .frame(minHeight: 100)
                                                .padding(12)
                                                .background(Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                                                )
                                                .focused($isTextFieldFocused)
                                                .id("textEditor")
                                            
                                            if grievance.isEmpty {
                                                Text(localization.t("inputPlaceholder"))
                                                    .foregroundColor(.gray)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 20)
                                                    .allowsHitTesting(false)
                                            }
                                        }
                                        
                                        // Keyboard dismiss button
                                        if isTextFieldFocused {
                                            HStack {
                                                Spacer()
                                                Button("Done") {
                                                    isTextFieldFocused = false
                                                }
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.orange)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.orange.opacity(0.1))
                                                .cornerRadius(8)
                                            }
                                            .transition(.move(edge: .trailing).combined(with: .opacity))
                                        }
                                        
                                        // Example buttons
                                        LazyVGrid(columns: [
                                            GridItem(.flexible()),
                                            GridItem(.flexible())
                                        ], spacing: 8) {
                                            ForEach(exampleGrievances.indices, id: \.self) { index in
                                                Button(action: {
                                                    grievance = exampleGrievances[index].text
                                                    isTextFieldFocused = false
                                                }) {
                                                    Text(exampleGrievances[index].label)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 6)
                                                        .background(Color.white)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(Color.orange, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        // Error message
                                        if showError {
                                            HStack {
                                                Image(systemName: "exclamationmark.circle")
                                                    .foregroundColor(.red)
                                                Text(errorMessage)
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        
                                        // Analyze button
                                        Button(action: analyzeGrievance) {
                                            Text(isLoading ? localization.t("analyzingButton") : localization.t("analyzeButton"))
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 16)
                                                .background(isLoading ? Color.orange.opacity(0.7) : Color.orange)
                                                .cornerRadius(8)
                                        }
                                        .disabled(isLoading)
                                        .scaleEffect(isLoading ? 1.0 : 1.0)
                                        .animation(.easeInOut(duration: 0.1), value: isLoading)
                                    }
                                } else {
                                    // Display entered grievance
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("\"\(grievance)\"")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                            .italic()
                                            .padding(16)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            // Results section
                            if let result = result {
                                VStack(spacing: 24) {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                    
                                    VStack(spacing: 24) {
                                        // Analysis
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text(localization.t("analysisTitle"))
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                            
                                            Text(result.judgment)
                                                .font(.system(size: 16))
                                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                                .padding(16)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.orange.opacity(0.1))
                                                .cornerRadius(8)
                                        }
                                        
                                        // Advice
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text(localization.t("adviceTitle"))
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                            
                                            Text(result.advice)
                                                .font(.system(size: 16))
                                                .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                                                .padding(16)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.orange.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                    
                                    // Try another button
                                    Button(action: resetForm) {
                                        Text(localization.t("tryAnotherButton"))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.orange)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.orange, lineWidth: 2)
                                            )
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 32)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
                .onTapGesture {
                    isTextFieldFocused = false
                }
                .onChange(of: isTextFieldFocused) { _, focused in
                    if focused {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            proxy.scrollTo("textEditor", anchor: .center)
                        }
                    }
                }
            }
        }
        .background(Color(red: 0.96, green: 0.75, blue: 0.45)) // #F4BE72
        .ignoresSafeArea()
    }
    
    private func analyzeGrievance() {
        isTextFieldFocused = false // Dismiss keyboard when analyzing
        
        guard !grievance.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = localization.t("errorMessage")
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        Task {
            do {
                let analysisResult = try await ClaudeAPIService.shared.analyzeGrievance(
                    grievance,
                    locale: Locale.current.identifier
                )
                
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        result = analysisResult
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = localization.t("failedAnalysis")
                    showError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func resetForm() {
        withAnimation(.easeInOut(duration: 0.3)) {
            grievance = ""
            result = nil
            showError = false
            isTextFieldFocused = false
        }
    }
}

#Preview {
    PettinessMeterView()
} 