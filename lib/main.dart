import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/bloc_observer.dart';
import 'package:todo/shared/styles/styles.dart';
import 'package:todo/todo_layout/cubit.dart';
import 'package:todo/todo_layout/states.dart';
import 'package:todo/todo_layout/todolayout.dart';

void main() {

  BlocOverrides.runZoned(
        () {
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: AppCubit.get(context).changeTheme ?darkTheme:lightTheme,
            home:  TodoLayout(),
          );
        },
      ),
    );
  }
}

