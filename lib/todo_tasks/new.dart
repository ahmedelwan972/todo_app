
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/todo_layout/cubit.dart';
import 'package:todo/todo_layout/states.dart';

class  NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context , state){},
        builder: (context , state)
        {
          var tasks1 = AppCubit.get(context).tasksNew;
          if (tasks1.isEmpty)
          {
            return noItemYet(context);
          }
          else
          {
            return listBuilder(tasks1);
          }
        }
    );
  }
}
