import 'package:flutter/material.dart';

class DismissibleLists extends StatefulWidget {
  const DismissibleLists({super.key});

  @override
  State<DismissibleLists> createState() => _DismissibleListsState();
}

class _DismissibleListsState extends State<DismissibleLists> {
  final List<String> items = ["Task 1", "Task 2", "Task 3", "Task 4"];
  late List<bool> checked;

  String? _lastDeletedItem;
  bool? _lastDeletedChecked;
  int? _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    checked = List.generate(items.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;

          // Move item in items
          final element = items.removeAt(oldIndex);
          items.insert(newIndex, element);

          // Move corresponding checked value
          final checkedValue = checked.removeAt(oldIndex);
          checked.insert(newIndex, checkedValue);
        });
      },
      children: [
        for (int i = 0; i < items.length; i++)
          Dismissible(
            key: ValueKey(items[i]),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirm Delete"),
                  content: Text("Are you sure you want to delete ${items[i]}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              setState(() {
                _lastDeletedIndex = i;
                _lastDeletedItem = items.removeAt(i);
                _lastDeletedChecked = checked.removeAt(i);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_lastDeletedItem deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        if (_lastDeletedItem != null &&
                            _lastDeletedIndex != null &&
                            _lastDeletedChecked != null) {
                          items.insert(_lastDeletedIndex!, _lastDeletedItem!);
                          checked.insert(
                            _lastDeletedIndex!,
                            _lastDeletedChecked!,
                          );
                        }
                      });
                    },
                  ),
                ),
              );
            },
            child: ListTile(
              key: ValueKey("tile_${items[i]}"),
              title: Text(
                items[i],
                style: TextStyle(
                  decoration: checked[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              leading: const Icon(Icons.drag_handle),
              trailing: Checkbox(
                value: checked[i],
                onChanged: (value) {
                  setState(() {
                    checked[i] = value ?? false;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
