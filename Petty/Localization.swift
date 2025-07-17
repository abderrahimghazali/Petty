import Foundation

struct Localization {
    static let shared = Localization()
    
    private let translations: [String: [String: String]] = [
        "en-US": [
            "title": "How petty are you?",
            "subtitle": "Share your grievance and let Claude be the judge",
            "inputLabel": "What's bothering you?",
            "inputPlaceholder": "My roommate ate the last slice of pizza I was saving...",
            "exampleLoudBreathing": "Loud breathing",
            "exampleDoorHolding": "Door holding",
            "exampleFishMicrowaver": "Fish microwaver",
            "exampleWrongTP": "Wrong TP",
            "grievanceLoudBreathing": "My roommate breathes too loudly",
            "grievanceDoorHolding": "Someone didn't say thank you when I held the door",
            "grievanceFishMicrowaver": "My coworker microwaves fish at lunch",
            "grievanceWrongTP": "They put the toilet paper roll on backwards",
            "errorMessage": "Please enter a grievance to analyze!",
            "analyzeButton": "Measure my pettiness!",
            "analyzingButton": "Analyzing pettiness...",
            "analysisTitle": "Analysis",
            "adviceTitle": "Advice",
            "tryAnotherButton": "Try another grievance",
            "failedAnalysis": "Failed to analyze grievance. Please try again!"
        ],
        "es-ES": [
            "title": "¿Qué tan mezquino eres?",
            "subtitle": "Comparte tu queja y deja que Claude sea el juez",
            "inputLabel": "¿Qué te molesta?",
            "inputPlaceholder": "Mi compañero de cuarto se comió la última rebanada de pizza que estaba guardando...",
            "exampleLoudBreathing": "Respiración fuerte",
            "exampleDoorHolding": "Sujetar puerta",
            "exampleFishMicrowaver": "Pescado en microondas",
            "exampleWrongTP": "Papel higiénico mal",
            "grievanceLoudBreathing": "Mi compañero de cuarto respira muy fuerte",
            "grievanceDoorHolding": "Alguien no dijo gracias cuando le sostuve la puerta",
            "grievanceFishMicrowaver": "Mi compañero de trabajo calienta pescado en el microondas en el almuerzo",
            "grievanceWrongTP": "Pusieron el rollo de papel higiénico al revés",
            "errorMessage": "¡Por favor ingresa una queja para analizar!",
            "analyzeButton": "¡Mide mi mezquindad!",
            "analyzingButton": "Analizando mezquindad...",
            "analysisTitle": "Análisis",
            "adviceTitle": "Consejo",
            "tryAnotherButton": "Probar otra queja",
            "failedAnalysis": "Error al analizar la queja. ¡Por favor intenta de nuevo!"
        ]
    ]
    
    private var currentLocale: String {
        let deviceLocale = Locale.current.identifier
        return findMatchingLocale(deviceLocale)
    }
    
    private func findMatchingLocale(_ locale: String) -> String {
        if translations[locale] != nil {
            return locale
        }
        
        let language = String(locale.prefix(2))
        let match = translations.keys.first { $0.hasPrefix(language + "-") }
        return match ?? "en-US"
    }
    
    func t(_ key: String) -> String {
        return translations[currentLocale]?[key] ?? translations["en-US"]?[key] ?? key
    }
} 