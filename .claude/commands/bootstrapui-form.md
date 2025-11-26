# Generate BootstrapUI Form

Generate a SwiftUI form using BootstrapUI components for: $ARGUMENTS

## Instructions

Create a complete SwiftUI form with the following BootstrapUI components:

```swift
import SwiftUI
import BootstrapUI

struct [FormName]View: View {
    // State variables for form fields
    @State private var fieldName = ""

    @Environment(\.theme) private var theme

    var body: some View {
        BSForm {
            BSFormSection(title: "Section Title") {
                BSFormTextField(
                    label: "Field Label",
                    text: $fieldName,
                    placeholder: "Enter value...",
                    isRequired: true
                )
            }

            BSFormActions(
                primaryTitle: "Submit",
                primaryAction: submit,
                secondaryTitle: "Cancel",
                secondaryAction: cancel
            )
        }
    }

    private func submit() {
        // Handle submission
    }

    private func cancel() {
        // Handle cancel
    }
}
```

## Available Form Components

- `BSForm` - Form container with validation
- `BSFormSection(title:)` - Grouped section with header
- `BSFormTextField(label:text:placeholder:isRequired:keyboardType:)` - Text input
- `BSFormTextArea(label:text:placeholder:)` - Multi-line text
- `BSFormToggle(label:isOn:description:)` - Toggle switch
- `BSFormPicker(label:selection:options:)` - Selection picker
- `BSFormActions(primaryTitle:primaryAction:secondaryTitle:secondaryAction:)` - Action buttons
- `BSFormValidationMessage(message:type:)` - Validation feedback

## Field States

```swift
// Normal
BSTextField("Email", text: $email, placeholder: "you@example.com")

// With icon
BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")

// Error state
BSTextField("Email", text: $email, state: .error("Invalid email format"))

// Success state
BSTextField("Email", text: $email, state: .success("Email available"))

// Disabled
BSTextField("Email", text: $email, isDisabled: true)
```

## Common Form Patterns

### Login Form
```swift
BSForm {
    BSFormTextField(label: "Email", text: $email, keyboardType: .emailAddress, isRequired: true)
    BSFormTextField(label: "Password", text: $password, isSecure: true, isRequired: true)
    BSFormActions(primaryTitle: "Sign In", primaryAction: signIn)
}
```

### Registration Form
```swift
BSForm {
    BSFormSection(title: "Account") {
        BSFormTextField(label: "Email", text: $email, isRequired: true)
        BSFormTextField(label: "Password", text: $password, isSecure: true, isRequired: true)
        BSFormTextField(label: "Confirm Password", text: $confirmPassword, isSecure: true, isRequired: true)
    }
    BSFormSection(title: "Profile") {
        BSFormTextField(label: "Full Name", text: $name, isRequired: true)
        BSFormTextField(label: "Phone", text: $phone, keyboardType: .phonePad)
    }
}
```

### Settings Form
```swift
BSForm {
    BSFormSection(title: "Notifications") {
        BSFormToggle(label: "Push Notifications", isOn: $pushEnabled)
        BSFormToggle(label: "Email Updates", isOn: $emailEnabled)
    }
    BSFormSection(title: "Privacy") {
        BSFormToggle(label: "Public Profile", isOn: $isPublic)
    }
}
```

Generate the form based on the user's requirements using these patterns.
