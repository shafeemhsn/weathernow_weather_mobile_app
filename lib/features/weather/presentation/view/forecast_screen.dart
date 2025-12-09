import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/forecast_day_entity.dart';
import '../widgets/city_not_found_card.dart';
import '../widgets/forecast_day_card.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  final String? city;

  const ForecastScreen({super.key, this.city});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  String? _headerLocation;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final viewModel = ref.read(forecastViewModelProvider);
    final repository = ref.read(weatherRepositoryProvider);
    final city = widget.city;
    if (city != null && city.isNotEmpty) {
      await viewModel.load(city);
      if (viewModel.errorMessage != null) {
        if (mounted) setState(() => _headerLocation = null);
        return;
      }
      final current = await repository.getWeatherByCity(city);
      if (!mounted) return;
      setState(() {
        _headerLocation = '${current.cityName}, ${current.country}';
      });
      _isFavourite = await ref.read(favouritesViewModelProvider).isFavourite(current.cityName);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(forecastViewModelProvider);
    final titleCity = widget.city ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToSearch,
        ),
        title: Text('Forecast: ${_headerLocation ?? titleCity}'),
        actions: [
          IconButton(
            icon: Icon(_isFavourite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavourite,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F8FF), Color(0xFFEAF1FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewModel.errorMessage != null
                ? _buildError(viewModel.errorMessage!)
                : _buildList(viewModel.forecast),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }

  bool _isCityNotFound(String? message) {
    if (message == null) return false;
    final lower = message.toLowerCase();
    return lower.contains('city not found') || lower.contains('404');
  }

  void _goBackToSearch() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRouter.home);
    }
  }

  String _formatDate(ForecastDayEntity day) {
    return DateFormatter.formatShort(day.date);
  }

  Future<void> _toggleFavourite() async {
    final city = widget.city;
    if (city == null || city.isEmpty) return;
    final target = !_isFavourite;
    if (mounted) {
      setState(() {
        _isFavourite = target;
      });
    }
    if (target) {
      await ref.read(favouritesViewModelProvider).add(city);
    } else {
      await ref.read(favouritesViewModelProvider).remove(city);
    }
    final persisted = await ref.read(favouritesViewModelProvider).isFavourite(city);
    if (mounted) {
      setState(() {
        _isFavourite = persisted;
      });
    }
  }

  Widget _buildError(String message) {
    if (_isCityNotFound(message)) {
      return CityNotFoundCard(
        city: widget.city,
        onSearchAgain: _goBackToSearch,
      );
    }
    return ErrorStateWidget(message: message, onRetry: _load);
  }

  Widget _buildList(List<ForecastDayEntity> forecast) {
    final items = forecast.take(5).toList();
    if (items.isEmpty) {
      return const Center(child: Text('No forecast data'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final day = items[index];
        return ForecastDayCard(
          dateLabel: _formatDate(day),
          high: day.tempMax,
          low: day.tempMin,
          description: day.description,
          iconCode: day.icon,
        );
      },
    );
  }
}
