# 🔤 Reusable SwiftUI Input Components

A modern, reusable SwiftUI component for text inputs and password fields with animated border styling, real-time validation, and clean, scalable architecture.

## ✨ Features

- ✅ Reusable `TextField` / `SecureField` with title, toggle, and error support
- ✅ Built-in password validation with animated rules
- ✅ Email validation with visual feedback
- ✅ Animated border color, width, and shadow based on input validity
- ✅ Dark mode friendly and easy to extend
- ✅ Clean preview with live state

## 📸 Preview

| Email + Password Example |
|--------------------------|
| ![Preview screenshot](preview.png) |

## 📦 Components

### `ReusableInputView`

A flexible SwiftUI input component supporting secure fields and validation.

```swift
ReusableInputView(
    title: "Email",
    placeholder: "Zadajte email",
    text: $email,
    isEmail: true
)
```

#### Props

| Prop                | Type           | Description                             |
|---------------------|----------------|-----------------------------------------|
| `title`             | `String?`      | Optional label above the input          |
| `placeholder`       | `String`       | Placeholder text inside the field       |
| `text`              | `Binding<String>` | Bound text field value             |
| `isSecure`          | `Bool`         | Renders as `SecureField` if true        |
| `showToggle`        | `Bool`         | Show/hide password eye icon             |
| `isEmail`           | `Bool`         | Enables email validation styling        |
| `errorMessage`      | `String?`      | Optional error message below field      |

---

### `PasswordInputView`

Prebuilt wrapper that uses `ReusableInputView` and validates for common password rules.

```swift
PasswordInputView()
```

Includes:
- Minimum 8 characters
- At least 1 uppercase letter
- At least 1 digit
- At least 1 special character (`? = # / %`)

---

## 🧪 Live Preview

You can test it with SwiftUI Previews using:

```swift
#Preview("Reusable Input + PasswordInput") {
    StatefulPreviewWrapper("") { email in
        VStack(spacing: 20) {
            ReusableInputView(
                title: "Email",
                placeholder: "Zadajte email",
                text: email,
                isEmail: true
            )
            PasswordInputView()
        }
        .padding()
    }
}
```

---

## 🛠 Requirements

- Xcode 15+
- iOS 16+
- Swift 5.9+

---


## 📄 License

MIT — free for personal and commercial use.  
Feel free to fork, improve, and share ❤️

---

## 🙏 Credits

Built for O2 Slovakia with 💙 by Marian Kucharcik
