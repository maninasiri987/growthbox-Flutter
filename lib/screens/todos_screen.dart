import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todos_provider.dart';
import '../theme/colors.dart';
import '../widgets/todo_item.dart';
import 'todo_editor_screen.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.filteredTodos;

    return Scaffold(
      body: Column(
        children: [
          // Filter tabs: All, Active, Completed
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                _buildFilterTab(
                  context: context,
                  index: 0,
                  title: 'All',
                  isSelected: provider.filterIndex == 0,
                  onTap: () => provider.setFilterIndex(0),
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  context: context,
                  index: 1,
                  title: 'Active',
                  isSelected: provider.filterIndex == 1,
                  onTap: () => provider.setFilterIndex(1),
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  context: context,
                  index: 2,
                  title: 'Completed',
                  isSelected: provider.filterIndex == 2,
                  onTap: () => provider.setFilterIndex(2),
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // Todos List or Empty State
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 56,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No todos in this view',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap New Todo below to add a task',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: todos.length,
                        itemBuilder: (context, idx) {
                          final todo = todos[idx];
                          return TodoItem(
                            todo: todo,
                            onToggle: (val) => provider.toggleCompleted(todo),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TodoEditorScreen(todo: todo),
                                ),
                              );
                            },
                            onDelete: () {
                              _confirmDeleteTodo(context, provider, todo.id);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TodoEditorScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Todo', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.red500,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required int index,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red500.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.red500 : theme.dividerColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.red500 : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  void _confirmDeleteTodo(BuildContext context, TodosProvider provider, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Todo?'),
        content: const Text('This task will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteTodo(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red500),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
