import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/todo_layout/cubit.dart';
import 'package:todo/todo_layout/states.dart';
import 'package:todo/todo_tasks/archived.dart';
import 'package:todo/todo_tasks/done.dart';
import 'package:todo/todo_tasks/new.dart';

class TodoLayout extends StatefulWidget {


  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

class _TodoLayoutState extends State<TodoLayout> {
  /// Vars
  var scaffold = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  ///Lists

  List<BottomNavigationBarItem> bottomNavItems = const
  [
    BottomNavigationBarItem(
        icon: Icon(Icons.menu,),
        label: 'Tasks'),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline,),
        label: 'Done Tasks'),
    BottomNavigationBarItem(
        icon: Icon(Icons.archive_outlined,),
        label: 'Archived Tasks'),
  ];

  List<Widget> screen =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> title =
  [
    'New Task',
    'Done Task',
    'Archived Task',
  ];


  @override
  void dispose() {

    scaffold.currentState!.dispose();
    super.dispose();
  }

  ///Output Widget

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(

          extendBody: true,

          key: scaffold,

          appBar: appBar(cubit),

          body: screen[cubit.currentIndex],

          bottomNavigationBar: bottomNavBar(cubit),

          floatingActionButton: fab(cubit,context),

        );
      },
    );
  }

  ///Widgets

  PreferredSizeWidget appBar(AppCubit cubit)
  {
    return AppBar(
      title: Text(
        title[cubit.currentIndex],
      ),
      actions: [
        IconButton(
            onPressed: ()=>cubit.changeMode(),
            icon: const Icon(Icons.dark_mode)),
      ],
    );
  }

  Widget bottomSheetWidget(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultTextField(
              label: "Title",
              onTapUp: () {},
              type: TextInputType.text,
              controller: titleController,
              prefix: Icons.title,
              validate: (value)
              {
                if (value.isEmpty)
                {
                  return 'Title must be Empty';
                }
              },
            ),
            const SizedBox(
              height: 15.0,
            ),
            defaultTextField(
              label: "Time",
              type: TextInputType.datetime,
              controller: timeController,
              onTapUp: () {
                showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now()
                ).then((value) {
                  timeController.text = value!.format(context).toString();
                });
              },
              prefix: Icons.watch_later,
              validate: (value)
              {
                if (value.isEmpty)
                {
                  return 'Time must be Empty';
                }
              },
            ),
            const SizedBox(
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
              validate: (value)
              {
                if (value.isEmpty)
                {
                  return 'Date must be Empty';
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavBar(AppCubit cubit)
  {
    return BottomNavigationBar(
      currentIndex: cubit.currentIndex,
      onTap: (index)
      {
        cubit.changeIndex(index);
      },
      items: bottomNavItems,
    );
  }

  Widget fab(AppCubit cubit,BuildContext context)
  {
    return FloatingActionButton(
      onPressed: (){
        if (cubit.isFABShow)
        {
          if (formKey.currentState!.validate())
          {
            cubit.insertToDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text
            ).then((value) {
              titleController.text = '';
              dateController.text = '';
              timeController.text = '';
              cubit.isFABShow = false;
              cubit.fabIcon = Icons.edit;
              Navigator.pop(context);
            }).catchError((e) {
              print('$e im error');
            });
          }
        }
        else
        {
          scaffold.currentState!.showBottomSheet(
                (context) => bottomSheetWidget(context),
            elevation: 25.0,
            //transitionAnimationController: AnimationController.unbounded(vsync: )
          ).closed.then((value) {
            titleController.text = '';
            dateController.text = '';
            timeController.text = '';
            cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
          });
          cubit.changeBottomSheet(isShow: true, icon: Icons.add);
        }
      },
      child: Icon(
        cubit.fabIcon,
        size: 17.0,
      ),
    );
  }
}
