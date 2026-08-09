import React, { useState, useEffect } from 'react';
import {
  Modal,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useNotes } from '../context/NotesContext';

export const NoteEditorModal = ({ visible, note, onClose }) => {
  const { theme } = useTheme();
  const { createNote, updateNote } = useNotes();

  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [tags, setTags] = useState('');

  useEffect(() => {
    if (note) {
      setTitle(note.title || '');
      setContent(note.content || '');
      setTags(note.tags ? note.tags.join(', ') : '');
    } else {
      setTitle('');
      setContent('');
      setTags('');
    }
  }, [note, visible]);

  if (!visible) return null;

  const handleSave = async () => {
    if (!title.trim() && !content.trim()) {
      onClose();
      return;
    }
    const tagList = tags
      .split(',')
      .map((t) => t.trim())
      .filter((t) => t.length > 0);

    if (note) {
      await updateNote({
        ...note,
        title: title.trim(),
        content: content.trim(),
        tags: tagList,
      });
    } else {
      await createNote(title.trim(), content.trim(), tagList);
    }
    onClose();
  };

  return (
    <Modal visible={visible} animationType="slide" onRequestClose={onClose}>
      <SafeAreaView style={[styles.container, { backgroundColor: theme.bgPrimary }]}>
        <KeyboardAvoidingView
          style={styles.flex}
          behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        >
          <View style={[styles.header, { borderBottomColor: theme.borderPrimary }]}>
            <TouchableOpacity onPress={onClose}>
              <Text style={{ color: theme.textSecondary, fontSize: 16 }}>Cancel</Text>
            </TouchableOpacity>
            <Text style={[styles.headerTitle, { color: theme.textPrimary }]}>
              {note ? 'Edit Note' : 'New Note'}
            </Text>
            <TouchableOpacity onPress={handleSave}>
              <Text style={{ color: '#FCBB00', fontWeight: '700', fontSize: 16 }}>Save</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.body}>
            <TextInput
              style={[styles.titleInput, { color: theme.textPrimary }]}
              placeholder="Note title..."
              placeholderTextColor={theme.textTertiary}
              value={title}
              onChangeText={setTitle}
            />

            <View style={[styles.tagBox, { borderColor: theme.borderPrimary }]}>
              <Text style={{ color: '#FCBB00', fontWeight: '700', marginRight: 6 }}>#</Text>
              <TextInput
                style={[styles.tagInput, { color: '#FCBB00' }]}
                placeholder="Tags (comma separated e.g. Growth, AI, Flutter)"
                placeholderTextColor={theme.textTertiary}
                value={tags}
                onChangeText={setTags}
              />
            </View>

            <TextInput
              style={[styles.contentInput, { color: theme.textSecondary }]}
              placeholder="Write your note thoughts here... Saved 100% offline."
              placeholderTextColor={theme.textTertiary}
              value={content}
              onChangeText={setContent}
              multiline
              textAlignVertical="top"
            />
          </View>
        </KeyboardAvoidingView>
      </SafeAreaView>
    </Modal>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  flex: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
  },
  headerTitle: {
    fontWeight: '700',
    fontSize: 16,
  },
  body: {
    flex: 1,
    padding: 16,
  },
  titleInput: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 12,
  },
  tagBox: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 10,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1,
    marginBottom: 16,
  },
  tagInput: {
    flex: 1,
    fontSize: 12,
    fontWeight: '600',
  },
  contentInput: {
    flex: 1,
    fontSize: 15,
    lineHeight: 22,
  },
});
