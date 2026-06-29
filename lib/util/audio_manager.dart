import 'package:audioplayers/audioplayers.dart';
import 'package:classic_memory_game/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton that owns the single AudioPlayer for background music.
/// All bg music control goes through here so there can never be two
/// simultaneous players.
class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  final AudioPlayer _player = AudioPlayer();

  static const String _prefBgEnabled = 'bgMusicEnabled';
  static const String _prefBgTrack = 'bgMusicTrack';

  /// Track name → asset path inside assets/audio/. null means silence.
  static const Map<String, String?> tracks = {
    'None': null,
    'Calm': 'audio/bg.mp3',
    'Upbeat': 'audio/bg_upbeat.mp3',
    'Peaceful': 'audio/bg_peaceful.mp3',
    'Classical': 'audio/bg_classical.mp3',
    'Rain': 'audio/bg_rain.mp3',
    'Forest': 'audio/bg_forest.mp3',
  };

  bool get isEnabled => Data.bgMusicEnabled;
  String get currentTrack => Data.bgMusicTrack;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    Data.bgMusicEnabled = prefs.getBool(_prefBgEnabled) ?? true;
    Data.bgMusicTrack = prefs.getString(_prefBgTrack) ?? 'Calm';
    Data.soundEffects = prefs.getBool('soundEffects') ?? true;
    if (Data.bgMusicEnabled) await _start();
  }

  Future<void> setEnabled(bool enabled) async {
    Data.bgMusicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefBgEnabled, enabled);
    if (enabled) {
      await _start();
    } else {
      await _stop();
    }
  }

  Future<void> setTrack(String trackName) async {
    Data.bgMusicTrack = trackName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefBgTrack, trackName);
    if (Data.bgMusicEnabled) {
      await _stop();
      await _start();
    }
  }

  Future<void> pause() async {
    try { await _player.pause(); } catch (_) {}
  }

  Future<void> resume() async {
    if (!Data.bgMusicEnabled) return;
    try {
      if (_player.state == PlayerState.paused) {
        await _player.resume();
      } else {
        await _start();
      }
    } catch (_) {}
  }

  Future<void> _start() async {
    final asset = tracks[Data.bgMusicTrack];
    if (asset == null) return; // 'None' selected
    try {
      await _stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource(asset));
    } catch (e) {
      debugPrint('[AudioManager] play failed: $e');
    }
  }

  Future<void> _stop() async {
    try { await _player.stop(); } catch (_) {}
  }
}
