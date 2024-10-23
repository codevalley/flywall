# Flywall Project Structure

## Core Folder Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── env_config.dart
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── websocket_client.dart
│   │   └── interceptors/
│   ├── platform/
│   │   ├── notification_service.dart
│   │   └── platform_service.dart
│   └── utils/
│       ├── date_utils.dart
│       └── string_utils.dart
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── auth_remote_datasource.dart
│   │   │   ├── sidekick_remote_datasource.dart
│   │   │   ├── topic_remote_datasource.dart
│   │   │   ├── task_remote_datasource.dart
│   │   │   ├── people_remote_datasource.dart
│   │   │   └── note_remote_datasource.dart
│   │   └── websocket/
│   │       └── sidekick_websocket_datasource.dart
│   ├── models/
│   │   ├── auth/
│   │   │   ├── user_model.dart
│   │   │   └── token_model.dart
│   │   ├── sidekick/
│   │   │   ├── conversation_model.dart
│   │   │   └── message_model.dart
│   │   ├── topic/
│   │   │   └── topic_model.dart
│   │   ├── task/
│   │   │   └── task_model.dart
│   │   ├── people/
│   │   │   └── person_model.dart
│   │   └── note/
│   │       └── note_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── sidekick_repository_impl.dart
│       ├── topic_repository_impl.dart
│       ├── task_repository_impl.dart
│       ├── people_repository_impl.dart
│       └── note_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── auth/
│   │   │   ├── user.dart
│   │   │   └── token.dart
│   │   ├── sidekick/
│   │   │   ├── conversation.dart
│   │   │   └── message.dart
│   │   ├── topic/
│   │   │   └── topic.dart
│   │   ├── task/
│   │   │   └── task.dart
│   │   ├── people/
│   │   │   └── person.dart
│   │   └── note/
│   │       └── note.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── sidekick_repository.dart
│   │   ├── topic_repository.dart
│   │   ├── task_repository.dart
│   │   ├── people_repository.dart
│   │   └── note_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── register_usecase.dart
│       │   └── login_usecase.dart
│       ├── sidekick/
│       │   ├── send_message_usecase.dart
│       │   └── get_conversation_usecase.dart
│       ├── topic/
│       │   ├── create_topic_usecase.dart
│       │   └── get_topics_usecase.dart
│       ├── task/
│       │   ├── create_task_usecase.dart
│       │   └── get_tasks_usecase.dart
│       ├── people/
│       │   ├── create_person_usecase.dart
│       │   └── get_people_usecase.dart
│       └── note/
│           ├── create_note_usecase.dart
│           └── get_notes_usecase.dart
└── presentation/  # UI layer - not detailed here
```

## Key Classes and Implementations

### Core Layer

#### API Client
```dart
class ApiClient {
  final Dio dio;
  
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  
  // Other HTTP methods...
}
```

#### WebSocket Client
```dart
class WebSocketClient {
  final WebSocketChannel channel;
  final StreamController<dynamic> _messageController;
  
  Stream<dynamic> get messages => _messageController.stream;
  
  void connect(String clientId, String token);
  void disconnect();
  void send(dynamic message);
}
```

### Domain Layer

#### Entities

```dart
class User {
  final String screenName;
  final String userSecret;
  
  const User({
    required this.screenName,
    required this.userSecret,
  });
}

class Topic {
  final String id;
  final String name;
  final String description;
  final List<String> keywords;
  final List<String> relatedPeople;
  final List<String> relatedTasks;
  
  const Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.keywords,
    required this.relatedPeople,
    required this.relatedTasks,
  });
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<String> relatedTopics;
  final List<String> assignees;
  
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.dueDate,
    required this.relatedTopics,
    required this.assignees,
  });
}

class Message {
  final String id;
  final String threadId;
  final String content;
  final List<EntityUpdate> entityUpdates;
  final TokenUsage tokenUsage;
  
  const Message({
    required this.id,
    required this.threadId,
    required this.content,
    required this.entityUpdates,
    required this.tokenUsage,
  });
}
```

#### Repository Interfaces

```dart
abstract class ISidekickRepository {
  Future<Either<Failure, Message>> sendMessage(
    String userInput,
    String? threadId,
  );
  
  Future<Either<Failure, List<Message>>> getConversation(String threadId);
  
  Stream<Message> connectToWebSocket(String clientId);
}

abstract class ITopicRepository {
  Future<Either<Failure, List<Topic>>> getTopics({
    int page = 1,
    int pageSize = 10,
  });
  
