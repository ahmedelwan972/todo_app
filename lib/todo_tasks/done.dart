
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/todo!app/cubit.dart';
import 'package:todo/todo!app/states.dart';

class  DoneTasksScreen extends StatelessWidget {
//a//aa//a
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStateCubit>(
        listener: (context , state){},
        builder: (context , state)
        {
          var tasks1 = AppCubit.get(context).tasksDone;
          if (tasks1.length ==0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu,
                    size: 100.0,
                    color: Colors.grey,),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sorry not tasks yet please add some tasks',
                  ),

                ],
              ),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context , index)=>buildTaskItem(tasks1[index], context),
              separatorBuilder: (context , index)=> Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: tasks1.length,
            );
          }
        }
    );
  }
}
