import React from 'react';
import { TouchableOpacity, View, Text, StyleSheet } from 'react-native';
import { useTheme } from '../context/ThemeContext';

export const StatCard = ({ title, value, subtitle, icon, iconColor, onPress }) => {
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
        <Text style={[styles.title, { color: theme.textSecondary }]}>{title}</Text>
        <View style={[styles.iconBox, { backgroundColor: iconColor + '20' }]}>
          <Text style={{ color: iconColor, fontWeight: '700', fontSize: 13 }}>{icon}</Text>
        </View>
      </View>
      <Text style={[styles.value, { color: theme.textPrimary }]}>{value}</Text>
      <Text style={[styles.subtitle, { color: theme.textTertiary }]}>{subtitle}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    flex: 1,
    padding: 14,
    borderRadius: 14,
    borderWidth: 1,
    margin: 5,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  title: {
    fontSize: 12,
    fontWeight: '600',
  },
  iconBox: {
    paddingHorizontal: 7,
    paddingVertical: 3,
    borderRadius: 6,
  },
  value: {
    fontSize: 22,
    fontWeight: '800',
  },
  subtitle: {
    fontSize: 11,
    marginTop: 3,
  },
});