  Future<Either<Failure, Topic>> createTopic(TopicCreate topic);
  
  Future<Either<Failure, Topic>> updateTopic(String id, TopicUpdate topic);
  
  Future<Either<Failure, Unit>> deleteTopic(String id);
}

abstract class ITaskRepository {
  Future<Either<Failure, List<Task>>> getTasks({
    int page = 1,
    int pageSize = 10,
  });
  
  Future<Either<Failure, Task>> createTask(TaskCreate task);
  
  Future<Either<Failure, Task>> updateTask(String id, TaskUpdate task);
  
  Future<Either<Failure, Unit>> deleteTask(String id);
}
```

#### Use Cases

```dart
class SendMessageUseCase {
  final ISidekickRepository repository;
  
  const SendMessageUseCase(this.repository);
  
  Future<Either<Failure, Message>> execute(
    String userInput,
    String? threadId,
  ) {
    return repository.sendMessage(userInput, threadId);
  }
}

class CreateTopicUseCase {
  final ITopicRepository repository;
  
  const CreateTopicUseCase(this.repository);
  
  Future<Either<Failure, Topic>> execute(TopicCreate topic) {
    return repository.createTopic(topic);
  }
}
```

### Data Layer

#### Models

```dart
class MessageModel {
  final String id;
  final String threadId;
  final String content;
  final Map<String, int> updatedEntities;
  final TokenUsageModel tokenUsage;
  
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'],
    threadId: json['thread_id'],
    content: json['content'],
    updatedEntities: Map<String, int>.from(json['updated_entities']),
    tokenUsage: TokenUsageModel.fromJson(json['token_usage']),
  );
  
  Message toDomain() => Message(
    id: id,
    threadId: threadId,
    content: content,
    entityUpdates: updatedEntities.entries
        .map((e) => EntityUpdate(type: e.key, count: e.value))
        .toList(),
    tokenUsage: tokenUsage.toDomain(),
  );
}

class TopicModel {
  final String id;
  final String name;
  final String description;
  final List<String> keywords;
  final List<String> relatedPeople;
  final List<String> relatedTasks;
  
  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
    id: json['topic_id'],
    name: json['name'],
    description: json['description'],
    keywords: List<String>.from(json['keywords']),
    relatedPeople: List<String>.from(json['related_people']),
    relatedTasks: List<String>.from(json['related_tasks']),
  );
  
  Topic toDomain() => Topic(
    id: id,
    name: name,
    description: description,
    keywords: keywords,
    relatedPeople: relatedPeople,
    relatedTasks: relatedTasks,
  );
}
```

#### Data Sources

```dart
abstract class ISidekickRemoteDataSource {
  Future<MessageModel> sendMessage(String userInput, String? threadId);
  Future<List<MessageModel>> getConversation(String threadId);
}

class SidekickRemoteDataSource implements ISidekickRemoteDataSource {
  final ApiClient client;
  
  const SidekickRemoteDataSource(this.client);
  
  @override
  Future<MessageModel> sendMessage(String userInput, String? threadId) async {
    final response = await client.post(
      '/api/v1/sidekick/ask',
      data: {
        'user_input': userInput,
        'thread_id': threadId,
      },
    );
    
    return MessageModel.fromJson(response.data);
  }
  
  @override
  Future<List<MessageModel>> getConversation(String threadId) async {
    final response = await client.get(
      '/api/v1/sidekick/conversation/$threadId',
    );
    
    return (response.data as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }
}
```

#### Repository Implementations

```dart
class SidekickRepositoryImpl implements ISidekickRepository {
  final ISidekickRemoteDataSource remoteDataSource;
  final ISidekickWebSocketDataSource webSocketDataSource;
  
  const SidekickRepositoryImpl({
    required this.remoteDataSource,
    required this.webSocketDataSource,
  });
  
  @override
  Future<Either<Failure, Message>> sendMessage(
    String userInput,
    String? threadId,
  ) async {
    try {
      final messageModel = await remoteDataSource.sendMessage(
        userInput,
        threadId,
      );
      return Right(messageModel.toDomain());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
  
  @override
  Stream<Message> connectToWebSocket(String clientId) {
    return webSocketDataSource
        .connect(clientId)
        .map((model) => model.toDomain());
  }
}
```

This structure follows clean architecture principles and provides:
1. Clear separation of concerns
2. Type-safe data handling
3. Proper error handling
4. Easy testing capabilities
5. Scalable organization