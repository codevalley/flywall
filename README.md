# Flywall

Flywall is a cross-platform client application for the Sidekick API system, designed to provide a premium, distraction-free experience for capturing and managing tasks, notes, and other structured entities.

## Features

- Simple, Google-like search interface
- Natural language processing for task/note creation
- Real-time updates via WebSocket
- Cross-platform support (iOS, Android, Windows, macOS)
- System-level integration (notifications, quick capture)

## Getting Started

### Prerequisites

- Flutter 3.x
- Dart 3.x
- [Sidekick API](link-to-api-docs) access

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/flywall.git
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the development server
   ```bash
   flutter run
   ```

### Configuration

1. Create a `.env` file in the root directory
2. Add your Sidekick API configuration:
   ```
   API_URL=your_api_url
   WS_URL=your_websocket_url
   ```

## Architecture

This project follows Clean Architecture principles:

- `lib/domain/`: Business logic and entities
- `lib/data/`: Data handling and repositories
- `lib/presentation/`: UI and state management
- `lib/core/`: Shared utilities and configurations

## Development

### Code Generation

```bash
# Run build runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.