import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/category_model.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/home/cubit/categoryeditor_cubit.dart';

class CategoryEditor extends StatelessWidget {
  const CategoryEditor(this.category,{ Key? key }) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CategoryEditorCubit(RepositoryProvider.of<NivedhanamRepository>(context)),
    child: CategoryEditorDialogueW(category),
    );
  }
}

class CategoryEditorDialogueW extends StatefulWidget {
  const CategoryEditorDialogueW(this.category, { Key? key }) : super(key: key);
  final Category category;

  @override
  _CategoryEditorDialogueWState createState() => _CategoryEditorDialogueWState();
}

class _CategoryEditorDialogueWState extends State<CategoryEditorDialogueW> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController controller;

  @override
  void initState() {
   controller = TextEditingController();
   controller.text = widget.category.categoryName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CategoryEditorCubit(RepositoryProvider.of<NivedhanamRepository>(context)),
    child: AlertDialog(
      title: Text("Edit "+widget.category.categoryName),
      content: Container(width: 550,height: 120,
      child: Form(
        key: _formKey,
        child: TextFormField(
                controller: controller ,
                
                onChanged: (text) {
                  
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "category Name",
                ),
              ),
      ),
      ),
      actions: [
        Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, ),
                child: ElevatedButton(
                    onPressed: () async{
                     final result = await showDialog(
                          context: context, builder: _confirmDialog);
                      if (result == true) {
                       final response = await context.read<CategoryEditorCubit>().deleteCategory(widget.category.categoryId);
                       if (response==3){
                         Navigator.pop(context, false);
                         ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Category must be empty')),
                );
                       } else if(response==1){
                          Navigator.pop(context, false);
                         ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('error deleting category')),
                );
                       }else if(response==0){
                           Navigator.pop(context, true);
                         ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('category deleted sucessfully')),
                );
                       }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.delete_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Delete Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(width: .3, color: Colors.grey),
                        elevation: 1,
                        primary: Colors.white,
                        onPrimary: Colors.white)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(width: .3, color: Colors.grey),
                elevation: 1,
                primary: Colors.white,
                onPrimary: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
            final response = await context.read<CategoryEditorCubit>().updateCategory(controller.text,widget.category);
            if (response==0){
              Navigator.pop(context, true);
            }else{
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('error occured')));

            }
            
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("save",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: .3, color: Colors.grey),
              elevation: 1,
              onPrimary: Colors.grey,
              primary: Colors.black,
            ),
          ),
        ),
      ],
    )
      ]
    ),
    );
  }
   Widget _confirmDialog(BuildContext context) {
    return ConfirmDialog();
  }
}
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("are you sure ?"),
      actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(width: .3, color: Colors.grey),
                elevation: 1,
                primary: Colors.white,
                onPrimary: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("confirm",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: .3, color: Colors.grey),
              elevation: 1,
              onPrimary: Colors.grey,
              primary: Colors.black,
            ),
          ),
        ),],);
  }
}

