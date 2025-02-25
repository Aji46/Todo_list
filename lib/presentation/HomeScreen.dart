import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Domain%20Layer/TodoEntity.dart';
import 'package:todolist/Presentation/TodoBloc.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do App')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: StreamBuilder<int>(
                    stream: countdownStream(todo.expiryTime),
                    builder: (context, snapshot) {
                      final secondsRemaining = snapshot.data ?? 0;
                      return Text(
                        secondsRemaining > 0
                            ? 'Expires in: ${formatDuration(secondsRemaining)}'
                            : 'Expired',
                        style: TextStyle(
                          color: secondsRemaining > 0 ? Colors.black : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(RemoveTodo(todo.id));
                    },
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add To-Do'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (in minutes)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final minutes = int.tryParse(timeController.text) ?? 0;
                final expiryTime = DateTime.now().add(Duration(minutes: minutes));

                final todo = TodoEntity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  expiryTime: expiryTime,
                );

                context.read<TodoBloc>().add(AddTodo(todo));
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Stream<int> countdownStream(DateTime expiryTime) async* {
    while (true) {
      final remainingSeconds = expiryTime.difference(DateTime.now()).inSeconds;
      if (remainingSeconds <= 0) {
        yield 0;
        break;
      }
      yield remainingSeconds;
      await Future.delayed(Duration(seconds: 1));
    }
  }
  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
