import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/view_all_user_controller.dart';
import '../../models/user_master.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ViewAllUsers extends StatelessWidget {
  ViewAllUsers({Key? key}) : super(key: key);

  final ViewAllUserController _controller = Get.put(ViewAllUserController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("View Users"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return CommonDataHolder(
      controller: _controller,
      widget: _dataHolderWidget,
      dataList: _controller.dataList,
    );
  }

  Widget _dataHolderWidget(List<UserMaster>? userMasterList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: userMasterList?.length ?? 0,
        itemBuilder: (context, index) {
          return _userCards(userMasterList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _userCards(UserMaster userMaster) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Card(
          elevation: DimenConstants.cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(DimenConstants.buttonCornerRadius),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(DimenConstants.contentPadding),
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.person_outline_outlined),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(height: DimenConstants.contentPadding),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CardRichText(
                            boldText: "Name : ",
                            normalText: userMaster.userName ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Email Id : ",
                            normalText: userMaster.emailId ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Contact : ",
                            normalText: userMaster.contact ?? "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
