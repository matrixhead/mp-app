import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam.dart';
import 'package:mpapp/login/cubit/public_cubit.dart';

class Public extends StatelessWidget {
  const Public({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(context)=> PublicCubit(
      RepositoryProvider.of<NivedhanamRepository>(context)
    ),
    child: PublicDialog(),
    );
  }
}
class PublicDialog extends StatefulWidget {
  const PublicDialog({ Key? key }) : super(key: key);

  @override
  _PublicDialogState createState() => _PublicDialogState();
}

class _PublicDialogState extends State<PublicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Track nivedhanam"),
      content: Container(
         height: 350,
        width: 700,
        child: Column(
          children:[
            
          ]
        ),
      ),
    );
  }
}