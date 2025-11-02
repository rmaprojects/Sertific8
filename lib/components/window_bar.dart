import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowBar extends StatelessWidget implements PreferredSizeWidget {
  const WindowBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          centerTitle: true,
          // give enough width for two small icon buttons to avoid overflow
          leadingWidth: 96,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  hoverColor: Theme.of(context).colorScheme.errorContainer,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                iconSize: 20,
                icon: const Icon(Icons.close),
                onPressed: () async {
                  windowManager.close();
                },
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  hoverColor: Colors.amberAccent.shade100,
                ),
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                iconSize: 20,
                icon: const Icon(Icons.minimize),
                onPressed: () async {
                  windowManager.minimize();
                },
              )
            ],
          ),
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}