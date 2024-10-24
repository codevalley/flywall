# Flywall App Rewrite Plan

## Core Principles

1. **Simplicity First**
   - Single focused purpose: chat-based entity management
   - Minimal, clean UI with emphasis on content
   - Essential features only

2. **Visual Enhancement**
   - Rich card-based entity display
   - Google search-like interface
   - Smooth transitions and animations

3. **State Management**
   - Single source of truth
   - Clear data flow
   - Predictable state updates

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── storage/
│   │   └── session_storage.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── extensions.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── chat/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── widgets/
    └── providers/
```

## Implementation Phases

### Phase 1: Foundation (Week 1)

1. **Project Setup**
   - Clean project initialization
   - Essential dependencies
   - Base theme configuration

2. **Core Authentication**
   ```dart
   class SessionManager {
     final HiveStorage storage;
     final AuthClient client;
     
     Future<bool> login(String secret);
     Future<UserInfo> register(String screenName);
     Future<void> saveSession();
     Future<bool> loadSession();
   }
   ```

3. **Basic Navigation**
   - Splash screen
   - Auth flow
   - Main chat interface

### Phase 2: Chat Interface (Week 2)

1. **Core Chat Components**
   ```dart
   class ChatState {
     final List<Message> messages;
     final Map<String, Entity> entities;
     final bool isLoading;
     final String? currentThread;
   }
   ```

2. **Message Types**
   - Text messages
   - Entity cards
   - System messages
   - Error states

3. **Input Interface**
   - Search-style input
   - Command suggestions
   - Input history

### Phase 3: Entity Management (Week 3)

1. **Entity Components**
   ```dart
   class EntityCard extends StatelessWidget {
     final Entity entity;
     final EntityType type;
     final VoidCallback onUpdate;
   }
   ```

2. **Entity Types**
   - Tasks
   - Notes
   - People
   - Topics

3. **Entity Actions**
   - Quick actions
   - Detailed view
   - Edit capabilities

### Phase 4: Real-time Features (Week 4)

1. **WebSocket Integration**
   ```dart
   class ChatService {
     final WebSocketClient wsClient;
     final ApiClient apiClient;
     
     Stream<Message> connectToChat();
     Future<void> sendMessage(String input);
   }
   ```

2. **Real-time Updates**
   - Message delivery
   - Entity updates
   - Status indicators

## Key Components

### 1. Session Management
```dart
// Simplified session storage using Hive
class SessionStorage {
  final Box<dynamic> box;
  
  Future<void> saveUserSecret(String secret);
  Future<String?> getUserSecret();
  Future<void> clearSession();
}
```

### 2. Chat Interface
```dart
class ChatPage extends ConsumerWidget {
  // Google search-like input
  final searchController = TextEditingController();
  
  // Entity card list
  final messagesList = ScrollController();
}
```

### 3. Entity Cards
```dart
class EntityCardGrid extends StatelessWidget {
  final List<Entity> entities;
  final EntityType type;
  
  // Rich card layout with actions
}
```

## State Management

### 1. Auth State
```dart
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
}
```

### 2. Chat State
```dart
class ChatState {
  final List<Message> messages;
  final String? currentThread;
  final bool isLoading;
  final Map<String, Entity> entities;
}
```

## API Integration

### 1. Network Layer
```dart
class ApiClient {
  final Dio dio;
  
  Future<Message> sendMessage(String input, String? threadId);
  Future<List<Entity>> getEntities(EntityType type);
}
```

### 2. WebSocket Layer
```dart
class WebSocketClient {
  final WebSocketChannel channel;
  
  Stream<Message> connect(String userId);
  void disconnect();
}
```

## Data Models

### 1. Message
```dart
class Message {
  final String id;
  final String content;
  final List<Entity> entities;
  final TokenUsage tokenUsage;