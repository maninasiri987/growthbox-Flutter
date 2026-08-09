import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todos_provider.dart';
import '../theme/colors.dart';

class TodoEditorScreen extends StatefulWidget {
  final Todo? todo;

  const TodoEditorScreen({super.key, this.todo});

  @override
  State<TodoEditorScreen> createState() => _TodoEditorScreenState();
}

class _TodoEditorScreenState extends State<TodoEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  int _priority = 2; // 3 = High, 2 = Medium, 1 = Low
  DateTime? _dueDate;
  bool _isSaving = false;

  bool get isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    _priority = widget.todo?.priority ?? 2;
    _dueDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a todo title')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = Provider.of<TodosProvider>(context, listen: false);

    if (isEditing) {
      final updated = widget.todo!.copyWith(
        title: title,
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      );
      await provider.updateTodo(updated);
    } else {
      await provider.createTodo(
        title,
        _descriptionController.text.trim(),
        _priority,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Todo' : 'New Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.red500, size: 28),
            onPressed: _isSaving ? null : _saveTodo,
            tooltip: 'Save Todo',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
              ),
              maxLines: null,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: theme.textTheme.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Add details or description...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
              ),
              maxLines: 3,
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Priority',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPriorityChip(3, 'High', AppColors.red500),
                const SizedBox(width: 10),
                _buildPriorityChip(2, 'Medium', AppColors.amber500),
                const SizedBox(width: 10),
                _buildPriorityChip(1, 'Low', AppColors.emerald500),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Due Date',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickDueDate,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: theme.primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate != null
                          ? DateFormat.yMMMd().format(_dueDate!)
                          : 'Set target due date',
                      style: TextStyle(
                        fontWeight: _dueDate != null ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _dueDate = null),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(int level, String label, Color color) {
    final isSelected = _priority == level;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = level),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Theme.of(context).dividerColor.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
