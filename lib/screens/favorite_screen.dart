import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holyview/service/favorite_service.dart';
import 'package:holyview/screens/bible_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, String>> favoriteVerses = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return; // Check if the widget is still in the tree

    List<Map<String, String>> favorites = await FavoriteService.getFavorites();
    if (!mounted) return; // Double check after the async operation

    setState(() {
      favoriteVerses = favorites;
    });
  }

  Future<void> _removeFavorite(String verseKey) async {
    HapticFeedback.lightImpact();
    await FavoriteService.removeFavorite(verseKey);
    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      favoriteVerses.removeWhere((verse) => verse["key"] == verseKey);
    });
  }

  void _navigateToVerse(String verseKey) {
    HapticFeedback.lightImpact();
    if (!mounted) return; // Check if the widget is still in the tree

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BibleScreen(),
      ),
    ).then((_) {
      // Add then block
      _loadFavorites(); // Refresh after returning from BibleScreen
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = favoriteVerses.removeAt(oldIndex);
      favoriteVerses.insert(newIndex, item);
    });

    // 변경된 순서 저장
    _saveFavoriteOrder();
  }

  Future<void> _saveFavoriteOrder() async {
    List<String> encodedFavorites = favoriteVerses
        .map(
            (verse) => jsonEncode({"key": verse["key"], "text": verse["text"]}))
        .toList();
    if (!mounted) return; // Check if the widget is still in the tree

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // Check if the widget is still in the tree
    await prefs.setStringList("favorite_verses", encodedFavorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("즐겨찾기")),
      body: favoriteVerses.isEmpty
          ? const Center(child: Text("저장된 즐겨찾기가 없습니다."))
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favoriteVerses.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final item = favoriteVerses[index];

                return Card(
                  key: ValueKey(item["key"]), // ReorderableListView에 필요한 고유 키
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: ListTile(
                    title: Text(item["key"]!,
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text(item["text"]!,
                        style: const TextStyle(fontSize: 16)),
                    onTap: () => _navigateToVerse(item["key"]!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeFavorite(item["key"]!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
