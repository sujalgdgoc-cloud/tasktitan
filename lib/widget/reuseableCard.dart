import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReusableCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String bid;
  final String timeStamp;

  const ReusableCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.bid,
    required this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),

      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 1,
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 6),
          )
        ],
      ),

      child: Column(
        children: [

          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Container(
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.textTheme.bodyMedium?.color,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Get.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Get.theme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeStamp,
                            style: TextStyle(
                              color: Get.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.colorScheme.secondary
                                  .withValues(alpha: 0.35),
                              Get.theme.colorScheme.secondary
                                  .withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Get.theme.colorScheme.secondary
                                .withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "₹$bid",
                          style: TextStyle(
                            color: Get.theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}