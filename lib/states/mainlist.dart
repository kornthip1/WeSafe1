import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/information_Model.dart';
import 'package:wesafe/models/user_Model.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/myservice.dart';
import 'package:wesafe/states/workRecord.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

class MainList extends StatefulWidget {
  final UserModel user_model;
  MainList({@required this.user_model});
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  InformationModel informationModel;
  UserModel userModel;
  int index = 0;
  List<String> titles = MyConstant.listMenu;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user_model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowTitle(title: 'MAIN LIST', index: 1),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildNewJob(context),
                buildCheckStatus(context),
              ],
            ),
            buildSignOut()
          ],
        ),
      ),
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkRecord(
              indexWork: index,
            ),
          ),
        ),
        child: Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: ListTile(
                  leading: Icon(
                    index == 0
                        ? Icons.camera_alt_outlined
                        : index == 1
                            ? Icons.offline_bolt_outlined
                            : index == 2
                                ? Icons.fence_outlined
                                : Icons.check_circle_outline,
                    size: 36,
                    color: MyConstant.primart,
                  ),
                  title: Text('$index  :   WORK'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[0],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title:  MyConstant.listMenu[1],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red[900],
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign out',
            index: 3,
          ),
        ),
      ],
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primart),
      currentAccountPicture: ShowMan(),
      accountName: informationModel == null
          ? Text('Name')
          : Text('${informationModel.fIRSTNAME}  ${informationModel.lASTNAME}'),
      accountEmail: informationModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${informationModel.dEPTNAME}'),
    );
  }

  ListView buildChecklist() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => index == 0 ? Authen() : MainList(user_model: userModel,),
          ),
        ),
        child: Card(
          color: index == 0
              ? Colors.orange[900]
              : index == 1
                  ? Colors.yellow[700]
                  : index == 2
                      ? Colors.teal[600]
                      : index == 3
                          ? Colors.blueGrey
                          : Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ShowTitle(title: '$index  : Work  ', index: 1),
            ),
          ),
        ),
      ),
    );
  }
}
