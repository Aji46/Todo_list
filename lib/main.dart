import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/Data%20Layer/TodoRepository.dart';
import 'package:todolist/Domain%20Layer/TodoEntity.dart';
import 'package:todolist/Presentation/TodoBloc.dart';
import 'package:todolist/presentation/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoEntityAdapter());
  await Hive.openBox<TodoEntity>('todos');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(TodoRepositoryImpl(Hive.box<TodoEntity>('todos')))
        ..add(LoadTodos()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoScreen(),
      ),
    );
  }
}
