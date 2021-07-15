import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/home/cubit/categoryadder_cubit.dart';

class AddDialogM extends StatelessWidget {
  const AddDialogM({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryAdderCubit(
          RepositoryProvider.of<NivedhanamRepository>(context)),
      child: AlertDialogM(),
    );
  }
}

class AlertDialogM extends StatefulWidget {
  const AlertDialogM({
    Key? key,
  }) : super(key: key);

  @override
  _AlertDialogMState createState() => _AlertDialogMState();
}

class _AlertDialogMState extends State<AlertDialogM> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text("Add Category")),
          ElevatedButton(
              onPressed: () {
                context.read<CategoryAdderCubit>().addField();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: .3, color: Colors.grey),
                  elevation: 1,
                  primary: Colors.white,
                  onPrimary: Colors.white)),
        ],
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        height: 350,
        width: 700,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: TextFormField(
                    onChanged: (text) {
                      context.read<CategoryAdderCubit>().nameChanged(text);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Category Name",
                    )),
              ),
              FieldsList(),
            ],
          ),
        ),
      ),
      actions: [CategoryAdderActions(_formKey)],
    );
  }
}

class CategoryAdderActions extends StatelessWidget {
  const CategoryAdderActions(
    this.formKey, {
    Key? key,
  }) : super(key: key);

  final formKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
              if (formKey.currentState!.validate()) {
                String result =
                    await context.read<CategoryAdderCubit>().onSubmitted();
                if (result == "Category created") {
                  Navigator.pop(context, true);
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result)));
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
    );
  }
}

class FieldsList extends StatelessWidget {
  const FieldsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CategoryAdderCubit, CategoryAdderState>(
        builder: (context, state) {
          return ListView.builder(
              itemCount: state.categoryfields.length,
              itemBuilder: (context, index) {
                return Field(key: state.categoryfields.keys.toList()[index]);
              });
        },
      ),
    );
  }
}

class Field extends StatefulWidget {
  const Field({
    Key? key,
  }) : super(key: key);

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  String dropdownValue = 'Text';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (text) {
                context
                    .read<CategoryAdderCubit>()
                    .fieldNameChaned(widget.key, text);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Field Name",
              ),
            ),
          ),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.expand_more),
          iconSize: 24,
          elevation: 16,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
              context
                  .read<CategoryAdderCubit>()
                  .dropdownChanged(widget.key, newValue);
            });
          },
          items: <String>[
            'Text',
            'Number',
            'Date',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }
}
