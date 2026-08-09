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
import { useTodos } from '../context/TodosContext';

export const TodoEditorModal = ({ visible, todo, onClose }) => {
  const { theme } = useTheme();
  const { createTodo, updateTodo } = useTodos();

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState(2); // 3 = High, 2 = Medium, 1 = Low

  useEffect(() => {
    if (todo) {
      setTitle(todo.title || '');
      setDescription(todo.description || '');
      setPriority(todo.priority || 2);
    } else {
      setTitle('');
      setDescription('');
      setPriority(2);
    }
  }, [todo, visible]);

  if (!visible) return null;

  const handleSave = async () => {
    if (!title.trim()) {
      return;
    }
    if (todo) {
      await updateTodo({
        ...todo,
        title: title.trim(),
        description: description.trim(),
        priority,
      });
    } else {
      await createTodo(title.trim(), description.trim(), priority);
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
              {todo ? 'Edit Todo' : 'New Todo'}
            </Text>
            <TouchableOpacity onPress={handleSave}>
              <Text style={{ color: '#FB2C36', fontWeight: '700', fontSize: 16 }}>Save</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.body}>
            <TextInput
              style={[styles.titleInput, { color: theme.textPrimary }]}
              placeholder="What needs to be done?"
              placeholderTextColor={theme.textTertiary}
              value={title}
              onChangeText={setTitle}
            />

            <TextInput
              style={[styles.descInput, { color: theme.textSecondary }]}
              placeholder="Add details or notes..."
              placeholderTextColor={theme.textTertiary}
              value={description}
              onChangeText={setDescription}
              multiline
              numberOfLines={4}
            />

            <Text style={[styles.sectionTitle, { color: theme.textSecondary }]}>
              PRIORITY LEVEL
            </Text>
            <View style={styles.priorityRow}>
              {[
                { p: 3, label: 'High', color: '#FB2C36' },
                { p: 2, label: 'Medium', color: '#FCBB00' },
                { p: 1, label: 'Low', color: '#10B981' },
              ].map((item) => {
                const selected = priority === item.p;
                return (
                  <TouchableOpacity
                    key={item.p}
                    style={[
                      styles.priorityBtn,
                      {
                        borderColor: selected ? item.color : theme.borderPrimary,
                        backgroundColor: selected ? item.color + '20' : 'transparent',
                      },
                    ]}
                    onPress={() => setPriority(item.p)}
                  >
                    <Text
                      style={{
                        color: selected ? item.color : theme.textSecondary,
                        fontWeight: selected ? '700' : '500',
                      }}
                    >
                      {item.label}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
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
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 12,
  },
  descInput: {
    fontSize: 14,
    lineHeight: 20,
    marginBottom: 24,
    height: 90,
    textAlignVertical: 'top',
  },
  sectionTitle: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 0.5,
    marginBottom: 10,
  },
  priorityRow: {
    flexDirection: 'row',
    gap: 10,
  },
  priorityBtn: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
