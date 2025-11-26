# BootstrapUI ShowCase App

A comprehensive example application demonstrating all components in the BootstrapUI library.

## Requirements

- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+

## Setup Instructions

### Step 1: Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Select "iOS" → "App"
4. Product Name: `ShowCaseApp`
5. Interface: SwiftUI
6. Language: Swift
7. Choose a location to save

### Step 2: Add BootstrapUI Package

1. In Xcode, go to File → Add Package Dependencies
2. Click "Add Local..."
3. Navigate to the root `ios-bootstrap-view` folder (where Package.swift is located)
4. Click "Add Package"
5. Make sure "BootstrapUI" is selected and click "Add Package"

### Step 3: Copy Source Files

Copy the contents of `ShowCaseApp/` folder into your Xcode project:

1. Delete the default `ContentView.swift` and `ShowCaseAppApp.swift` files
2. Drag and drop the following folders into your Xcode project:
   - `ShowCaseApp/App/`
   - `ShowCaseApp/Features/`

### Step 4: Build and Run

1. Select an iOS Simulator (iPhone 15 Pro recommended)
2. Press Cmd+R to build and run

## Project Structure

```
ShowCaseApp/
├── App/
│   ├── ShowCaseApp.swift       # App entry point with @main
│   └── RootView.swift          # Root tab navigation
└── Features/
    ├── Home/
    │   └── HomeView.swift      # Home screen with overview
    └── Components/
        ├── Atoms/
        │   └── AtomsShowcaseView.swift
        ├── Molecules/
        │   └── MoleculesShowcaseView.swift
        ├── Organisms/
        │   └── OrganismsShowcaseView.swift
        └── Templates/
            └── TemplatesShowcaseView.swift
```

## Features Demonstrated

### Atoms (8 components)
| Component | Features |
|-----------|----------|
| BSButton | All styles (primary, secondary, outline, ghost, destructive, success, link), sizes, loading states, icons |
| BSText | Typography styles, colors, weights, labels with icons |
| BSTextField | Outlined/filled/underlined styles, validation states, secure input, text areas |
| BSIcon | All sizes, colors, circular icons, icons with badges |
| BSToggle | Switch, checkbox, radio, toggle groups |
| BSDivider | Solid/dashed/dotted styles, text dividers, inset dividers |
| BSBadge | Variants, colors, sizes, dot badges, count badges, status badges |
| BSAvatar | Sizes, shapes, status indicators, avatar groups |

### Molecules (6 components)
| Component | Features |
|-----------|----------|
| BSInputField | Validation, character count, clear button |
| BSSearchBar | Search with scopes and suggestions |
| BSCard | Elevated/outlined/filled variants, image cards, action cards |
| BSListItem | Leading icons/images, trailing content, toggle list items |
| BSAlert | Info/success/warning/error types, dismissible, actions |
| BSToast | Toast notifications with manager |

### Organisms (4 components)
| Component | Features |
|-----------|----------|
| BSForm | Form sections, text fields, toggles, pickers, date pickers, steppers |
| BSHeader | Page headers, profile headers |
| BSNavigation | Navigation bars, tab bars (standard/floating/minimal) |
| BSModal | Modals, alert dialogs, confirmation dialogs, bottom sheets |

### Templates (3 components)
| Component | Features |
|-----------|----------|
| BSPageTemplate | Basic pages, stateful pages with loading/error/empty states |
| BSListTemplate | Standard lists, sectioned lists with pull-to-refresh |
| BSDetailTemplate | Detail pages with hero image and actions |

## Screenshots

After building and running the app, you can capture screenshots for each component showcase. See the main README for placeholder locations.

## Troubleshooting

### "Cannot find 'BootstrapUI' in scope"
- Make sure you added the BootstrapUI package correctly
- Try cleaning the build folder: Product → Clean Build Folder (Cmd+Shift+K)
- Rebuild the project

### "No such module 'BootstrapUI'"
- Close and reopen Xcode
- Ensure the package was added successfully in Package Dependencies

### Build errors in showcase files
- Make sure all files from `ShowCaseApp/` are properly added to the Xcode project
- Verify the target membership for each file includes your app target
