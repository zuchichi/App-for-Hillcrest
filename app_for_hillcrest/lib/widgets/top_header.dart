import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    required this.onSearchChanged,
    required this.hint,
  });

  final ValueChanged<String> onSearchChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: AppTheme.searchFill,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}
