import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Data%20Layer/TodoRepository.dart';
import 'package:todolist/Domain%20Layer/TodoEntity.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepositoryImpl repository;
  StreamSubscription<List<TodoEntity>>? _todoSubscription;

  TodoBloc(this.repository) : super(TodoLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<RemoveTodo>(_onRemoveTodo);
  }

void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
  emit(TodoLoading());
  await emit.onEach<List<TodoEntity>>(
    repository.getTodos(),
    onData: (todos) => emit(TodoLoaded(todos)),
  );
}

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    await repository.addTodo(event.todo);
  }

  void _onRemoveTodo(RemoveTodo event, Emitter<TodoState> emit) async {
    await repository.removeTodo(event.id);
  }

  @override
  Future<void> close() {
    _todoSubscription?.cancel();
    return super.close();
  }
}


// Events
abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoEntity todo;
  AddTodo(this.todo);
}

class RemoveTodo extends TodoEvent {
  final String id;
  RemoveTodo(this.id);
}

class LoadTodos extends TodoEvent {}

// States
abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  TodoLoaded(this.todos);
}
