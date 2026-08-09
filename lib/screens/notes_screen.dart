import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../theme/colors.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<NotesProvider>(context);
    final notes = provider.filteredNotes;

    return Scaffold(
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => provider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: Icon(Icons.search, size: 20, color: theme.textTheme.bodySmall?.color),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active / Archived filter tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildTabButton(
                  context: context,
                  title: 'Active',
                  isSelected: !provider.showArchived,
                  onTap: () => provider.setArchivedTab(false),
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  context: context,
                  title: 'Archived',
                  isSelected: provider.showArchived,
                  onTap: () => provider.setArchivedTab(true),
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // Notes List or Empty State
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              provider.showArchived ? Icons.archive_outlined : Icons.note_alt_outlined,
                              size: 56,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              provider.showArchived
                                  ? 'No archived notes yet'
                                  : 'No active notes yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap the + button below to create your first note',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final note = notes[idx];
                          return NoteCard(
                            note: note,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => NoteEditorScreen(note: note),
                                ),
                              );
                            },
                            onArchiveToggle: () {
                              provider.toggleArchive(note);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    note.isArchived
                                        ? 'Note restored to active'
                                        : 'Note archived',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            onDelete: () {
                              _confirmDeleteNote(context, provider, note.id);
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
            MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.amber400,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
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
          color: isSelected ? AppColors.amber400.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.amber400 : theme.dividerColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.amber400 : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  void _confirmDeleteNote(BuildContext context, NotesProvider provider, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteNote(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red500),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
