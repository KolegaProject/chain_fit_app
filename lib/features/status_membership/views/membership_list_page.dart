import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/membership_list_viewmodel.dart';
import '../models/membership_models.dart';
import 'membership_detail_page.dart';

class MembershipListPage extends StatefulWidget {
  const MembershipListPage({super.key});

  @override
  State<MembershipListPage> createState() => _MembershipListPageState();
}

class _MembershipListPageState extends State<MembershipListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MembershipListViewModel>(
        context,
        listen: false,
      ).fetchMembershipList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Keanggotaan Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<MembershipListViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.membershipList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum ada membership"),
                  TextButton(
                    onPressed: () => vm.fetchMembershipList(),
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                vm.fetchMembershipList(), 
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: vm.membershipList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = vm.membershipList[index];
                return _buildMembershipCard(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, Membership item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MembershipDetailPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center, color: Colors.blueAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.gymName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Status: ",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      _buildStatusBadge(item.isActive ? "Active" : "Inactive"),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String statusRaw) {
    final status = statusRaw
        .toLowerCase(); 

    Color bgColor = Colors.transparent;
    Color textColor = Colors.black87;
    FontWeight fontWeight = FontWeight.normal;
    EdgeInsets padding = EdgeInsets.zero;
    String textToShow = statusRaw; 

    if (status == 'pending') {
      bgColor = Colors.orange;
      textColor = Colors.white;
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
      fontWeight = FontWeight.bold;
    } else if (status == 'expired' || status == 'inactive') {
      bgColor = Colors.red;
      textColor = Colors.white;
      padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
      fontWeight = FontWeight.bold;
    } else {
      fontWeight = FontWeight.w500;
    }

    if (bgColor == Colors.transparent) {
      return Text(
        textToShow,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: fontWeight,
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        textToShow,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
