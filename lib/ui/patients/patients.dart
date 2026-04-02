import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/domain/models/patient_file.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/patients/enhanced_case_tile.dart';
import 'package:doctor_on_duty/ui/medical_case_details.dart';
import 'package:doctor_on_duty/ui/add_case_dialog.dart';
import 'package:doctor_on_duty/ui/ui.dart';

// State management for case filters and sorting
final caseSearchRM = RM.inject(() => '');
final caseFilterRM = RM.inject(() => 'all'); // all, opd, emergency
final caseSortRM = RM.inject(() => 'recent'); // recent, name
final caseFavoritesRM = RM.inject(() => <int>[]);

class PatientsScreen extends UI {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              apply(
                ShowDialog((_, _, _) => const AddPatientDialog()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context),
          // Case List
          Expanded(
            child: _buildFilteredCasesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search cases...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => caseSearchRM.state = value,
          ),
          const SizedBox(height: 12),

          // Filter and Sort Options
          Row(
            children: [
              // Type Filter
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: caseFilterRM.state,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.filter_list),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All', style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'opd',
                      child: Text('OPD', style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'emergency',
                      child: Text('Emergency', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  onChanged: (value) => caseFilterRM.state = value!,
                ),
              ),
              const SizedBox(width: 8),

              // Sort Options
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: caseSortRM.state,
                  decoration: const InputDecoration(
                    labelText: 'Sort',
                    prefixIcon: Icon(Icons.sort),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'recent',
                      child: Text('Recent', style: TextStyle(fontSize: 12)),
                    ),
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Name', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  onChanged: (value) => caseSortRM.state = value!,
                ),
              ),

              // Favorites Toggle
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  // Toggle favorites filter
                  caseFilterRM.state = caseFilterRM.state == 'favorites'
                      ? 'all'
                      : 'favorites';
                },
                icon: Icon(
                  Icons.favorite,
                  color: caseFilterRM.state == 'favorites'
                      ? Colors.red
                      : Colors.grey,
                  size: 20,
                ),
                tooltip: 'Show Favorites',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredCasesList(BuildContext context) {
    // Get filtered and sorted cases
    List<Patient> filteredCases = _getFilteredAndSortedCases();

    if (filteredCases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No cases found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredCases.length,
      itemBuilder: (context, index) {
        final caze = filteredCases[index];
        final isFavorite = caseFavoritesRM.state.contains(caze.id);

        return EnhancedCaseTile(
          caze: caze,
          isFavorite: isFavorite,
          onTap: () => apply(
            NavigateTo((context) => PatientDetailsScreen(patientId: caze.id)),
          ),
          onFavoriteToggle: () {
            final favorites = List<int>.from(caseFavoritesRM.state);
            if (isFavorite) {
              favorites.remove(caze.id);
            } else {
              favorites.add(caze.id);
            }
            caseFavoritesRM.state = favorites;
          },
        );
      },
    );
  }

  List<Patient> _getFilteredAndSortedCases() {
    List<Patient> cases = state.patients.patients;

    // Apply type filter
    if (caseFilterRM.state == 'opd') {
      cases = cases.where((c) => c.type == 'opd').toList();
    } else if (caseFilterRM.state == 'emergency') {
      cases = cases.where((c) => c.type == 'emergency').toList();
    } else if (caseFilterRM.state == 'favorites') {
      cases = cases.where((c) => caseFavoritesRM.state.contains(c.id)).toList();
    }

    // Apply search filter
    if (caseSearchRM.state.isNotEmpty) {
      final searchQuery = caseSearchRM.state.toLowerCase();
      cases = cases.where((c) {
        return c.patientName.toLowerCase().contains(searchQuery) ||
            c.symptoms.toLowerCase().contains(searchQuery) ||
            c.provisionalDiagnosis.toLowerCase().contains(searchQuery) ||
            c.treatmentPlan.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Apply sorting
    if (caseSortRM.state == 'name') {
      cases.sort(
        (a, b) =>
            a.patientName.toLowerCase().compareTo(b.patientName.toLowerCase()),
      );
    } else {
      // Sort by ID (assuming higher IDs are more recent)
      cases.sort((a, b) => b.id.compareTo(a.id));
    }

    return cases;
  }
}
