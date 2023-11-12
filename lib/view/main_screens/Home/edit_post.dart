import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view_model/home-cubit/cubit.dart';

class EditPost extends StatefulWidget {
  
  Map<String,dynamic> post;
  int index;
  
   EditPost({super.key,
     required this.post,
     required this.index,
   });

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
   final editCaptionCont = TextEditingController();

   @override
  void initState() {
     editCaptionCont.text = widget.post['text'];
    super.initState();
  }
  @override
  void dispose() {
     HomeCubit.getInstance(context).getAllPosts();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Edit your post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TFF(
                  onFieldSubmitted: (newCaption) async
                  {
                    HomeCubit.getInstance(context).editPostCaption(
                        newText: newCaption,
                        index: widget.index,
                        context: context,
                    ).then((value)
                    {
                      // Navigator.pop(context);
                    });
                  },
                  obscureText: false,
                  controller: editCaptionCont,
                  prefixIcon: const Icon(Icons.edit),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              if(widget.post['photo'] == null)
                MyText(text: ''),
              if(widget.post['photo'] != null)
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                    child: Card(child: Image.network(widget.post['photo'])),
                ),
            ],
          ),
        ),
      )
    );
  }
}
