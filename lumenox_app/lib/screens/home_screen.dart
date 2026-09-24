import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/effect_model.dart';
import '../services/firestore_service.dart';
import '../widgets/effect_card.dart';

enum EffectFilter { all, running, favorites, recents }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirestoreService();
  EffectFilter _filter = EffectFilter.running;

  User get _user => FirebaseAuth.instance.currentUser!;

  List<EffectModel> _applyFilter(List<EffectModel> effects) {
    switch (_filter) {
      case EffectFilter.running:
        return effects.where((e) => e.isOn).toList();
      case EffectFilter.favorites:
        return effects.where((e) => e.isFavorite).toList();
      case EffectFilter.recents:
        return effects.where((e) => e.lastUsedAt != null).toList()
          ..sort((a, b) => b.lastUsedAt!.compareTo(a.lastUsedAt!));
      case EffectFilter.all:
        return effects;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      body: SafeArea(
        child: StreamBuilder<List<EffectModel>>(
          stream: _firestore.watchEffects(_user.uid),
          builder: (context, snapshot) {
            final effects = snapshot.data ?? [];
            final running = effects.where((e) => e.isOn).length;
            final favorites = effects.where((e) => e.isFavorite).length;
            final recents = effects.where((e) => e.lastUsedAt != null).length;
            final filtered = _applyFilter(effects);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(effects.length)),
                SliverToBoxAdapter(
                  child: _buildTabs(
                    all: effects.length,
                    running: running,
                    favorites: favorites,
                    recents: recents,
                  ),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (filtered.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: Text('No effects yet.')),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => EffectCard(
                          effect: filtered[i],
                          onToggle: (val) => _firestore.toggleEffect(
                              _user.uid, filtered[i].id, val),
                        ),
                        childCount: filtered.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader(int activeCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.grid_view_rounded, color: AppColors.primaryGreen),
              ),
              Row(
                children: const [
                  Icon(Icons.blur_circular, color: AppColors.primaryGreen),
                  SizedBox(width: 8),
                  Text('Lumenox',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                ],
              ),
              const CircleAvatar(radius: 24, backgroundColor: Colors.black12),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Good Morning', style: TextStyle(color: AppColors.textGrey)),
          Text(_user.displayName ?? 'there',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.mintLight, borderRadius: BorderRadius.circular(20)),
            child: Text('$activeCount Active Lighting Recipes',
                style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs({
    required int all,
    required int running,
    required int favorites,
    required int recents,
  }) {
    Widget tab(String label, int count, EffectFilter value) {
      final active = _filter == value;
      return GestureDetector(
        onTap: () => setState(() => _filter = value),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(
                    color: active ? AppColors.primaryGreen : AppColors.textGrey,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  )),
              const SizedBox(width: 4),
              Text('$count',
                  style: TextStyle(
                    fontSize: 12,
                    color: active ? AppColors.primaryGreen : AppColors.textGrey,
                  )),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            tab('ALL', all, EffectFilter.all),
            tab('RUNNING', running, EffectFilter.running),
            tab('FAVORITES', favorites, EffectFilter.favorites),
            tab('RECENTS', recents, EffectFilter.recents),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_rounded, color: AppColors.primaryGreen),
          Icon(Icons.my_location_outlined, color: AppColors.textGrey),
          Icon(Icons.star_border_rounded, color: AppColors.textGrey),
          Icon(Icons.settings_outlined, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
