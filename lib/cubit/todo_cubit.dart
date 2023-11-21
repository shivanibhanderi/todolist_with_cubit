import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';

import '../model/todo_list.dart';

class ToDoListCubit extends Cubit<ToDoListState>{
  ToDoListCubit():super(ToDoListInitial(toDoList: []));

  void AddToDoList(ToDoList toDoList)
  {
     state.toDoList.add(toDoList);
     emit(ToDoListUpdate(toDoList: state.toDoList));
  }

  void DeleteToDoList(ToDoList toDoList)
  {
   state.toDoList.remove(toDoList);
    emit(ToDoListUpdate(toDoList: state.toDoList));
  }

  void UpdateToDoList(ToDoList toDoList)
  {
    for(int i=0;i<state.toDoList.length;i++)
      {
        if(toDoList.id == state.toDoList[i].id)
          {
            state.toDoList[i] = toDoList;
          }
      }
    emit(ToDoListUpdate(toDoList: state.toDoList));
  }

  void SearchList(String enterkeyword)
  {
    List<ToDoList> result = [];
    if(enterkeyword.isEmpty)
      {
        result = state.toDoList;
      }
    else
      {
        result = state.toDoList.where((list) => list.item!.toLowerCase().contains(enterkeyword.toLowerCase())).toList();
      }

    emit(ToDoListUpdate(toDoList: result));
  }
  // void SearchToDoList(ToDoList toDoList)
  // {
  //   state.toDoList.where((ToDoList) => ToDoList.item!.toLowerCase().contains(toDoList.item.toLowerCase())).toList();
  //   emit(ToDoListUpdate(toDoList: state.toDoList));
  // }
}


// state
abstract class ToDoListState {
  List<ToDoList> toDoList;

  ToDoListState(this.toDoList);
}

class ToDoListInitial extends ToDoListState{
  ToDoListInitial({required List<ToDoList> toDoList}):super(toDoList);
}

class ToDoListUpdate extends ToDoListState{
  ToDoListUpdate({required List<ToDoList> toDoList}):super(toDoList);
}