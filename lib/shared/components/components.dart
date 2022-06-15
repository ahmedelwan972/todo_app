import 'package:flutter/material.dart';

import '../../todo_layout/cubit.dart';


Widget defaultTextField({
  required String label,
  required TextInputType type,
  required TextEditingController controller,
  required IconData prefix,
  required FormFieldValidator validate,
  IconData? suffix,
  double radius = 0.0,
  bool obscureText = false,
  Function? suffixPressed,
  Function? onTapUp,
}) => TextFormField(
      controller: controller,
      onTap:  (){
        onTapUp!();
      } ,
      keyboardType: type,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  {
                    suffixPressed!();
                  }
                },
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      validator: validate,
    );


Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text(
                '${model['time']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive_outlined,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );


Widget noItemYet(context)
{
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        const Icon(Icons.menu,
          size: 100.0,
          color: Colors.grey,),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Sorry not tasks yet please add some tasks',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    ),
  );
}

Widget listBuilder(List<Map> tasks1){
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


