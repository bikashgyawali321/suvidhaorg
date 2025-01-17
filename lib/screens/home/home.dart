import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidha/models/offered_service.dart';
import 'package:suvidha/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OfferedServiceList offeredServiceList = OfferedServiceList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
     
        title:
            Text('सुविधा', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(
              onPressed: () {
                context.push('/profile');
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 30,
              ))
        ],
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                'Who are you looking for?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Choose a service to get started.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2.4),
              itemCount: offeredServiceList.offeredService.length,
              itemBuilder: (_, index) {
                final service = offeredServiceList.offeredService[index];
                return GestureDetector(
                  // onTap: () {
                  //   context.push('/service/${service.name}');
                  // },
                  child: Card(
                    color: Color.lerp(
                      Theme.of(context).colorScheme.surfaceContainer,
                      service.name.toColor,
                      0.7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              service.imageUrl,
                              height: 56,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            service.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
