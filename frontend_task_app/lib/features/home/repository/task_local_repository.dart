import 'package:frontend_task_app/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = 'tasks';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDb();
      return _database!;
    }
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
              'ALTER TABLE $tableName ADD COLUMN isSynced INTEGER NOT NULL');
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          hexColor TEXT NOT NULL,
          uid TEXT NOT NULL,
          dueAt TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isSynced INT NOT NULL
          )
          ''');
      },
    );
  }

// store single task
  Future<void> insertTask(TaskModel task) async {
    final db = await database;

    db.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//store list of tasks
  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db
        .batch(); // instead of storing all tasks together, store them in batches
    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true); // finally commiting changes in batch
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final listOfTasks = await db.query(tableName);
    if (listOfTasks.isEmpty) {
      return [];
    }
    List<TaskModel> allTasks = [];
    for (var elmt in listOfTasks) {
      allTasks.add(TaskModel.fromMap(elmt));
    }
    return allTasks;
  }

  Future<List<TaskModel>> getUnSyncedTasks() async {
    final db = await database;
    final listOfTasks =
        await db.query(tableName, where: 'isSynced = ?', whereArgs: [0]);
    if (listOfTasks.isEmpty) {
      return [];
    }
    List<TaskModel> allTasks = [];
    for (var elmt in listOfTasks) {
      allTasks.add(TaskModel.fromMap(elmt));
    }
    return allTasks;
  }

// UPDATE THE isSynced PARAMETER OF LOCAL TASKS
  Future<void> updateIsSyncedRowValue(String id, int updatedValue) async {
    final db = await database;

    await db.update(
      tableName,
      {'isSynced': updatedValue},
      where: 'isSynced = ?',
      whereArgs: [0],
    );
  }
}
