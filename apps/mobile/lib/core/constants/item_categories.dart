import 'package:flutter/material.dart';

/// A selectable item category, shared by the Lost and Found report flows so
/// both pickers stay in sync.
class ItemCategory {
  const ItemCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const List<ItemCategory> kItemCategories = [
  ItemCategory(label: 'Electronics', icon: Icons.devices_other_outlined),
  ItemCategory(label: 'Bag', icon: Icons.backpack_outlined),
  ItemCategory(label: 'Wallet / ID', icon: Icons.badge_outlined),
  ItemCategory(label: 'Keys', icon: Icons.key_outlined),
  ItemCategory(label: 'Jewelry', icon: Icons.diamond_outlined),
  ItemCategory(label: 'Clothing', icon: Icons.checkroom_outlined),
  ItemCategory(label: 'Documents', icon: Icons.description_outlined),
  ItemCategory(label: 'Other', icon: Icons.category_outlined),
];
