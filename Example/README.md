# BootstrapUI ShowCase App

A comprehensive example application demonstrating all components in the BootstrapUI library.

## Running the Example

### Option 1: Open in Xcode

1. Open `Example/ShowCaseApp` folder in Xcode
2. Create a new iOS App project with the existing files
3. Add BootstrapUI as a local package dependency
4. Build and run

### Option 2: Use Swift Package Manager

1. Navigate to the Example directory
2. Run the project using Xcode

## Project Structure

```
ShowCaseApp/
├── App/
│   ├── ShowCaseApp.swift       # App entry point
│   └── RootView.swift          # Root navigation
├── Features/
│   ├── Home/
│   │   └── HomeView.swift      # Home screen
│   └── Components/
│       ├── Atoms/              # Atom component showcases
│       ├── Molecules/          # Molecule component showcases
│       ├── Organisms/          # Organism component showcases
│       └── Templates/          # Template showcases
└── Shared/
    └── Navigation/             # Shared navigation components
```

## Features Demonstrated

### Atoms
- BSButton - All styles, sizes, and states
- BSText - Typography styles and colors
- BSTextField - Input fields and validation
- BSIcon - Icon sizes and variants
- BSToggle - Switch, checkbox, radio
- BSDivider - Divider styles
- BSBadge - Badges and status indicators
- BSAvatar - User avatars with status

### Molecules
- BSInputField - Enhanced input with validation
- BSSearchBar - Search with scopes
- BSCard - Card variants
- BSListItem - List items with actions
- BSAlert - Alerts and banners
- BSToast - Toast notifications

### Organisms
- BSForm - Complete form implementation
- BSHeader - Page and profile headers
- BSNavigation - Nav bars and tab bars
- BSModal - Modals and bottom sheets

### Templates
- BSPageTemplate - Page layouts
- BSListTemplate - List layouts
- BSDetailTemplate - Detail pages

## Screenshots

See the main README for component screenshots.
