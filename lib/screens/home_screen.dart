import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchInitialDataIfNeeded();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(prov.city.isNotEmpty ? prov.city : 'Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () => Navigator.pushNamed(context, '/cities'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: prov.loading ? null : prov.refreshSelectedCity,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Weather App",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Selected: ${prov.selectedCity ?? prov.city}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text("Cities"),
              onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("3-Day Forecast"),
              onTap: () => Navigator.pushReplacementNamed(
                context,
                '/forecast3days',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text("Hourly Forecast"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/hourly'),
            ),
          ],
        ),
      ),
      body: Center(
        child: prov.loading
            ? const CircularProgressIndicator()
            : prov.error != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${prov.error}'),
              )
            : RefreshIndicator(
                onRefresh: prov.refreshSelectedCity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _cityController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: "Enter city (e.g. Cairo, London)",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                final query = _cityController.text.trim();
                                if (query.isEmpty) return;
                                await prov.fetchWeather(query);
                                if (!mounted) return;
                                // ignore: use_build_context_synchronously
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onSubmitted: (value) async {
                            final query = value.trim();
                            if (query.isEmpty) return;
                            await prov.fetchWeather(query);
                          },
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                prov.city,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (prov.iconUrl != null)
                                Image.network(
                                  prov.iconUrl!,
                                  width: 120,
                                  height: 120,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox(height: 120),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                prov.tempC != null
                                    ? '${prov.tempC!.toStringAsFixed(1)} °C'
                                    : '--',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                prov.condition ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: prov.isLoading
                                    ? null
                                    : prov.loadWeatherByGPS,
                                icon: const Icon(Icons.my_location),
                                label: const Text("Use my location"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cities');
                                },
                                icon: const Icon(Icons.list_alt),
                                label: const Text("Choose city"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forecast3days');
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('3-day Forecast'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/hourly');
                                },
                                icon: const Icon(Icons.schedule),
                                label: const Text('Hourly Forecast'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (prov.isLoading || prov.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            prov.isLoading
                                ? "Loading weather for your location..."
                                : prov.errorMessage ?? '',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
