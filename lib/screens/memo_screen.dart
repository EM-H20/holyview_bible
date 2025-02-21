import 'package:flutter/material.dart';
import 'package:holyview/service/memo_service.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  MemoScreenState createState() => MemoScreenState();
}

class MemoScreenState extends State<MemoScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _memos = [];

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    _memos = await MemoService.loadMemos();
    setState(() {});
  }

  Future<void> _saveMemo() async {
    if (_controller.text.isNotEmpty) {
      await MemoService.saveMemo(_controller.text);
      _controller.clear();
      _loadMemos();
    }
  }

  Future<void> _updateMemo(int index, String updatedMemo) async {
    await MemoService.updateMemo(index, updatedMemo);
    _loadMemos();
  }

  Future<void> _deleteMemo(int index) async {
    await MemoService.deleteMemo(index);
    _loadMemos();
  }

  void _showEditDialog(int index) {
    final TextEditingController editController =
        TextEditingController(text: _memos[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('메모 수정'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: '메모를 수정하세요.',
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _updateMemo(index, editController.text);
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '메모를 입력하세요.',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: "ex) 메모메모",
                hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _saveMemo,
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _memos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _memos[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteMemo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
