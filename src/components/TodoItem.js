import React from 'react';
import { TouchableOpacity, View, Text, StyleSheet } from 'react-native';
import { useTheme } from '../context/ThemeContext';

export const TodoItem = ({ todo, onToggle, onPress, onDelete }) => {
  const { theme } = useTheme();

  const getPriorityColor = (p) => {
    switch (p) {
      case 3:
        return '#FB2C36';
      case 2:
        return '#FCBB00';
      default:
        return '#10B981';
    }
  };

  const getPriorityLabel = (p) => {
    switch (p) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      default:
        return 'Low';
    }
  };

  const pColor = getPriorityColor(todo.priority);

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
      <TouchableOpacity onPress={onToggle} style={styles.checkbox}>
        <View
          style={[
            styles.checkCircle,
            {
              backgroundColor: todo.isCompleted ? '#10B981' : 'transparent',
              borderColor: todo.isCompleted ? '#10B981' : theme.borderSecondary,
            },
          ]}
        >
          {todo.isCompleted && <Text style={styles.checkIcon}>✓</Text>}
        </View>
      </TouchableOpacity>

      <View style={styles.content}>
        <Text
          style={[
            styles.title,
            {
              color: todo.isCompleted ? theme.textTertiary : theme.textPrimary,
              textDecorationLine: todo.isCompleted ? 'line-through' : 'none',
            },
          ]}
        >
          {todo.title}
        </Text>
        {todo.description ? (
          <Text
            style={[
              styles.desc,
              {
                color: todo.isCompleted ? theme.textTertiary : theme.textSecondary,
                textDecorationLine: todo.isCompleted ? 'line-through' : 'none',
              },
            ]}
            numberOfLines={2}
          >
            {todo.description}
          </Text>
        ) : null}
        <View style={styles.footer}>
          <View style={[styles.badge, { backgroundColor: pColor + '20' }]}>
            <Text style={[styles.badgeText, { color: pColor }]}>
              {getPriorityLabel(todo.priority)}
            </Text>
          </View>
          <Text style={[styles.date, { color: theme.textTertiary }]}>
            {new Date(todo.updatedAt).toLocaleDateString()}
          </Text>
        </View>
      </View>

      <TouchableOpacity onPress={onDelete} style={styles.delBtn}>
        <Text style={{ color: '#FB2C36', fontSize: 13 }}>🗑️</Text>
      </TouchableOpacity>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    padding: 14,
    borderRadius: 14,
    borderWidth: 1,
    marginBottom: 10,
    alignItems: 'flex-start',
  },
  checkbox: {
    marginRight: 10,
    marginTop: 2,
  },
  checkCircle: {
    width: 20,
    height: 20,
    borderRadius: 6,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkIcon: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: '800',
  },
  content: {
    flex: 1,
  },
  title: {
    fontSize: 14,
    fontWeight: '700',
  },
  desc: {
    fontSize: 12,
    marginTop: 4,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  badge: {
    paddingHorizontal: 7,
    paddingVertical: 2,
    borderRadius: 5,
  },
  badgeText: {
    fontSize: 10,
    fontWeight: '800',
  },
  date: {
    fontSize: 10,
  },
  delBtn: {
    padding: 6,
    marginLeft: 6,
  },
});
