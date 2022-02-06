
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/todo!app/cubit.dart';
import 'package:todo/todo!app/states.dart';

class TodoLayout extends StatelessWidget {
  var scaffold = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStateCubit>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffold,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
            ),
            body: cubit.screen[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived Tasks'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isFABShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text)
                        .then((value) {
                      print('$value inserted successful');
                      titleController.text ='';
                      dateController.text ='';
                      timeController.text ='';
                      Navigator.pop(context);
                      cubit.isFABShow = false;
                      cubit.fabIcon = Icons.edit;
                    }).catchError((e) {
                      print('$e im error');
                    });
                  }
                } else {
                  scaffold.currentState!.showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                  label: "Title",
                                  onTapUp: (){},
                                  type: TextInputType.text,
                                  controller: titleController,
                                  prefix: Icons.title,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Title must be Empty';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextField(
                                  label: "Time",
                                  type: TextInputType.datetime,
                                  controller: timeController,
                                  onTapUp: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  prefix: Icons.watch_later,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Time must be Empty';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextField(
                                  label: "Date",
                                  type: TextInputType.datetime,
                                  controller: dateController,
                                  onTapUp: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2022-11-29"),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value!)
                                          .toString();
                                    });
                                  },
                                  prefix: Icons.calendar_today,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Date must be Empty';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 25.0,
                      )
                      .closed
                      .then((value) {
                    titleController.text ='';
                    dateController.text ='';
                    timeController.text ='';
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
                size: 17.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
