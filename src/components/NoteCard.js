import React from 'react';
import { TouchableOpacity, View, Text, StyleSheet } from 'react-native';
import { useTheme } from '../context/ThemeContext';

export const NoteCard = ({ note, onPress, onToggleArchive, onDelete }) => {
  const { theme } = useTheme();

  return (
    <TouchableOpacity
      style={[
        styles.card,
        {
          backgroundColor: theme.bgSecondary,
          borderColor: theme.borderPrimary,
        },
      ]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <View style={styles.header}>
        <Text style={[styles.title, { color: theme.textPrimary }]} numberOfLines={1}>
          {note.title || 'Untitled Note'}
        </Text>
        <View style={styles.actions}>
          <TouchableOpacity onPress={onToggleArchive} style={styles.btn}>
            <Text style={{ color: theme.textSecondary, fontSize: 13 }}>
              {note.isArchived ? '📂' : '📦'}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={onDelete} style={styles.btn}>
            <Text style={{ color: '#FB2C36', fontSize: 13 }}>🗑️</Text>
          </TouchableOpacity>
        </View>
      </View>

      <Text style={[styles.content, { color: theme.textSecondary }]} numberOfLines={2}>
        {note.content}
      </Text>

      <View style={styles.footer}>
        <View style={styles.tags}>
          {note.tags &&
            note.tags.map((tag, i) => (
              <View key={i} style={styles.tagBadge}>
                <Text style={styles.tagText}>#{tag}</Text>
              </View>
            ))}
        </View>
        <Text style={[styles.date, { color: theme.textTertiary }]}>
          {new Date(note.updatedAt).toLocaleDateString()}
        </Text>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    padding: 14,
    borderRadius: 14,
    borderWidth: 1,
    marginBottom: 10,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  title: {
    fontSize: 15,
    fontWeight: '700',
    flex: 1,
  },
  actions: {
    flexDirection: 'row',
    gap: 8,
  },
  btn: {
    padding: 4,
  },
  content: {
    fontSize: 13,
    marginVertical: 8,
    lineHeight: 18,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 6,
  },
  tags: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 4,
  },
  tagBadge: {
    backgroundColor: 'rgba(252, 187, 0, 0.15)',
    paddingHorizontal: 7,
    paddingVertical: 2,
    borderRadius: 5,
  },
  tagText: {
    color: '#FCBB00',
    fontSize: 11,
    fontWeight: '700',
  },
  date: {
    fontSize: 10,
  },
});
