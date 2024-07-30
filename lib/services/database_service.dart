import 'dart:core';
import 'package:todo/models/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();

  // padaro kad tik sita viena grazintu jei callina constructoriu
  factory DatabaseService() {
    return _databaseService;
  }

  DatabaseService._internal();
  
  // patikrina ar yra db jei jo ji grazina jei ne sukuria db ir grazina sukurta
  static Database? _database;
  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    
    _database = await _initDatabase();
    return _database!;
  } 

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'todo_database.db');

    // sukuria database duotam pathe
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // Sukuria todo table
  Future<void> _onCreate(Database db, int version) async{
    await db.execute(
      'CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, description TEXT, creationDate DATETIME, isCompleted INTEGER)'
    );
  }

  // ideda todo i todo table
  Future<void> insertTodo(TodoModel todo) async {
    final db = await _databaseService.database;

    await db.insert('todo', todo.toMap());
  }

  // grazina visus todo
  Future<List<TodoModel>> retrieveTodos() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query('todo');

    List<TodoModel> todos = List.generate(maps.length, (index) => TodoModel.fromMap(maps[index]));

    return todos.reversed.toList();
  }

  // istrina todo pagal id
  Future<void> deleteTodo(int? id) async {
    final db = await _databaseService.database;

    db.delete('todo', where: 'id = ?', whereArgs: [id]);
  } 

  // update todo nusiunciant nauja todo objekta su tuo paciu id
  Future<void> updateTodo(TodoModel todo) async {
    final db = await _databaseService.database;

    print(todo.toMap());

    db.update('todo', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }
}