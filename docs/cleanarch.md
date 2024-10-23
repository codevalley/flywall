# Clean Architecture Guidelines - Flywall

## Overview

This document outlines the clean architecture implementation for the Flywall project. We follow a three-layer architecture with clear separation of concerns and dependencies pointing inward.

```
lib/
├── core/
├── data/
├── domain/
└── presentation/
```

## Core Principles

1. **Dependency Rule**: Dependencies only point inward. Outer layers can depend on inner layers, but never the reverse.
2. **Abstraction**: Inner layers define interfaces, outer layers implement them.
3. **Data Flow**: Data flows from outer layers inward, is processed, and flows back out.
4. **Independence**: Business logic remains independent of UI and data sources.

## Layer Structure

### 1. Domain Layer (`lib/domain/`)

The innermost layer containing business logic and types.

```
domain/
├── entities/          # Business objects
├── repositories/      # Repository interfaces
├── usecases/         # Business logic units
└── value_objects/    # Immutable value types
```

#### Key Components:

- **Entities**: Pure Dart classes representing core business objects
  ```dart
  class Task {
    final String id;
    final String title;
    final TaskStatus status;
    final DateTime createdAt;
    
    const Task({
      required this.id,
      required this.title,
      required this.status,
      required this.createdAt,
    });
  }
  ```

- **Repository Interfaces**: Abstract classes defining data operations
  ```dart
  abstract class ITaskRepository {
    Future<Either<Failure, Task>> createTask(TaskCreate task);
    Future<Either<Failure, List<Task>>> getTasks();
    Future<Either<Failure, Task>> updateTask(Task task);
    Future<Either<Failure, Unit>> deleteTask(String id);
  }
  ```

- **Use Cases**: Single-responsibility business logic units
  ```dart
  class CreateTaskUseCase {
    final ITaskRepository repository;
    
    const CreateTaskUseCase(this.repository);
    
    Future<Either<Failure, Task>> execute(TaskCreate task) {
      return repository.createTask(task);
    }
  }
  ```

### 2. Data Layer (`lib/data/`)

Implements data operations and external integrations.

```
data/
├── datasources/      # API and local data sources
├── repositories/     # Repository implementations
└── models/          # DTOs and data models
```

#### Key Components:

- **Data Sources**: Implementations for different data sources
  ```dart
  class SidekickApiDataSource implements ITaskDataSource {
    final HttpClient client;
    
    Future<TaskModel> createTask(TaskCreateDto dto) async {
      final response = await client.post('/api/v1/sidekick/tasks', body: dto.toJson());
      return TaskModel.fromJson(response.data);
    }
  }
  ```

- **Repository Implementations**: Concrete repository classes
  ```dart
  class TaskRepository implements ITaskRepository {
    final ITaskDataSource dataSource;
    
    const TaskRepository(this.dataSource);
    
    @override
    Future<Either<Failure, Task>> createTask(TaskCreate task) async {
      try {
        final dto = TaskCreateDto.fromDomain(task);
        final model = await dataSource.createTask(dto);
        return Right(model.toDomain());
      } on Exception catch (e) {
        return Left(Failure.fromException(e));
      }
    }
  }
  ```

- **Models**: Data transfer objects and mappers
  ```dart
  class TaskModel {
    final String id;
    final String title;
    final String status;
    
    factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
    );
    
    Task toDomain() => Task(
      id: id,
      title: title,
      status: TaskStatus.fromString(status),
    );
  }
  ```

### 3. Presentation Layer (`lib/presentation/`)

Handles UI and user interaction.

```
presentation/
├── pages/           # Screen widgets
├── widgets/         # Reusable UI components
├── providers/       # State management
└── view_models/     # UI state and logic
```

#### Key Components:

- **Providers**: State management using Riverpod
  ```dart
  final taskListProvider = StateNotifierProvider<TaskListNotifier, TaskListState>((ref) {
    final repository = ref.watch(taskRepositoryProvider);
    return TaskListNotifier(repository);
  });
  ```

