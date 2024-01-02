import 'package:flutter/material.dart';
import 'package:trackizer/api_client.dart';

class ExpenseBottomSheet extends StatelessWidget {
  ExpenseBottomSheet({
    super.key,
  });
  final DjangoApiClient djangoApiClient = DjangoApiClient();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    '+ Add Category',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: djangoApiClient.getCategoryList(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data;
                if (data.isEmpty) {
                  return const Text(
                    "No Category",
                    style: TextStyle(color: Colors.white),
                  );
                }
                return Text(
                  "${snapshot.data}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return const Text(
                '₦000',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
              );
            }),
          ),
        ],
      ),
    );
  }
}
