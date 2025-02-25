import 'package:todolist/Domain%20Layer/TodoEntity.dart';

abstract class TodoRepository {
  Future<void> addTodo(TodoEntity todo);
  Future<void> removeTodo(String id);
  Stream<List<TodoEntity>> getTodos();
}