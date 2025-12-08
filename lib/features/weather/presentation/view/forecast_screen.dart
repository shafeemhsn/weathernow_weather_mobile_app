import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../router/app_router.dart';
import '../../../favourites/data/repository/favourites_repository_impl.dart';
import '../../../favourites/data/sources/favourites_local_source.dart';
import '../../../favourites/domain/usecases/add_favourite.dart';
import '../../../favourites/domain/usecases/get_favourites.dart';
import '../../../favourites/domain/usecases/is_favourite.dart';
import '../../../favourites/domain/usecases/remove_favourite.dart';
import '../../../favourites/presentation/viewmodel/favourites_viewmodel.dart';
import '../../data/repository/weather_repository_impl.dart';
import '../../data/sources/weather_api_service.dart';
import '../../domain/entities/forecast_day_entity.dart';
import '../../domain/usecases/get_forecast_by_city.dart';
import '../viewmodel/forecast_viewmodel.dart';
import '../widgets/city_not_found_card.dart';
import '../widgets/forecast_day_card.dart';

class ForecastScreen extends StatefulWidget {
  final String? city;

  const ForecastScreen({super.key, this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late final ForecastViewModel _viewModel;
  late final WeatherRepositoryImpl _repository;
  String? _headerLocation;
  bool _isFavourite = false;
  late final FavouritesViewModel _favouritesViewModel;

  @override
  void initState() {
    super.initState();
    _repository = WeatherRepositoryImpl(WeatherApiService(DioClient()));
    _viewModel = ForecastViewModel(GetForecastByCity(_repository));
    final favRepo = FavouritesRepositoryImpl(FavouritesLocalSource());
    _favouritesViewModel = FavouritesViewModel(
      GetFavourites(favRepo),
      AddFavourite(favRepo),
      RemoveFavourite(favRepo),
      IsFavourite(favRepo),
    );
    _load();
  }

  Future<void> _load() async {
    final city = widget.city;
    if (city != null && city.isNotEmpty) {
      await _viewModel.load(city);
      if (_viewModel.errorMessage != null) {
        if (mounted) setState(() => _headerLocation = null);
        return;
      }
      final current = await _repository.getWeatherByCity(city);
      if (!mounted) return;
      setState(() {
        _headerLocation = '${current.cityName}, ${current.country}';
      });
      _isFavourite = await _favouritesViewModel.isFavourite(current.cityName);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleCity = widget.city ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            if (_viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_viewModel.errorMessage != null) {
              final message = _viewModel.errorMessage!;
              if (_isCityNotFound(message)) {
                return CityNotFoundCard(
                  city: widget.city,
                  onSearchAgain: _goBackToSearch,
                );
              }
              return ErrorStateWidget(message: message, onRetry: _load);
            }
            final items = _viewModel.forecast.take(5).toList();
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
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(
              AppRouter.weather,
              arguments: widget.city != null ? {'city': widget.city} : null,
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          } else if (index == 4) {
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
    if (_isFavourite) {
      await _favouritesViewModel.remove(city);
    } else {
      await _favouritesViewModel.add(city);
    }
    _isFavourite = await _favouritesViewModel.isFavourite(city);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _favouritesViewModel.dispose();
    super.dispose();
  }
}
