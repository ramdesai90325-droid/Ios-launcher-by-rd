import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const IOSLauncherApp());
}

class IOSLauncherApp extends StatelessWidget {
  const IOSLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS 18 Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: '.SF Pro Text',
      ),
      home: const IOSHomeScreen(),
    );
  }
}

class IOSHomeScreen extends StatefulWidget {
  const IOSHomeScreen({super.key});

  @override
  State<IOSHomeScreen> createState() => _IOSHomeScreenState();
}

class _IOSHomeScreenState extends State<IOSHomeScreen> {
  // Theme Modes: 0: Light, 1: Dark, 2: Automatic, 3: Tinted
  int _themeMode = 1;
  Color _tintColor = const Color(0xFFE040FB);
  bool _isJiggleMode = false;
  bool _showCustomizer = false;
  bool _showControlCenter = false;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Wallpaper Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                    Color(0xFF415A77),
                  ],
                ),
              ),
            ),
          ),

          // 2. Swipeable Pages
          GestureDetector(
            onLongPress: () {
              setState(() {
                _isJiggleMode = true;
                _showCustomizer = true;
              });
            },
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 10 && details.globalPosition.dx > MediaQuery.of(context).size.width * 0.5) {
                setState(() => _showControlCenter = true);
              }
            },
            child: PageView(
              controller: _pageController,
              children: [
                _buildWidgetScreen(),
                _buildAppGridScreen(),
                _buildAppLibraryScreen(),
              ],
            ),
          ),

          // 3. Dynamic Island
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 125,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Search Pill Indicator
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    color: Colors.white.withOpacity(0.18),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.search, color: Colors.white70, size: 14),
                        SizedBox(width: 4),
                        Text("Search", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. iOS Dock
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  height: 84,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  color: Colors.white.withOpacity(0.18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAppIcon("Phone", CupertinoIcons.phone_fill, Colors.green),
                      _buildAppIcon("Safari", CupertinoIcons.compass, Colors.blue),
                      _buildAppIcon("Messages", CupertinoIcons.chat_bubble_fill, Colors.greenAccent, badge: "17"),
                      _buildAppIcon("Google", CupertinoIcons.search_circle_fill, Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 6. iOS 18 Customization Modal
          if (_showCustomizer) _buildCustomizerModal(),

          // 7. Control Center Modal
          if (_showControlCenter) _buildControlCenter(),
        ],
      ),
    );
  }

  Widget _buildWidgetScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildWeatherWidget()),
                const SizedBox(width: 14),
                Expanded(child: _buildCalendarWidget()),
              ],
            ),
            const SizedBox(height: 14),
            _buildGoogleSearchWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildAppIcon("FaceTime", CupertinoIcons.video_camera_solid, Colors.green),
                  _buildAppIcon("Calendar", CupertinoIcons.calendar, Colors.white),
                  _buildAppIcon("Photos", CupertinoIcons.photo_on_rectangle, Colors.deepOrange),
                  _buildAppIcon("Camera", CupertinoIcons.camera_fill, Colors.grey),
                  _buildAppIcon("Mail", CupertinoIcons.mail_solid, Colors.blue),
                  _buildAppIcon("Notes", CupertinoIcons.pencil_ellipsis_rectangle, Colors.amber),
                  _buildAppIcon("Reminders", CupertinoIcons.list_bullet, Colors.orange),
                  _buildAppIcon("Clock", CupertinoIcons.clock_solid, Colors.black),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppGridScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          children: [
            _buildAppIcon("Apple TV", CupertinoIcons.tv, Colors.black),
            _buildAppIcon("Podcasts", CupertinoIcons.mic_fill, Colors.purple),
            _buildAppIcon("Maps", CupertinoIcons.map_fill, Colors.lightBlue),
            _buildAppIcon("Health", CupertinoIcons.heart_fill, Colors.pink),
            _buildAppIcon("Spotify", CupertinoIcons.music_note, Colors.green),
            _buildAppIcon("Home", CupertinoIcons.home, Colors.orange),
            _buildAppIcon("Books", CupertinoIcons.book_fill, Colors.deepOrangeAccent),
            _buildAppIcon("YouTube", CupertinoIcons.play_rectangle_fill, Colors.red, badge: "2,413"),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLibraryScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  color: Colors.white.withOpacity(0.15),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Text("App Library", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildFolder("Suggestions", [CupertinoIcons.compass, CupertinoIcons.chat_bubble]),
                  _buildFolder("Recently Added", [CupertinoIcons.lock_shield, CupertinoIcons.game_controller]),
                  _buildFolder("Utilities", [CupertinoIcons.settings, CupertinoIcons.wrench]),
                  _buildFolder("Productivity", [CupertinoIcons.doc_text, CupertinoIcons.chart_bar]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      height: 135,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _themeMode == 1 ? Colors.grey[900]?.withOpacity(0.8) : Colors.blue.withOpacity(0.65),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lahore", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Icon(CupertinoIcons.location_fill, color: Colors.white, size: 14),
            ],
          ),
          Text("35°", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300)),
          Text("Mostly Sunny", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCalendarWidget() {
    return Container(
      height: 135,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _themeMode == 1 ? Colors.grey[900]?.withOpacity(0.8) : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("MON", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
          const Text("26", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400)),
          Text("No events today", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGoogleSearchWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.g_mobiledata, color: Colors.white, size: 26),
              SizedBox(width: 4),
              Text("Search...", style: TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
          Row(
            children: [
              _buildPill(CupertinoIcons.mic_fill),
              const SizedBox(width: 8),
              _buildPill(CupertinoIcons.camera_viewfinder),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildAppIcon(String name, IconData icon, Color defaultColor, {String? badge}) {
    Color iconBgColor = defaultColor;
    Color iconColor = Colors.white;

    if (_themeMode == 1) {
      iconBgColor = Colors.grey[900]!;
      iconColor = defaultColor;
    } else if (_themeMode == 3) {
      iconBgColor = _tintColor.withOpacity(0.25);
      iconColor = _tintColor;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            if (_isJiggleMode)
              Positioned(
                top: -6,
                left: -6,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: const Icon(Icons.remove, size: 14, color: Colors.white),
                ),
              )
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Widget _buildFolder(String title, List<IconData> icons) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: icons.map((icon) => Icon(icon, color: Colors.white, size: 26)).toList(),
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCustomizerModal() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(18),
            color: Colors.grey[900]?.withOpacity(0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(CupertinoIcons.sun_max, color: Colors.white),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() {
                        _showCustomizer = false;
                        _isJiggleMode = false;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildThemeChoice(0, "Light", Icons.light_mode),
                    _buildThemeChoice(1, "Dark", Icons.dark_mode),
                    _buildThemeChoice(2, "Automatic", Icons.brightness_auto),
                    _buildThemeChoice(3, "Tinted", Icons.colorize),
                  ],
                ),
                if (_themeMode == 3) ...[
                  const SizedBox(height: 12),
                  Slider(
                    value: _tintColor.hue,
                    min: 0.0,
                    max: 360.0,
                    onChanged: (val) {
                      setState(() {
                        _tintColor = HSVColor.fromAHSV(1.0, val, 0.8, 0.9).toColor();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChoice(int index, String label, IconData icon) {
    bool isSelected = _themeMode == index;
    return GestureDetector(
      onTap: () => setState(() => _themeMode = index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white24 : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildControlCenter() {
    return Positioned.fill(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Control Center", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => setState(() => _showControlCenter = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GridView.count(
                            crossAxisCount: 2,
                            children: const [
                              Icon(Icons.airplanemode_active, color: Colors.white),
                              Icon(Icons.wifi, color: Colors.blueAccent),
                              Icon(Icons.bluetooth, color: Colors.blueAccent),
                              Icon(Icons.signal_cellular_alt, color: Colors.greenAccent),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(CupertinoIcons.music_note, color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
