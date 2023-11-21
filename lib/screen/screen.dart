import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_with_cubit/cubit/todo_cubit.dart';

import '../model/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController item = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ToDo List")),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            final state = BlocProvider.of<ToDoListCubit>(context).state;
            final id = state.toDoList.length + 1;
            showBottomSheet(context: context, id: id);
          }, child: Text('Add Country'),
        ),
        body:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              height: 40,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
              child: TextField(

                onChanged:(value) => BlocProvider.of<ToDoListCubit>(context).SearchList(value),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(Icons.search_rounded),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    maxWidth: 25,
                  ),
                  focusedBorder: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              ),
            Container(
              height: 300,
              width: double.maxFinite,
              margin: EdgeInsets.only(right: 20,left: 20),
              child:
                BlocBuilder<ToDoListCubit, ToDoListState>(
                  builder: (context, state) {
                    if (state is ToDoListUpdate && state.toDoList.isNotEmpty) {
                      final toDoList = state.toDoList;

                      return ListView.builder(
                        itemCount: toDoList.length,
                        itemBuilder: (context, index) {
                          final todoList = state.toDoList[index];
                          return BuilToDoList(context, todoList);
                        },
                      );
                    }
                    else {
                      return SizedBox(
                        width: double.infinity,
                        child: Text('No Country Found'),
                      );
                    }
                  },
                )
            )
          ],
        ),

                );
  }

  Widget BuilToDoList(BuildContext context, ToDoList toDoList) {
    return ListTile(
      title: Text(toDoList.item),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed:() {
                BlocProvider.of<ToDoListCubit>(context).DeleteToDoList(toDoList);
              },

              icon: Icon(Icons.delete,size: 30,color: Colors.red,)),
        IconButton(
            onPressed: () {
              item.text = toDoList.item;
              showBottomSheet(context: context,id:toDoList.id,isEdit:true);
            },
            icon: Icon(Icons.edit,size: 30,color: Colors.blue,),)
        ],
      ),
    );
  }
  void showBottomSheet({
    required BuildContext context,
    bool isEdit = false,
    required int id,
})=>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>
          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BuildTextField(controller: item,hint: "Enter Country Name"),
                Padding(padding: EdgeInsets.all(0.8),
                  child: ElevatedButton(
                     onPressed: () {
                       final todoList = ToDoList(id: id, item: item.text,);
                       if(isEdit)
                         {
                           item.text = todoList.item;
                           BlocProvider.of<ToDoListCubit>(context).UpdateToDoList(todoList);
                         }
                       else
                         {
                           BlocProvider.of<ToDoListCubit>(context).AddToDoList(todoList);
                         }
                       Navigator.pop(context);
                     }, child: Text(isEdit?'Update':'Add Country'),
                  ),
                )
              ],
            ),
          ),
      );
  static Widget BuildTextField({
    required TextEditingController controller,
    required String hint,
})=>
      Padding(
          padding: EdgeInsets.all(12.0),
      child:TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )
        ),
      )
        );

}


