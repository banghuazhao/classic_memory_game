import 'package:classic_memory_game/data/data.dart';
import 'package:classic_memory_game/screen/colors.dart';
import 'package:classic_memory_game/util/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _bgMusic = Data.bgMusicEnabled;
  String _selectedTrack = Data.bgMusicTrack;
  bool _soundEffects = Data.soundEffects;

  Future<void> _toggleBgMusic(bool value) async {
    setState(() => _bgMusic = value);
    await AudioManager.instance.setEnabled(value);
  }

  Future<void> _selectTrack(String trackName) async {
    setState(() => _selectedTrack = trackName);
    await AudioManager.instance.setTrack(trackName);
  }

  Future<void> _toggleSoundEffects(bool value) async {
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
          _SwitchCard(
            icon: Icons.music_note_rounded,
            title: 'Background Music',
            subtitle: _bgMusic ? 'On' : 'Off',
            value: _bgMusic,
            onChanged: _toggleBgMusic,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _bgMusic
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _TrackPickerCard(
                      selectedTrack: _selectedTrack,
                      onSelect: _selectTrack,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _SwitchCard(
            icon: Icons.volume_up_rounded,
            title: 'Sound Effects',
            subtitle: _soundEffects ? 'On' : 'Off',
            value: _soundEffects,
            onChanged: _toggleSoundEffects,
          ),
        ],
      ),
    );
  }
}

class _TrackPickerCard extends StatelessWidget {
  final String selectedTrack;
  final ValueChanged<String> onSelect;

  const _TrackPickerCard({required this.selectedTrack, required this.onSelect});

  static const _trackIcons = <String, IconData>{
    'None': Icons.music_off_rounded,
    'Calm': Icons.self_improvement_rounded,
    'Upbeat': Icons.celebration_rounded,
    'Peaceful': Icons.spa_rounded,
    'Classical': Icons.piano_rounded,
    'Rain': Icons.water_drop_rounded,
    'Forest': Icons.forest_rounded,
  };

  static const _trackDescriptions = <String, String>{
    'None': 'No music',
    'Calm': 'Relaxed & cozy',
    'Upbeat': 'Classic tavern energy',
    'Peaceful': 'Birdsong & nature',
    'Classical': 'Mozart — aids focus',
    'Rain': 'Light rain ambience',
    'Forest': 'Creek & woodland sounds',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Music Track',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MyColors.mainText,
                ),
              ),
            ),
            ...AudioManager.tracks.keys.map((name) {
              final isSelected = selectedTrack == name;
              return GestureDetector(
                onTap: () => onSelect(name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MyColors.mainText.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? MyColors.mainText : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _trackIcons[name] ?? Icons.music_note_rounded,
                        color: MyColors.mainText,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.mainText,
                                )),
                            Text(_trackDescriptions[name] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MyColors.mainText.withOpacity(0.6),
                                )),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded,
                            color: MyColors.mainText, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
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
                      style: TextStyle(
                          fontSize: 14,
                          color: MyColors.mainText.withOpacity(0.6))),
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
