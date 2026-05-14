import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable search bar widget.
class SearchBarWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBarWidget({
    super.key,
    this.hint = 'Search for food...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: const Icon(Icons.tune_rounded),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
      ),
    );
  }
}
