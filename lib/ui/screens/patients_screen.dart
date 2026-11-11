import 'package:doctor_on_duty/app/app_router.dart';
import 'package:doctor_on_duty/business/patients.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/ui/enhanced_case_tile.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';
import 'package:doctor_on_duty/ui/widgets/liquid_canvas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String _search = '';
  String _sort = 'recent';
  final Set<int> _favorites = {};

  @override
  Widget build(BuildContext context) {
    return LiquidScaffold(
      appBar: AppBar(
        title: const Text('Cases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openRoute(context, AppRoutes.addPatient),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(context),
          Expanded(child: _buildFilteredCasesList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.12
                  : 0.45,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search name, Hx, O/E…',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _search = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('sort_$_sort'),
            initialValue: _sort,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Sort',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'recent', child: Text('Recent')),
              DropdownMenuItem(value: 'name', child: Text('Name')),
            ],
            onChanged: (value) => setState(() => _sort = value ?? 'recent'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredCasesList(BuildContext context) {
    final all = context.watch<PatientsController>().patients;
    final filtered = _getFilteredAndSortedCases(all);

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No cases found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final caze = filtered[index];
        final isFavorite = _favorites.contains(caze.id);

        return EnhancedCaseTile(
          caze: caze,
          isFavorite: isFavorite,
          onTap: () => openRoute(
            context,
            AppRoutes.patientDetails,
            arguments: caze.id,
          ),
          onFavoriteToggle: () {
            setState(() {
              if (isFavorite) {
                _favorites.remove(caze.id);
              } else {
                _favorites.add(caze.id);
              }
            });
          },
        );
      },
    );
  }

  List<Patient> _getFilteredAndSortedCases(List<Patient> cases) {
    var result = List<Patient>.from(cases);

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result.where((c) {
        return c.patientName.toLowerCase().contains(q) ||
            c.complaint.toLowerCase().contains(q) ||
            c.history.toLowerCase().contains(q) ||
            c.examination.toLowerCase().contains(q) ||
            c.managementDocument.toLowerCase().contains(q) ||
            c.legalReference.toLowerCase().contains(q);
      }).toList();
    }

    if (_sort == 'name') {
      result.sort(
        (a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
      );
    } else {
      result.sort((a, b) => b.arrivedAt.compareTo(a.arrivedAt));
    }

    return result;
  }
}
