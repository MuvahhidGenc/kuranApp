import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/widgets/alertdialog_widget.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/trarmp3/viewmodel/trar_mp3_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TrArListBuilderWidget extends StatefulWidget {
  SureNameModel sureNameModel;
  TrArListBuilderWidget(this.sureNameModel, {Key? key}) : super(key: key);
  @override
  _TrArListBuilderWidgetState createState() => _TrArListBuilderWidgetState();
}

class _TrArListBuilderWidgetState extends State<TrArListBuilderWidget> {
  @override
  void initState() {
    Provider.of<TrArMp3ViewModel>(context, listen: false)
        .createAudioPathControl;
    Provider.of<TrArMp3ViewModel>(context, listen: false).audioPlayerStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  var provider = Provider.of<TrArMp3ViewModel>(context);

    dynamic snipperTheme = SnippetExtanstion(context).theme;
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.sureNameModel.data?.length,
      itemBuilder: (context, int index) {
        return Card(
            child: Consumer<TrArMp3ViewModel>(builder: (context, state, child) {
          return ListTile(
            key: UniqueKey(),
            tileColor: state.playController[index] == true
                ? snipperTheme.primaryColor
                : snipperTheme.listTileTheme.tileColor,
            leading: const Icon(Icons.headphones),
            title: Text(widget.sureNameModel.data![index].name.toString()),
            trailing: Wrap(
              spacing: 12,
              children: [state.iconController(index)],
            ),
            onTap: () async {
              bool path = await FilePathManager()
                  .getFilePathControl("trar_${index + 1}.mp3");

              if (!path) {
                getDialog(
                  context: context,
                  title: "??ND??RME ??ZN??",
                  content: Text("??ndirme ????lemi Ba??at??ls??n M???"),
                  actions: [
                    TextButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      label: Text("VAZGE??"),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await state.onClickListTile(index);
                      },
                      icon: Icon(Icons.downloading),
                      label: Text("??ND??R"),
                    ),
                  ],
                );
              } else {
                await state.onClickListTile(index);
              }
            },
          );
        }));
      },
    );
  }
}
