import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/models/pagination/list_model.dart';
import 'package:suvidhaorg/models/review_rating_array_response.dart';
import 'package:suvidhaorg/providers/organization_provider.dart';
import 'package:suvidhaorg/screens/reviews&ratings/review_ratings_detail_bottom_sheet.dart';
import 'package:suvidhaorg/widgets/loading_screen.dart';

import '../../services/backend_service.dart';

class ReviewRatingProvider extends ChangeNotifier {
  List<DocsReviewRating> reviewRatings = [];
  bool loading = false;
  bool hasMore = true;
  bool loadingMore = false;
  String searchTerm = '';

  final BuildContext context;
  late BackendService _backendService;
  late OrganizationProvider organizationProvider;

  ListingSchema? listingSchema;

  ReviewRatingProvider(this.context) {
    initialize();
  }
  void initialize() {
    _backendService = Provider.of<BackendService>(context, listen: false);
    organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    listingSchema = ListingSchema(
      page: 1,
      limit: 50,
      orgs: organizationProvider.organization?.id,
    );

    fetchAllReviewRatings();
  }

  Future<void> fetchAllReviewRatings({bool reset = false}) async {
    if (reset) {
      listingSchema!.page = 1;
      reviewRatings.clear();
      hasMore = true;
      notifyListeners();
    }

    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 3));

    final response =
        await _backendService.getAllReviewsAndRatingsForOrganization(
          
      schema: listingSchema!,
    );

    if (response.result != null &&
        response.statusCode == 200 &&
        response.errorMessage == null) {
      ReviewRatingArrayResponse reviewRatingArrayResponse =
          ReviewRatingArrayResponse.fromJson(response.result);
      List<DocsReviewRating> fetchedReviewRating =
          reviewRatingArrayResponse.docs.isNotEmpty
              ? reviewRatingArrayResponse.docs
              : [];

      if (fetchedReviewRating.isEmpty ||
          fetchedReviewRating.length < listingSchema!.limit) {
        hasMore = false;
      }

      reviewRatings.addAll(fetchedReviewRating);
    } else {
      hasMore = false;
    }

    loading = false;
    notifyListeners();
  }

  void fetchMoreReviewRatings() async {
    if (loadingMore || !hasMore) return;

    loadingMore = true;
    listingSchema!.page += 1;
    notifyListeners();

    await fetchAllReviewRatings();

    loadingMore = false;
    notifyListeners();
  }

  void updateSearchTerm(String term) {
    searchTerm = term;
    notifyListeners();
  }

  List<DocsReviewRating> get filteredReviewRatings {
    List<DocsReviewRating> filtered = reviewRatings;

    if (searchTerm.isNotEmpty) {
      filtered = reviewRatings.where((element) {
        return element.serviceName.name
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element.user.name.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    }

    filtered.sort((a, b) {
      return a.createdAt.compareTo(b.createdAt);
    });

    return filtered;
  }
}

class ReviewRatingScreen extends StatelessWidget {
  const ReviewRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewRatingProvider(context),
      builder: (context, child) => Consumer<ReviewRatingProvider>(
          builder: (context, provider, child) => Scaffold(
                appBar: AppBar(
                  title: Text('Reviews & Ratings'),
                ),
                body: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        provider.fetchAllReviewRatings(reset: true),
                    child: Stack(
                      children: [
                        if (provider.loading)
                          const Center(child: LoadingScreen())
                        else if (provider.filteredReviewRatings.isEmpty)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.star_border,
                                  size: 80,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No reviews and ratings found!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Looks like there are no reviews and ratings available.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          )
                        else
                          NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent &&
                                  provider.hasMore) {
                                provider.fetchMoreReviewRatings();
                              }
                              return false;
                            },
                            child: RefreshIndicator(
                              onRefresh: () => provider.fetchAllReviewRatings(
                                reset: true,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 35),
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 20,
                                  ),
                                  itemCount:
                                      provider.filteredReviewRatings.length +
                                          (provider.hasMore ? 1 : 0) +
                                          1,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        provider.filteredReviewRatings.length) {
                                      return const SizedBox(
                                        height: 70,
                                      );
                                    } else if (index ==
                                        provider.filteredReviewRatings.length +
                                            1) {
                                      return const SizedBox(
                                        height: 100,
                                      );
                                    }
                                    final reviewRatings =
                                        provider.filteredReviewRatings[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          reviewRatings.serviceName.name
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        subtitle: Text(
                                          reviewRatings.user.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              ' ${reviewRatings.createdAt.toLocal().toVerbalDateTimeWithDay}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            RatingBarIndicator(
                                              itemBuilder: (context, index) {
                                                return Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              itemSize: 20,
                                              rating: reviewRatings.rating
                                                  .toDouble(),
                                              itemCount: 5,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        onTap: () =>
                                            ReviewRatingsDetailBottomSheet.show(
                                          context,
                                          reviewRatings,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: -2,
                          left: 00,
                          right: 0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                onChanged: (value) =>
                                    provider.updateSearchTerm(value),
                                decoration: const InputDecoration(
                                  hintText: 'Search reviews and ratings...',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 30,
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
