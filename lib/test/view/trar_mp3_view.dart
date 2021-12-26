import 'package:flutter/material.dart';
import 'package:kuran/test/viewmodel/trar_mp3_viewmodel.dart';
import 'package:kuran/test/widgets/trar_bottom_sheet_widget.dart';
import 'package:kuran/test/widgets/trar_list_builder_widget.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';

class TrArMp3View extends StatefulWidget {
  const TrArMp3View({Key? key}) : super(key: key);

  @override
  _TrArMp3ViewState createState() => _TrArMp3ViewState();
}

class _TrArMp3ViewState extends State<TrArMp3View> {
  //var _sureNameModel = SureNameModel();
  var _trarMp3ViewModel = TrArMp3ViewModel();
  Widget? surelerListView;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsyc();
  }

  Future initAsyc() async {
    surelerListView = await _trarMp3ViewModel.getSureListWidget;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Türkçe Arapça Kuran"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: surelerListView ??
                  Center(child: CircularProgressIndicator())),
          Expanded(flex: 3, child: SizedBox())
        ],
      ),
      bottomSheet: TrArBottomSheetWidget(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child:
            FloatingActionButton(onPressed: () {}, child: Icon(Icons.download)),
      ),
    );
  }
}
