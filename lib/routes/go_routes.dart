import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sertific8/views/main_menu.dart';
import 'package:sertific8/views/pixel_selector_menu.dart';
import 'package:sertific8/states/pixel_selector_provider.dart';
import 'package:file_selector/file_selector.dart';

GoRouter appRoute = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MainMenu(),
    ),
    GoRoute(
      path: '/pixel_selector',
      builder: (context, state) {
        final imageFile = state.extra as XFile;
        return ChangeNotifierProvider(
          create: (_) => PixelSelectorProvider(),
          child: PixelSelectorMenu(imageFile: imageFile),
        );
      },
    ),
  ],
);
