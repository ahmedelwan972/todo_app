import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/todo_layout/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  /// this Fuc for call AppCubit with context
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);


  ///Vars

  int currentIndex = 0;
  Database? db;
  bool isFABShow = false;
  bool changeTheme = false;
  IconData fabIcon = Icons.edit;
  String createDB = 'CREATE TABLE tasks1(id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT , time TEXT , date TEXT , status TEXT)';

  ///Lists

  List<Map> tasksNew = [];
  List<Map> tasksDone = [];
  List<Map> tasksArchived = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomState());
  }

   void changeMode(){
    if(changeTheme)
      {
        changeTheme = false;
        emit(ChangeModeState());
      }
    else
    {
      changeTheme = true;
      emit(ChangeModeState());
    }
  }

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    isFABShow = isShow;
    fabIcon = icon;
    emit(ChangeBottomState());
  }

  void createDatabase()
  {
    openDatabase(
        'todo1.db',
        version: 1,
        onCreate: (db, version) {
          print('database created');
          db.execute(createDB)
              .then((value) => print('Table Created'))
              .catchError((e) => print('$e = error'));
          }, onOpen: (db) {
          print('database opened');
          getDataFromDatabase(db);
        }).then((value) {
          db = value;
          emit(CreateDataBaseState());
        });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await db!.transaction((txn) async {
      txn.rawInsert(
          "INSERT INTO 'tasks1'('title' , 'time' , 'date' , 'status')VALUES('$title' , '$time' , '$date' , 'new')")
          .then((value) {
        print('inserted successful  $value');
        emit(InsertToDataBaseState());

        getDataFromDatabase(db);
      });
    });
  }

  void getDataFromDatabase(db)
  {

    tasksNew = [];
    tasksDone = [];
    tasksArchived = [];

    db!.rawQuery('SELECT * FROM tasks1').then((value)
    {

      value.forEach((element)
      {
        if(element['status'] == 'new')
        {
          tasksNew.add(element);
        }
        else if(element['status'] == 'done')
        {
          tasksDone.add(element);
        }
        else
        {
          tasksArchived.add(element);
        }
      });
      emit(GetDataBaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async
  {
    db!.rawUpdate(
        'UPDATE tasks1 SET status = ?   WHERE id = ?',
        [status, id ]).then((value)
    {
      getDataFromDatabase(db);
      emit(UpdateDataBaseState());

    });
    emit(GetDataBaseState());

  }

  void deleteDatabase({
    required int id,
  }) async{
    db!.rawDelete('DELETE FROM tasks1 WHERE id = ?',
        [id]).then((value)
    {
      getDataFromDatabase(db);
      emit(DeleteDataBaseState());

    });

  }

}