- **ViewModels**: UI logic and state
  ```dart
  class TaskListNotifier extends StateNotifier<TaskListState> {
    final ITaskRepository _repository;
    
    TaskListNotifier(this._repository) : super(TaskListState.initial());
    
    Future<void> loadTasks() async {
      state = state.copyWith(isLoading: true);
      final result = await _repository.getTasks();
      state = result.fold(
        (failure) => state.copyWith(error: failure, isLoading: false),
        (tasks) => state.copyWith(tasks: tasks, isLoading: false),
      );
    }
  }
  ```

- **Pages**: Screen implementations
  ```dart
  class TaskListPage extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final state = ref.watch(taskListProvider);
      
      return Scaffold(
        body: state.when(
          data: (tasks) => TaskListView(tasks: tasks),
          loading: () => const LoadingIndicator(),
          error: (error) => ErrorView(error: error),
        ),
      );
    }
  }
  ```

## Core Utilities (`lib/core/`)

Shared functionality and utilities.

```
core/
├── errors/          # Error handling
├── extensions/      # Extension methods
├── utils/          # Utility functions
└── constants/      # App constants
```

## Design Patterns

### 1. Repository Pattern
- Single source of truth for data operations
- Abstract data source implementation details
- Handle data transformations and caching

### 2. Use Case Pattern
- Encapsulate business logic
- Single responsibility principle
- Easy to test and modify

### 3. Provider Pattern (using Riverpod)
- Dependency injection
- State management
- Reactive updates

## Error Handling

```dart
sealed class Failure {
  const Failure();
  
  factory Failure.fromException(Exception e) {
    return switch (e) {
      NetworkException() => NetworkFailure(e.message),
      ValidationException() => ValidationFailure(e.errors),
      _ => UnexpectedFailure(e.toString()),
    };
  }
}
```

## Testing Strategy

1. **Domain Layer**
    - Unit tests for use cases
    - Unit tests for entities
    - Mocked repositories

2. **Data Layer**
    - Unit tests for repositories
    - Mocked data sources
    - Integration tests for API

3. **Presentation Layer**
    - Widget tests
    - Provider tests
    - Golden tests

Example test:
```dart
void main() {
  group('CreateTaskUseCase', () {
    late MockTaskRepository repository;
    late CreateTaskUseCase useCase;
    
    setUp(() {
      repository = MockTaskRepository();
      useCase = CreateTaskUseCase(repository);
    });
    
    test('should create task successfully', () async {
      // Arrange
      final task = TaskCreate(title: 'Test Task');
      when(() => repository.createTask(task))
          .thenAnswer((_) async => Right(Task(...)));
          
      // Act
      final result = await useCase.execute(task);
      
      // Assert
      expect(result.isRight(), true);
      verify(() => repository.createTask(task)).called(1);
    });
  });
}
```

## Best Practices

1. **Immutable State**
    - Use immutable objects for state
    - Implement copyWith methods
    - Use const constructors

2. **Error Handling**
    - Use Either for error handling
    - Implement specific failure types
    - Handle errors at boundaries

3. **Dependency Injection**
    - Use Riverpod for DI
    - Register dependencies at startup
    - Use interfaces for loose coupling

4. **Code Organization**
    - Feature-first organization
    - Consistent file naming
    - Clear module boundaries

## Continuous Integration

1. **Static Analysis**
   ```yaml
   analysis_options.yaml:
     include: package:very_good_analysis/analysis_options.yaml
     linter:
       rules:
         - always_use_package_imports
         - avoid_dynamic
         - prefer_const_constructors
   ```

2. **Automated Testing**
    - Run tests on PR
    - Coverage requirements
    - Static analysis checks

## Documentation

- Use dartdoc comments
- Maintain architecture decision records (ADRs)
- Document state management patterns
- Keep examples up to date

## Version Control

- Feature branching
- Conventional commits
- PR templates
- Code review guidelines

This document serves as a living guide and should be updated as the architecture evolves. All deviations should be discussed and documented.