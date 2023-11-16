import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anugerah_mobile/controllers/order_controller.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final c = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.validateSelectedBranch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
