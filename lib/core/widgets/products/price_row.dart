import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/utils/formatters.dart';

class PriceRow extends StatelessWidget {
  final double price;
  final double? oldPrice;
  final bool large;

  const PriceRow({
    super.key,
    required this.price,
    this.oldPrice,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          Formatters.price(price),
          style: large
              ? AppTextStyle.price.copyWith(fontSize: 20)
              : AppTextStyle.price,
        ),
        if (oldPrice != null)
          Text(
            Formatters.price(oldPrice!),
            style: AppTextStyle.priceOld.copyWith(
              fontSize: large ? 15.0 : null,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}