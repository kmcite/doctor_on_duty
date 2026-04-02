import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/ui/ui.dart';

final searchQueryRM = RM.inject(() => '');
final searchTypeRM = RM.inject(() => SearchType.all);

enum SearchType {
  all,
  symptom,
  diagnosis
  ;

  String get displayName => switch (this) {
    SearchType.all => 'All',
    SearchType.symptom => 'Symptoms',
    SearchType.diagnosis => 'Diagnoses',
  };

  IconData get icon => switch (this) {
    SearchType.all => Icons.search,
    SearchType.symptom => Icons.medical_information,
    SearchType.diagnosis => Icons.health_and_safety,
  };

  bool isIt(SearchType type) => type == this;
}

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final IconData icon;
  final dynamic data;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.data,
  });
}

List<SearchResult> get searchResults {
  final query = searchQueryRM.state.toLowerCase().trim();
  if (query.isEmpty) return [];

  // Handle waiting states
  // if (symptoms.loading || diagnoses.loading) return [];

  final results = <SearchResult>[];
  final searchType = searchTypeRM.state;

  if (searchType.isIt(.all) || searchType.isIt(.symptom)) {
    // try {
    //   for (final symptom in symptoms.items) {
    //     if (_matchesQuery(symptom.name, query) ||
    //         _matchesQuery(symptom.description, query) ||
    //         _matchesQuery(symptom.differentials, query)) {
    //       results.add(
    //         SearchResult(
    //           id: 'symptom_${symptom.id}',
    //           title: symptom.name,
    //           subtitle: symptom.description.isNotEmpty
    //               ? symptom.description
    //               : 'Symptom details',
    //           type: 'Symptom',
    //           icon: Icons.medical_information,
    //           data: symptom,
    //         ),
    //       );
    //     }
    //   }
    // } catch (e) {
    //   // Handle case where symptoms repository is not ready
    // }
  }

  results.sort((a, b) => a.title.compareTo(b.title));
  return results;
}

class UnifiedSearchPage extends UI {
  const UnifiedSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => apply(NavigateBack()),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => searchQueryRM.state = value,
                  decoration: InputDecoration(
                    labelText: 'Search symptoms, diagnoses...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQueryRM.state.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => searchQueryRM.state = '',
                          )
                        : null,
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SearchType.values.map((type) {
                      final isSelected = searchTypeRM.state.isIt(type);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type.displayName),
                          avatar: Icon(type.icon, size: 18),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) searchTypeRM.state = type;
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final query = searchQueryRM.state;
    final results = searchResults;

    if (query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for symptoms or diagnoses',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // if (symptoms.loading || diagnoses.loading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No results for "$query"',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or search filters',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
              child: Icon(result.icon, color: Theme.of(context).primaryColor),
            ),
            title: Text(
              result.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.type,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => _handleResultTap(result),
          ),
        );
      },
    );
  }

  void _handleResultTap(SearchResult result) {
    switch (result.type) {
      case 'Symptom':
        _showComingSoonDialog(
          'Symptom Details',
          'Symptom detail page is coming soon!',
        );
        break;
      case 'Diagnosis':
        _showComingSoonDialog(
          'Diagnosis Details',
          'Diagnosis detail page is coming soon!',
        );
        break;
    }
  }

  void _showComingSoonDialog(String title, String message) {
    apply(
      ShowDialog(
        (_, _, _) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => apply(NavigateBack()),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
