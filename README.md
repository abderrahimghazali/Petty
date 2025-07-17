# Petty - iOS Pettiness Meter 📱

A SwiftUI iOS app that judges how petty your grievances are using Claude AI. Share your complaints and let AI be the judge of your pettiness level!

## 📸 App Preview

![Petty App Screenshot](https://i.imgur.com/aOy4ug6.png)

## ✨ Features

- **AI-Powered Analysis**: Uses Claude AI to analyze and rate your grievances on a 0-100 pettiness scale
- **Animated Gauge**: Beautiful semicircle gauge with smooth animations
- **Localization**: Supports English and Spanish with automatic locale detection
- **Example Grievances**: Quick-select buttons for common complaints
- **Keyboard Handling**: Smart keyboard dismissal and auto-scroll functionality
- **Graceful Fallback**: Works with mock data when no API key is configured

## 🎯 Pettiness Scale

- **0-20**: Legitimate concern (This is actually serious!)
- **21-40**: Reasonable gripe (Fair enough, that's annoying)
- **41-60**: Getting petty (Okay, but maybe chill a bit?)
- **61-80**: Pretty petty (You might want to let this one go...)
- **81-100**: Peak pettiness (Seriously? Let it go!)

## 🔧 Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) - Install via Homebrew: `brew install xcodegen`
- Claude API key from [Anthropic Console](https://console.anthropic.com)

### 1. Clone the Repository
```bash
git clone https://github.com/abderrahimghazali/Petty.git
cd Petty
```

### 2. Generate Xcode Project
```bash
xcodegen generate
```

### 3. Open in Xcode
```bash
open Petty.xcodeproj
```

### 4. Add Your Claude API Key

#### Method 1: Using Info.plist (Recommended)

1. **Create Info.plist file:**
   - In Xcode, right-click on the `Petty` folder in the navigator
   - Select "New File..." → "Property List"
   - Name it `Info.plist`
   - Click "Create"

2. **Add your API key:**
   - Select the newly created `Info.plist` file
   - Right-click in the editor and select "Add Row"
   - Set Key: `CLAUDE_API_KEY`
   - Set Type: `String`
   - Set Value: Your actual Claude API key (e.g., `sk-ant-api03-your-key-here`)

3. **Visual Guide:**
   ```
   Info.plist
   ├── Root (Dictionary)
   │   └── CLAUDE_API_KEY (String) = "sk-ant-api03-your-actual-key-here"
   ```

#### Method 2: Direct Key (Quick Testing)

1. Open `Petty/ClaudeAPIService.swift`
2. Find the API key configuration section
3. Uncomment and modify the direct key option:
   ```swift
   // Option 1: Add your API key directly (less secure)
   private let apiKey = "sk-ant-api03-your-actual-key-here"
   ```
4. Comment out the Info.plist option

### 5. Configure Development Team (Optional)
If you want to run on a physical device:
- Open `project.yml`
- Set your `DEVELOPMENT_TEAM` ID in the settings section
- Run `xcodegen generate` again

### 6. Build and Run
- Select your target device or simulator
- Press `Cmd + R` to build and run

## 🔒 Security Notes

- **Never commit API keys to version control**
- Add `Info.plist` to your `.gitignore` file
- The app automatically falls back to mock data if no API key is configured
- Use Info.plist method for production apps
- **Xcode project files are excluded** from git to prevent sensitive team/certificate info from being shared

## 📁 Project Structure

```
Petty/
├── project.yml                 # XcodeGen project configuration
├── PettyApp.swift              # App entry point
├── ContentView.swift           # Main view controller
├── PettinessMeterView.swift    # Main pettiness meter interface
├── GaugeView.swift            # Animated gauge component
├── ClaudeAPIService.swift     # Claude AI integration
├── AnalysisResult.swift       # Data models
├── Localization.swift         # Multi-language support
└── Assets.xcassets/           # App icons and assets
```

## 🌐 Localization

The app supports:
- **English (en-US)** - Default
- **Spanish (es-ES)** - Full translation

Language is automatically detected based on device settings.

## 🎨 Design

- **Color Scheme**: Warm orange (#F4BE72) background with orange accents
- **Typography**: System fonts with proper weight hierarchy
- **Animations**: Smooth gauge animations and transitions
- **Responsive**: Works on all iPhone sizes

## 🔧 Technical Details

- **Framework**: SwiftUI
- **Minimum iOS**: 17.0
- **API**: Claude 3 Sonnet via Anthropic API
- **Architecture**: MVVM pattern with async/await
- **Error Handling**: Comprehensive error handling with user-friendly messages

## 🚀 Future Enhancements

- [ ] iPad support
- [ ] Dark mode
- [ ] More languages
- [ ] Grievance history
- [ ] Share functionality
- [ ] Custom categories

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

If you encounter any issues:
1. Check that your API key is correctly configured
2. Verify your internet connection
3. Check the Xcode console for error messages
4. The app will use mock data if Claude API is unavailable

---

**Made with ❤️ and a bit of pettiness** 
