
 🚀 Chrome_Flutter

A Flutter application using **BLoC** for state management, simulating some browser-like features and handling data flows with a clear, maintainable, and scalable project structure.

---

## 📖 Introduction
Chrome_Flutter is designed with the following goals:
- Efficient state management using **Bloc/Cubit**.
- Clear folder structure, separating UI, logic, and data.
- Easy feature expansion and long-term maintenance.

---

## 🛠 Technologies Used
- **Flutter**: Cross-platform development framework.
- **Dart**: Main programming language.
- **flutter_bloc**: State management.
- **Equatable**: Simplifies data comparison.
- **Shared Preferences**: Local data storage.
- **Permission Handler**: Device permission management.

---

## 📂 Product Structure
```plaintext
lib/
│
├── Blocs/                     # State management with Bloc/Cubit
│
├── Data/                      # Data layer
│   ├── Models/                 # Data structure definitions
│   └── Repositories/           # Handles data retrieval from API or local storage
│
├── Presentation/               # UI layer
│   ├── Screens/                 # Main app screens
│   └── Widgets/                 # Reusable widgets
│
├── Utils/                      # Utilities & global configurations
│   ├── Constants/               # Global constant values
│   ├── PermissionHandler/       # Permission management
│   └── SharedPreferences/       # Local data storage
│
└── main.dart                   # Application entry point
````

---

## ⚙️ Installation

```bash
# Clone the repository
git clone https://github.com/lntb1712/Chrome_Flutter.git

# Navigate to project folder
cd Chrome_Flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🚀 Usage

1. Open the app on a device or emulator.
2. Enter a URL to navigate to a web page.
3. Manage tabs, change settings, and store data using Shared Preferences.

---

## 📏 Code Conventions

* **File names**: snake\_case (`browser_bloc.dart`)
* **Classes/Widgets**: PascalCase (`BrowserBloc`)
* **Variables/Functions**: camelCase (`loadTabs`)
* Bloc:

  * Event: verb form (`LoadTabs`, `OpenNewTab`)
  * State: noun describing status (`TabsLoaded`, `TabError`)

---

## 🤝 Contribution

1. Fork the project.
2. Create a new branch (`git checkout -b feature/my-feature`).
3. Commit changes (`git commit -m 'Add new feature'`).
4. Push the branch (`git push origin feature/my-feature`).
5. Open a Pull Request.



