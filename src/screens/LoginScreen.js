import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, SafeAreaView } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useAuth } from '../context/AuthContext';
import { Logo } from '../components/Logo';

const PHRASES = [
  'growthBox',
  'Grow Daily',
  'Level Up',
  'Next Step',
  'Move Forward',
  'Unlock Potential',
];

export const LoginScreen = () => {
  const { theme } = useTheme();
  const { loginWithLocalStorage } = useAuth();

  const [phraseIndex, setPhraseIndex] = useState(0);
  const [typedText, setTypedText] = useState('');
  const [isDeleting, setIsDeleting] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      const currentPhrase = PHRASES[phraseIndex];
      if (!isDeleting) {
        if (typedText.length < currentPhrase.length) {
          setTypedText(currentPhrase.slice(0, typedText.length + 1));
        } else {
          setTimeout(() => setIsDeleting(true), 1500);
        }
      } else {
        if (typedText.length > 0) {
          setTypedText(currentPhrase.slice(0, typedText.length - 1));
        } else {
          setIsDeleting(false);
          setPhraseIndex((prev) => (prev + 1) % PHRASES.length);
        }
      }
    }, isDeleting ? 45 : 95);

    return () => clearTimeout(timer);
  }, [typedText, isDeleting, phraseIndex]);

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.bgPrimary }]}>
      <View style={styles.center}>
        <Logo size={76} showText={false} />
        <View style={styles.sloganRow}>
          <Text style={[styles.sloganText, { color: theme.textPrimary }]}>{typedText}</Text>
          <Text style={styles.cursor}>|</Text>
        </View>
        <Text style={[styles.subtitle, { color: theme.textSecondary }]}>
          Manage your notes and todos with AI.{'\n'}Simple, fast, and intelligent.
        </Text>

        <TouchableOpacity
          style={styles.localBtn}
          onPress={loginWithLocalStorage}
          activeOpacity={0.8}
        >
          <Text style={styles.localBtnText}>⚡ Continue with localStorage (100% Offline)</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.outBtn, { borderColor: theme.borderPrimary }]}
          onPress={() => alert('Online authentication is disabled in offline mode. Please use localStorage.')}
        >
          <Text style={[styles.outText, { color: theme.textSecondary }]}>
            Continue with Google (Cloud Sync)
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.outBtn, { borderColor: theme.borderPrimary }]}
          onPress={() => alert('Online authentication is disabled in offline mode. Please use localStorage.')}
        >
          <Text style={[styles.outText, { color: theme.textSecondary }]}>
            Continue with GitHub (Cloud Sync)
          </Text>
        </TouchableOpacity>

        <Text style={[styles.footerText, { color: theme.textTertiary }]}>
          growthBox React Native v1.0 • 100% Offline Capable & Privacy-First
        </Text>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 28,
  },
  sloganRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 24,
  },
  sloganText: {
    fontSize: 32,
    fontWeight: '800',
  },
  cursor: {
    fontSize: 32,
    fontWeight: '300',
    color: '#FCBB00',
    marginLeft: 2,
  },
  subtitle: {
    textAlign: 'center',
    fontSize: 14,
    lineHeight: 20,
    marginTop: 10,
    marginBottom: 36,
  },
  localBtn: {
    width: '100%',
    paddingVertical: 15,
    borderRadius: 14,
    backgroundColor: '#FCBB00',
    alignItems: 'center',
    marginBottom: 12,
  },
  localBtnText: {
    color: '#000',
    fontSize: 14,
    fontWeight: '700',
  },
  outBtn: {
    width: '100%',
    paddingVertical: 14,
    borderRadius: 14,
    borderWidth: 1,
    alignItems: 'center',
    marginBottom: 10,
  },
  outText: {
    fontSize: 13,
    fontWeight: '500',
  },
  footerText: {
    fontSize: 11,
    marginTop: 32,
  },
});
