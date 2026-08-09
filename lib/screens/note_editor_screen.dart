import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../theme/colors.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  bool _isSaving = false;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _tagsController = TextEditingController(
      text: widget.note?.tags.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() => _isSaving = true);
    final provider = Provider.of<NotesProvider>(context, listen: false);

    if (isEditing) {
      final updated = widget.note!.copyWith(
        title: title,
        content: content,
        tags: tags,
      );
      await provider.updateNote(updated);
    } else {
      await provider.createNote(title, content, tags);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(
                widget.note!.isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
              tooltip: widget.note!.isArchived ? 'Unarchive' : 'Archive',
              onPressed: () async {
                final provider = Provider.of<NotesProvider>(context, listen: false);
                await provider.toggleArchive(widget.note!);
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.amber400, size: 26),
            onPressed: _isSaving ? null : _saveNote,
            tooltip: 'Save Note',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
              ),
              maxLines: null,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagsController,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.amber400,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Tags (comma separated e.g. Growth, AI, Flutter)',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                prefixIcon: const Icon(Icons.tag, size: 16, color: AppColors.amber400),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              decoration: const InputDecoration(
                hintText: 'Write down your thoughts, notes, and AI insights...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
