import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { Logo } from './Logo';

export const CustomAppBar = ({ title, showLogo = false, onOpenDrawer }) => {
  const { theme, isDarkMode, toggleTheme } = useTheme();

  return (
    <View style={[styles.bar, { backgroundColor: theme.bgPrimary, borderBottomColor: theme.borderPrimary }]}>
      <View style={styles.left}>
        <TouchableOpacity onPress={onOpenDrawer} style={styles.btn}>
          <Text style={{ color: theme.textPrimary, fontSize: 18 }}>☰</Text>
        </TouchableOpacity>
        {showLogo ? (
          <Logo size={28} showText={true} textColor={theme.textPrimary} />
        ) : (
          <Text style={[styles.title, { color: theme.textPrimary }]}>{title}</Text>
        )}
      </View>

      <View style={styles.right}>
        <View style={styles.offlineBadge}>
          <Text style={styles.offlineText}>OFFLINE</Text>
        </View>
        <TouchableOpacity onPress={toggleTheme} style={styles.btn}>
          <Text style={{ fontSize: 16 }}>{isDarkMode ? '☀️' : '🌙'}</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  bar: {
    height: 56,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 14,
    borderBottomWidth: 1,
  },
  left: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  btn: {
    padding: 6,
  },
  title: {
    fontSize: 17,
    fontWeight: '700',
  },
  right: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  offlineBadge: {
    backgroundColor: 'rgba(252, 187, 0, 0.2)',
    borderColor: 'rgba(252, 187, 0, 0.4)',
    borderWidth: 1,
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  offlineText: {
    color: '#FCBB00',
    fontSize: 9,
    fontWeight: '800',
  },
});
