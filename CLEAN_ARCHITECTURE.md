# Clean Architecture with Riverpod

This Flutter application demonstrates a clean architecture implementation using Riverpod for state management.

## Architecture Overview

The project follows Clean Architecture principles with clear separation of concerns across different layers:

### Core Layer (`lib/core/`)
- **Constants**: Application-wide constants and configuration
- **Error**: Centralized error handling with custom exceptions and failures
- **Network**: HTTP client setup and network connectivity checking
- **Utils**: Generic utilities like Result types
- **DI**: Dependency injection providers
- **UseCases**: Base classes for use cases

### Feature Layer (`lib/features/`)
Each feature is organized into three main layers:

#### Data Layer (`data/`)
- **Models**: Data transfer objects (DTOs) for API communication
- **Datasources**: Abstract interfaces and implementations for data sources
- **Repositories**: Repository pattern implementations

#### Domain Layer (`domain/`)
- **Entities**: Business logic objects
- **Repositories**: Abstract repository interfaces
- **UseCases**: Business logic use cases

#### Presentation Layer (`presentation/`)
- **Providers**: Riverpod providers for dependency injection and state management
- **Screens**: UI screens
- **Widgets**: Reusable UI components

## Key Features

### 1. Error Handling
- Centralized error handling with custom exceptions and failures
- User-friendly error messages
- Proper error propagation through layers

### 2. State Management
- Riverpod for dependency injection and state management
- StateNotifier for complex state management
- Provider pattern for dependency injection

### 3. Network Layer
- Dio HTTP client with interceptors
- Network connectivity checking
- Proper error handling for network requests

### 4. Data Flow
- Unidirectional data flow
- Clear separation between UI and business logic
- Repository pattern for data abstraction

## Example Feature: User Management

The User feature demonstrates the complete clean architecture implementation:

### Data Layer
- `UserModel`: JSON serializable model for API communication
- `UserRemoteDataSource`: API data source implementation
- `UserRepositoryImpl`: Repository implementation

### Domain Layer
- `User`: Business entity
- `UserRepository`: Abstract repository interface
- `GetUsers`, `GetUserById`: Use cases for business logic

### Presentation Layer
- `UserListScreen`: Screen displaying list of users
- `UserDetailScreen`: Screen displaying user details
- `UserCard`, `UserDetailContent`: Reusable UI components
- State providers for managing user data

## Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Code**
   ```bash
   dart run build_runner build
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── utils/
│   ├── di/
│   └── usecases/
├── features/
│   └── user/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── main.dart
```

## Best Practices Implemented

1. **SOLID Principles**: Single responsibility, open/closed, dependency inversion
2. **Clean Architecture**: Clear layer separation and dependency direction
3. **Testability**: Dependency injection makes testing easier
4. **Maintainability**: Clear structure and separation of concerns
5. **Scalability**: Easy to add new features following the same pattern

## Dependencies

- `flutter_riverpod`: State management and dependency injection
- `dio`: HTTP client
- `dartz`: Functional programming utilities
- `freezed`: Immutable data classes
- `json_annotation`: JSON serialization
- `logging`: Logging utilities
- `go_router`: Navigation (ready for implementation)

## Testing

The architecture is designed to be easily testable:
- Use cases can be tested independently
- Repository implementations can be mocked
- UI components can be tested with widget tests
- Integration tests can verify the complete flow

## Future Enhancements

1. Add local data source with SQLite/Hive
2. Implement caching strategies
3. Add authentication flow
4. Implement navigation with go_router
5. Add comprehensive testing
6. Add CI/CD pipeline
