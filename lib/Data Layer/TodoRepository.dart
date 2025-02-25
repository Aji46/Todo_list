import 'dart:async';

import 'package:hive/hive.dart';
import 'package:todolist/Domain%20Layer/TodoEntity.dart';
import 'package:todolist/Domain%20Layer/TodoRepository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final Box<TodoEntity> todoBox;

  TodoRepositoryImpl(this.todoBox) {
    _startAutoDeletion();
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    await todoBox.put(todo.id, todo);
  }

  @override
  Future<void> removeTodo(String id) async {
    await todoBox.delete(id);
  }

  @override
@override
Stream<List<TodoEntity>> getTodos() {
  
  _deleteExpiredTodos();
  

  return Stream.periodic(const Duration(seconds: 1))
    .map((_) {
      _deleteExpiredTodos();
      return todoBox.values.toList();
    });
}

  void _startAutoDeletion() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _deleteExpiredTodos();
    });
  }

  void _deleteExpiredTodos() {
    final now = DateTime.now();
    for (var todo in todoBox.values) {
      if (todo.expiryTime.isBefore(now)) {
        todoBox.delete(todo.id);
      }
    }
  }
}
