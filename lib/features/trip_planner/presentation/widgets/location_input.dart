import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../../../metro_data/domain/entities/station.dart';
import '../../../metro_data/presentation/providers/metro_provider.dart';

class LocationInput extends ConsumerStatefulWidget {
  final String label;
  final String? selectedStationName;
  final ValueChanged<Station> onStationSelected;
  final VoidCallback? onUseMyLocation;

  const LocationInput({
    super.key,
    required this.label,
    this.selectedStationName,
    required this.onStationSelected,
    this.onUseMyLocation,
  });

  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Station> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedStationName != null) {
      _controller.text = widget.selectedStationName!;
    }
  }

  @override
  void didUpdateWidget(LocationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStationName != oldWidget.selectedStationName &&
        widget.selectedStationName != null) {
      _controller.text = widget.selectedStationName!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final repo = ref.read(metroRepositoryProvider);
    final results = await repo.searchStations(query);
    setState(() {
      _suggestions = results;
      _showSuggestions = results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.search,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.onUseMyLocation != null
                ? IconButton(
                    icon: const Icon(Icons.my_location),
                    tooltip: l10n.useMyLocation,
                    onPressed: () {
                      widget.onUseMyLocation?.call();
                      _focusNode.unfocus();
                      setState(() => _showSuggestions = false);
                    },
                  )
                : null,
          ),
          onChanged: _search,
        ),
        if (_showSuggestions)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final station = _suggestions[index];
                final locale = Localizations.localeOf(context);
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.train, size: 18),
                  title: Text(station.localizedName(locale.languageCode)),
                  subtitle: Text(
                    station.localizedName(
                        locale.languageCode == 'ar' ? 'en' : 'ar'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    _controller.text =
                        station.localizedName(locale.languageCode);
                    widget.onStationSelected(station);
                    setState(() => _showSuggestions = false);
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
