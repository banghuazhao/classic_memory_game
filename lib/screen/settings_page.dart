import 'package:audioplayers/audioplayers.dart';
import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/screen/colors.dart';
import 'package:classic_memory_game/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _bgMusic = !Data.neverPlay;
  bool _soundEffects = Data.soundEffects;

  Future<void> _setBgMusic(bool value) async {
    setState(() => _bgMusic = value);
    Data.neverPlay = !value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('play', !value);
    if (value) {
      final state = audioPlayer.state;
      if (state == PlayerState.paused) {
        await audioPlayer.resume();
      } else {
        await audioPlayer.setReleaseMode(ReleaseMode.loop);
        await audioPlayer.play(AssetSource('audio/bg.mp3'));
      }
      Data.play = true;
    } else {
      await audioPlayer.pause();
      Data.play = false;
    }
  }

  Future<void> _setSoundEffects(bool value) async {
    setState(() => _soundEffects = value);
    Data.soundEffects = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEffects', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: MyColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _SettingsCard(
            icon: Icons.music_note_rounded,
            title: 'Background Music',
            subtitle: _bgMusic ? 'On' : 'Off',
            value: _bgMusic,
            onChanged: _setBgMusic,
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            icon: Icons.volume_up_rounded,
            title: 'Sound Effects',
            subtitle: _soundEffects ? 'On' : 'Off',
            value: _soundEffects,
            onChanged: _setSoundEffects,
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: MyColors.mainText, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: MyColors.mainText)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 14, color: MyColors.mainText.withOpacity(0.6))),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: MyColors.mainText,
            ),
          ],
        ),
      ),
    );
  }
}
