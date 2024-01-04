import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/api_client.dart';
import 'package:trackizer/controllers/dropdown_controller.dart';
import 'package:trackizer/widgets/custom_alert_dialog.dart';

class CategoryBottomSheet extends StatefulWidget {
  CategoryBottomSheet({
    super.key,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final DjangoApiClient djangoApiClient = DjangoApiClient();
  final TextEditingController _catNameController = TextEditingController();
  final DropdownController controller = Get.put(DropdownController());
  late Future _catlistfuture;
  @override
  void initState() {
    super.initState();
    _catlistfuture = djangoApiClient.getCategoryList();
  }

  Future _refresh() async {
    // Make a new request when the refresh is triggered
    setState(() {
      _catlistfuture = djangoApiClient.getCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 35,
              ),
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          hintText: "Add Category",
                          controller: _catNameController,
                          onSave: () {
                            djangoApiClient.createCategory(
                              _catNameController.text,
                            );
                            _catNameController.clear();
                            _refresh();
                            Navigator.of(context).pop();
                          },
                          onCancel: Navigator.of(context).pop,
                        );
                      });
                },
                child: Container(
                  width: 35,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                      child: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _catlistfuture,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        "You have no categories. Please create one 🙏",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          controller.updateSelectedValue(
                            name: "${data[index]['name']}",
                            id: data[index]['id'],
                          );
                          Get.back();
                        },
                        contentPadding:
                            const EdgeInsets.all(0).copyWith(left: 10),
                        leading: Text(
                          "${index + 1}.",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        title: Text(
                          "${data[index]['name']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            djangoApiClient.deleteCategory(data[index]['id']);
                            _refresh();
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Text(
                  'null',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
