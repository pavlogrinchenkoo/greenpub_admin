import 'package:auto_route/annotations.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/custom_auto_tabs_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

@RoutePage()
class SideBarPage extends StatefulWidget {
  const SideBarPage({super.key});

  @override
  State<SideBarPage> createState() => _SideBarPageState();
}

class _SideBarPageState extends State<SideBarPage> {
  @override
  Widget build(BuildContext context) {
    return CustomAutoTabsScaffold(
      routes: const [
        UsersRoute(),
        OrdersRoute(),
        ProductsRoute(),
        CategoriesRoute(),
        TagsRoute(),
        SharesRoute(),
        SystemRoute(),
      ],
      bodyBuilder: (_, tabsRouter) {
        return Row(
          children: [
            SideNavigationBar(
              theme: SideNavigationBarTheme(
                backgroundColor: BC.white,
                dividerTheme: const SideNavigationBarDividerTheme(
                  showHeaderDivider: true,
                  showMainDivider: false,
                  showFooterDivider: true,
                ),
                togglerTheme: SideNavigationBarTogglerTheme(
                  expandIconColor: BC.black,
                  shrinkIconColor: BC.black,
                ),
                itemTheme: SideNavigationBarItemTheme(
                  selectedItemColor: BC.black,
                ),
              ),
              selectedIndex: tabsRouter.activeIndex,
              items: const [
                SideNavigationBarItem(
                  icon: Icons.people,
                  label: 'Користувачі',
                ),
                SideNavigationBarItem(
                  icon: Icons.history_toggle_off,
                  label: 'Замовлення',
                ),
                SideNavigationBarItem(
                  icon: Icons.fastfood,
                  label: 'Продукти',
                ),
                SideNavigationBarItem(
                  icon: Icons.category,
                  label: 'Категорії',
                ),
                SideNavigationBarItem(
                  icon: Icons.tag,
                  label: 'Теги',
                ),
                SideNavigationBarItem(
                  icon: Icons.share,
                  label: 'Акції',
                ),
                SideNavigationBarItem(
                  icon: Icons.settings,
                  label: 'Системні налаштування',
                ),
              ],
              onTap: (index) {
                setState(() {
                  tabsRouter.setActiveIndex(index);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
