import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
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
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.errorMessage != null) {
            return Center(child: Text(_viewModel.errorMessage!));
          }
          final items = _viewModel.forecast.take(5).toList();
          if (items.isEmpty) {
            return const Center(child: Text('No forecast data'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
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
