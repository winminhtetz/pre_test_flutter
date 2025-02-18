import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_test_flutter/src/common_widgets/error_page.dart';
import 'package:pre_test_flutter/src/common_widgets/loading_page.dart';
import 'package:pre_test_flutter/src/features/authentication/data/auth_service.dart';
import 'package:pre_test_flutter/src/features/pick_up/data/pickup_service.dart';

class PickUpPage extends ConsumerStatefulWidget {
  const PickUpPage({super.key});

  @override
  ConsumerState<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends ConsumerState<PickUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(1);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authServiceProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontSize: 12),
          tabs: [
            Tab(text: 'Pickup on way'),
            Tab(text: 'Pickup Completed'),
            Tab(text: 'Pickup cancel'),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Text('Pickup Completed'),
          ),
          PickUpComponent(),
          Center(
            child: Text('Pickup Cancel'),
          ),
        ],
      ),
    );
  }
}

class PickUpComponent extends ConsumerStatefulWidget {
  const PickUpComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickUpComponentState();
}

class _PickUpComponentState extends ConsumerState<PickUpComponent> {
  final _scrollController = ScrollController();
  int _currentIndex = 0;

  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _currentIndex++;
            _isFetching = true;
          });
          await ref
              .read(pickupServiceProvider.notifier)
              .getMorePickups(page: _currentIndex);
          setState(() {
            _isFetching = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(pickupServiceProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(pickupServiceProvider),
      child: service.when(
          data: (data) {
            final items = data ?? [];

            if (items.isEmpty) {
              return Center(
                child: Text('No Data!'),
              );
            }

            return ListView.builder(
              itemCount: _isFetching ? items.length + 1 : items.length,
              shrinkWrap: true,
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final item = items[index];
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.trackingId,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(item.osName)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.osTownshipName),
                              Text(item.osPrimaryPhone)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item.pickupDate),
                              Text(
                                '${item.totalWays} ways',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${index + 1} of ${items.length}')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          error: (error, st) {
            return ErrorPage(
              errorMessage: error.toString(),
            );
          },
          loading: () => LoadingPage()),
    );
  }
}
