import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:suvidhaorg/extensions/extensions.dart';
import 'package:suvidhaorg/models/review_rating_array_response.dart';
import 'package:suvidhaorg/widgets/form_bottom_sheet_header.dart';

class ReviewRatingsDetailBottomSheet extends StatelessWidget {
  const ReviewRatingsDetailBottomSheet({super.key, required this.reviewRating});
  final DocsReviewRating reviewRating;

  static void show(BuildContext context, DocsReviewRating reviewRating) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReviewRatingsDetailBottomSheet(
        reviewRating: reviewRating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                FormBottomSheetHeader(title: 'Review & Rating'),
                SizedBox(width: MediaQuery.of(context).size.width * 0.11),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.close),
                )
              ],
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "From",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        reviewRating.user.name,
                      ),
                      trailing: reviewRating.user.profilePic != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                reviewRating.user.profilePic!,
                              ),
                            )
                          : null,
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        "Service",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        reviewRating.serviceName.name,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        "Rating",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBarIndicator(
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            itemCount: 5,
                            itemSize: 20,
                            rating: reviewRating.rating.toDouble(),
                            direction: Axis.horizontal,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '(${reviewRating.rating.toStringAsFixed(1)}/5)',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        "Service Provider Name",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        reviewRating.service.serviceProviderName,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        "Date",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        reviewRating.createdAt
                            .toLocal()
                            .toVerbalDateTimeWithDay,
                      ),
                    ),
                    customDivider(),
                    ListTile(
                      title: Text(
                        "Review",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Flexible(
                        child: Text(reviewRating.review ?? "Not Provided"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customDivider() {
    return Divider(
      height: 0,
      thickness: 0,
      endIndent: 10,
      indent: 20,
    );
  }
}
