import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/information_Model.dart';
import 'package:wesafe/models/user_Model.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/mainlist.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

class Myservice extends StatefulWidget {
  final UserModel user_model;
  Myservice({@required this.user_model});

  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  InformationModel informationModel;
  UserModel userModel;
  List<String> listOwner ;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user_model;
    listOwner = userModel.ownerID;

  }
  
  List<Widget> widgets = [];
  int index = 0;
  List<String> titles = MyConstant.listMenu;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildMenuNewJob(context),
                buildMenuCheckStatus(context),
              ],
            ),
            buildSignOut(),
          ],
        ),
      ),
      body: buildMultiOwner(),
    );
  }

  Widget buildMultiOwner() {
    return Padding(
      padding: const EdgeInsets.only(top:150),
      child: Align(
        
        alignment: Alignment.center,
            child: Scaffold(
          body: ListView.builder(
            itemCount: listOwner.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  index == 0 ? Authen() : MainList(user_model: userModel,),
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
                    child: ShowTitle(title: listOwner[index], index: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
   
  }

  ListTile buildMenuNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: 'บันทึกงานใหม่',
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

  ListTile buildMenuCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: 'ตรวจสอบและปิดงาน',
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
      accountName: userModel == null
          ? Text('Name')
          : Text('${userModel.fIRSTNAME}  ${userModel.lASTNAME}'),
      accountEmail: userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${userModel.dEPTNAME}'),
    );
  }




} //class
