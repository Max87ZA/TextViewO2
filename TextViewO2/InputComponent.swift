import SwiftUI

// MARK: - PasswordRule

struct PasswordRule: Identifiable {
    let id = UUID()
    let message: String
    let isValid: (String) -> Bool

    init(_ message: String, _ validation: @escaping (String) -> Bool) {
        self.message = message
        self.isValid = validation
    }
}

// MARK: - Preview Wrapper

struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> AnyView) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

extension StatefulPreviewWrapper where Value == String {
    init(_ initialValue: String, content: @escaping (Binding<String>) -> some View) {
        self._value = State(initialValue: initialValue)
        self.content = { AnyView(content($0)) }
    }
}

// MARK: - ReusableInputView

struct ReusableInputView: View {
    let title: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showToggle: Bool = false
    var errorMessage: String? = nil
    var isEmail: Bool = false
    var emailErrorMessage: String? = "Neplatný email"

    var borderColor: Color = .gray
    var borderWidth: CGFloat = 1
    var borderShadowRadius: CGFloat = 0
    var borderShadowOpacity: Double = 0

    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool

    private var isEmailValid: Bool {
        guard isEmail else { return true }
        let emailRegex = #"^\S+@\S+\.\S+$"#
        return text.range(of: emailRegex, options: .regularExpression) != nil
    }

    private var effectiveBorderColor: Color {
        if isEmail {
            if text.isEmpty {
                return .gray
            } else {
                return isEmailValid ? .green : .red
            }
        } else {
            return borderColor
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }

            ZStack(alignment: .trailing) {
                inputField()
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(effectiveBorderColor, lineWidth: borderWidth)
                            .animation(.easeInOut(duration: 0.3), value: effectiveBorderColor)
                    )
                    .shadow(
                        color: effectiveBorderColor.opacity(borderShadowOpacity),
                        radius: borderShadowRadius
                    )

                if isSecure && showToggle {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                    }
                }
            }

            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }

            if isEmail && !isEmailValid && !text.isEmpty {
                Text(emailErrorMessage ?? "Neplatný email")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }
        }
    }

    @ViewBuilder
    private func inputField() -> some View {
        if isSecure && !isPasswordVisible {
            SecureField(placeholder, text: $text)
                .autocapitalization(.none)
                .focused($isFocused)
        } else {
            TextField(placeholder, text: $text)
                .keyboardType(isEmail ? .emailAddress : .default)
                .autocapitalization(.none)
                .focused($isFocused)
        }
    }
}

// MARK: - PasswordInputView

struct PasswordInputView: View {
    @State private var password = ""
    @State private var borderColor: Color = .gray
    @State private var borderWidth: CGFloat = 1
    @State private var borderShadowRadius: CGFloat = 0
    @State private var borderShadowOpacity: Double = 0

    var onValidationChanged: ((Bool) -> Void)? = nil

    private var rules: [PasswordRule] = [
        PasswordRule("Minimálne 8 znakov") { $0.count >= 8 },
        PasswordRule("Aspoň jedno veľké písmeno") { $0.range(of: "[A-Z]", options: .regularExpression) != nil },
        PasswordRule("Aspoň jedno číslo") { $0.range(of: "\\d", options: .regularExpression) != nil },
        PasswordRule("Aspoň jeden špeciálny znak (? = # / %)") { $0.range(of: "[\\?=\\#/%]", options: .regularExpression) != nil }
    ]

    private var isPasswordValid: Bool {
        rules.allSatisfy { $0.isValid(password) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ReusableInputView(
                title: "Heslo",
                placeholder: "Zadajte heslo",
                text: $password,
                isSecure: true,
                showToggle: true,
                borderColor: borderColor,
                borderWidth: borderWidth,
                borderShadowRadius: borderShadowRadius,
                borderShadowOpacity: borderShadowOpacity
            )

            VStack(alignment: .leading, spacing: 6) {
                ForEach(rules) { rule in
                    let valid = rule.isValid(password)
                    HStack {
                        Image(systemName: valid ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(valid ? .green : .gray)
                            .animation(.easeInOut(duration: 0.2), value: valid)

                        Text(rule.message)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                    }
                    .animation(.easeInOut(duration: 0.2), value: password)
                }
            }
        }
        .padding()
        .onChange(of: password) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                let valid = isPasswordValid
                borderColor = password.isEmpty ? .gray : (valid ? .green : .red)
                borderWidth = valid ? 2 : 1
                borderShadowRadius = valid ? 6 : 0
                borderShadowOpacity = valid ? 0.3 : 0
                onValidationChanged?(valid)
            }
        }
    }
}

// MARK: - Preview

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
