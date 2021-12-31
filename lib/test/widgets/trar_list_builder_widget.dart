import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/trar_mp3_viewmodel.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
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
    var provider = Provider.of<TrArMp3ViewModel>(context);

    dynamic snipperTheme = SnippetExtanstion(context).theme;
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.sureNameModel.data?.length,
      itemBuilder: (context, int index) {
        return Card(
          child: ListTile(
              key: UniqueKey(),
              tileColor: provider.playController[index] == true
                  ? snipperTheme.primaryColor
                  : snipperTheme.listTileTheme.tileColor,
              leading: const Icon(Icons.headphones),
              title: Text(widget.sureNameModel.data![index].name.toString()),
              trailing: Wrap(
                spacing: 12,
                children: [provider.iconController(index)],
              ),
              onTap: () async => await provider.onClickListTile(index)),
        );
      },
    );
  }
}