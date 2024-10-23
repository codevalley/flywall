# Flywall Design Language Specification

## Core Principles

### 1. High Contrast Minimalism
- Absolute black (#000000) and white (#FFFFFF) as primary colors
- Stark contrasts for maximum readability
- Mode-specific inversions (light/dark) maintaining absolute values

### 2. Typography-First Design
- Emphasis on typographic hierarchy
- Mix of serif and sans-serif for distinct purposes
- Dramatic size variations for visual interest

### 3. Precision & Clarity
- 1px line weights for UI elements
- Sharp, crisp edges and corners
- No shadows or depth effects

### 4. Breathing Space
- Liberal use of whitespace
- Low-density layouts
- Strategic use of vertical rhythm

## Color System

### Primary Colors
```
Background (Dark Mode): #000000
Foreground (Dark Mode): #FFFFFF
Background (Light Mode): #FFFFFF
Foreground (Light Mode): #000000
```

### Accent Colors
```
Yellow: #FFD700
Red: #FF4545
Green: #00FF90
Blue: #0066FF
```

Usage:
- Underlines for interactive elements
- Highlights for active states
- Border accents for focus states
- Tag backgrounds (with 10% opacity)

## Typography

### Font Families
```
Headings: Blacker Display
Body: Graphik
```

### Type Scale
```
Mega Title: 144px (Blacker Display Black)
Page Title: 72px (Blacker Display Black)
Section Title: 48px (Blacker Display Semi Bold)
Subsection: 24px (Graphik Light)
Body: 16px (Graphik Regular)
Caption: 12px (Graphik Light)
Micro: 10px (Graphik Light)
```

### Font Weight Usage
```
Blacker Display:
- Black (900): Primary headings
- Semi Bold (600): Secondary headings
- Regular (400): Tertiary headings

Graphik:
- Regular (400): Body text
- Light (300): Supporting text
- Thin (200): Labels, captions
```

## Components

### Buttons
```
Default:
- 1px border radius: 24px
- Border: 1px solid currentColor
- Padding: 12px 24px
- Typography: Graphik Light, 16px
- No background fill

Active:
- Background: Foreground color
- Text: Background color
- Border: none

Hover:
- Border color: Accent color
```

### Text Inputs
```
Default:
- Border radius: 24px
- Border: 1px solid currentColor
- Height: 48px
- Padding: 0 16px
- Typography: Graphik Regular, 16px

Focus:
- Border color: Accent color
- Border width: 2px
```

### Tags/Pills
```
Default:
- Border radius: 16px
- Background: Accent color (10% opacity)
- Typography: Graphik Light, 14px
- Padding: 4px 12px
```

### Icons
```
Style:
- 1px stroke weight
- No fill
- 24x24px viewport
- Consistent corner radius: 2px
- Scaled proportionally

Common Icons:
- Arrow (→): Navigation, external links
- Close (×): Dismissal actions
- Plus (+): Add actions
- Search (⌕): Search functionality
```

### Layout Elements

#### Separators
```
Line:
- Height: 1px
- Color: currentColor (10% opacity)
- Margin: 32px 0
```

#### Spacing System
```
Base unit: 8px

Spacing scale:
- xs: 8px
- sm: 16px
- md: 24px
- lg: 32px
- xl: 48px
- 2xl: 64px
- 3xl: 96px
```

#### Grid
```
Container:
- Max width: 1200px
- Padding: 24px
- Column gap: 24px
```

## Interactive States

### Hover
```
Links:
- Accent color underline
- Transition: 0.2s ease-out

Buttons:
- Border color: Accent color
- Transition: 0.2s ease-out
```

### Focus
```
All interactive elements:
- 2px border in accent color
- No default browser outline
- High contrast focus ring for accessibility
```

### Active/Selected
```
Buttons:
- Inverted colors
- Smooth transition

Navigation:
- Accent color indicator
- Bold font weight
```

## Animation

### Transitions
```
Duration:
- Quick: 150ms
- Normal: 250ms
- Slow: 350ms

Easing:
- Default: cubic-bezier(0.4, 0, 0.2, 1)
- Enter: cubic-bezier(0, 0, 0.2, 1)
- Exit: cubic-bezier(0.4, 0, 1, 1)
```

### Motion
- Minimal and purposeful
- Focus on micro-interactions
- Smooth state transitions

## Accessibility

### Contrast Ratios
- Maintain minimum 4.5:1 for all text
- 7:1 for small text
- Test all color combinations

### Focus Indicators
- Visible focus states
- Clear tab order
- Keyboard navigation support

## Implementation Guidelines

### CSS Custom Properties
```css
:root {
  /* Colors */
  --color-background: #000000;
  --color-foreground: #FFFFFF;
  --color-accent-yellow: #FFD700;
  --color-accent-red: #FF4545;
  --color-accent-green: #00FF90;
  --color-accent-blue: #0066FF;

  /* Typography */
  --font-heading: "Blacker Display", serif;
  --font-body: "Graphik", sans-serif;

  /* Spacing */
  --space-unit: 8px;
  --space-xs: calc(var(--space-unit) * 1);
  --space-sm: calc(var(--space-unit) * 2);
  /* etc. */

  /* Border Radius */
  --radius-button: 24px;
  --radius-input: 24px;
  --radius-tag: 16px;
}
```

### Utility Classes
```css
.text-mega { font-size: 144px; ... }
.text-title { font-size: 72px; ... }
.text-section { font-size: 48px; ... }
/* etc. */

.spacing-xs { margin: var(--space-xs); }
.spacing-sm { margin: var(--space-sm); }
/* etc. */
```

## Usage Examples

### Button Implementation
```dart
ElevatedButton(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(width: 1, color: Colors.white),
      ),
    ),
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.pressed)
          ? Colors.white
          : Colors.transparent,
    ),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  child: Text('Button'),
)
```

This design language emphasizes:
1. Typography-driven hierarchy
2. High contrast minimalism
3. Precise, intentional spacing
4. Sharp, clean UI elements
5. Accessibility and usability

Would you like me to elaborate on any specific aspect or create additional documentation for particular components?