import React from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, FlatList } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useNotes } from '../context/NotesContext';
import { NoteCard } from '../components/NoteCard';

export const NotesScreen = ({ onEditNote, onNewNote }) => {
  const { theme } = useTheme();
  const {
    filteredNotes,
    showArchived,
    setShowArchived,
    searchQuery,
    setSearchQuery,
    toggleArchive,
    deleteNote,
  } = useNotes();

  return (
    <View style={[styles.container, { backgroundColor: theme.bgPrimary }]}>
      <View style={[styles.searchBox, { backgroundColor: theme.bgSecondary, borderColor: theme.borderPrimary }]}>
        <Text style={{ fontSize: 16, marginRight: 8, color: theme.textTertiary }}>🔍</Text>
        <TextInput
          style={[styles.input, { color: theme.textPrimary }]}
          placeholder="Search offline notes..."
          placeholderTextColor={theme.textTertiary}
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
      </View>

      <View style={styles.tabs}>
        <TouchableOpacity
          style={[
            styles.tab,
            !showArchived && { backgroundColor: '#FCBB0025', borderColor: '#FCBB00' },
          ]}
          onPress={() => setShowArchived(false)}
        >
          <Text
            style={[
              styles.tabText,
              { color: !showArchived ? '#FCBB00' : theme.textSecondary },
              !showArchived && { fontWeight: '700' },
            ]}
          >
            Active
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.tab,
            showArchived && { backgroundColor: '#FCBB0025', borderColor: '#FCBB00' },
          ]}
          onPress={() => setShowArchived(true)}
        >
          <Text
            style={[
              styles.tabText,
              { color: showArchived ? '#FCBB00' : theme.textSecondary },
              showArchived && { fontWeight: '700' },
            ]}
          >
            Archived
          </Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={filteredNotes}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.list}
        renderItem={({ item }) => (
          <NoteCard
            note={item}
            onPress={() => onEditNote(item)}
            onToggleArchive={() => toggleArchive(item.id)}
            onDelete={() => deleteNote(item.id)}
          />
        )}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={{ fontSize: 36, marginBottom: 10 }}>📝</Text>
            <Text style={[styles.emptyTitle, { color: theme.textSecondary }]}>
              {showArchived ? 'No archived notes' : 'No active notes'}
            </Text>
            <Text style={[styles.emptySub, { color: theme.textTertiary }]}>
              Tap "+ New Note" below to create one
            </Text>
          </View>
        }
      />

      <TouchableOpacity style={styles.fab} onPress={onNewNote}>
        <Text style={styles.fabText}>+ New Note</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  searchBox: {
    flexDirection: 'row',
    alignItems: 'center',
    margin: 14,
    paddingHorizontal: 14,
    height: 44,
    borderRadius: 12,
    borderWidth: 1,
  },
  input: {
    flex: 1,
    fontSize: 14,
  },
  tabs: {
    flexDirection: 'row',
    paddingHorizontal: 14,
    marginBottom: 10,
    gap: 8,
  },
  tab: {
    flex: 1,
    paddingVertical: 8,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'transparent',
    alignItems: 'center',
  },
  tabText: {
    fontSize: 13,
  },
  list: {
    paddingHorizontal: 14,
    paddingBottom: 80,
  },
  empty: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 60,
  },
  emptyTitle: {
    fontSize: 15,
    fontWeight: '700',
  },
  emptySub: {
    fontSize: 12,
    marginTop: 4,
  },
  fab: {
    position: 'absolute',
    bottom: 20,
    right: 20,
    paddingHorizontal: 18,
    paddingVertical: 13,
    borderRadius: 24,
    backgroundColor: '#FCBB00',
    elevation: 4,
  },
  fabText: {
    color: '#000',
    fontWeight: '700',
    fontSize: 14,
  },
});
