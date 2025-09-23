import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/evaluation.dart';
import '../widgets/evaluation_item.dart';
import '../widgets/new_evaluation_modal.dart';

class EvaluationsScreen extends StatefulWidget {
  const EvaluationsScreen({super.key});

  @override
  State<EvaluationsScreen> createState() => _EvaluationsScreenState();
}

class _EvaluationsScreenState extends State<EvaluationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Evaluation> _evaluations = [];
  FilterType _currentFilter = FilterType.todas;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialEvaluations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialEvaluations() {
    final now = DateTime.now();
    _evaluations = [
      Evaluation(
        id: '1',
        titulo: 'Examen Final Matemáticas',
        nota: 'Incluye cálculo diferencial e integral',
        fechaEntrega: now.add(const Duration(days: 7)),
        isDone: false,
      ),
      Evaluation(
        id: '2',
        titulo: 'Proyecto Programación',
        nota: 'Desarrollo de aplicación móvil',
        fechaEntrega: now.add(const Duration(days: 14)),
        isDone: true,
      ),
      Evaluation(
        id: '3',
        titulo: 'Ensayo Historia',
        nota: 'Análisis del siglo XX',
        fechaEntrega: now.subtract(const Duration(days: 2)),
        isDone: false,
      ),
      Evaluation(
        id: '4',
        titulo: 'Laboratorio Física',
        nota: 'Experimento de ondas sonoras',
        fechaEntrega: now.add(const Duration(days: 3)),
        isDone: false,
      ),
      Evaluation(
        id: '5',
        titulo: 'Presentación Inglés',
        nota: 'Tema: Tecnología moderna',
        fechaEntrega: now.add(const Duration(days: 10)),
        isDone: true,
      ),
    ];
    setState(() {});
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Evaluation> get _filteredEvaluations {
    List<Evaluation> filtered = _evaluations;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((evaluation) {
        final titulo = evaluation.titulo.toLowerCase();
        final nota = evaluation.nota?.toLowerCase() ?? '';
        return titulo.contains(_searchQuery) || nota.contains(_searchQuery);
      }).toList();
    }

    switch (_currentFilter) {
      case FilterType.pendientes:
        filtered = filtered.where((e) => e.status == EvaluationStatus.pendiente).toList();
        break;
      case FilterType.completas:
        filtered = filtered.where((e) => e.status == EvaluationStatus.completada).toList();
        break;
      case FilterType.todas:
        break;
    }

    filtered.sort((a, b) {
      if (a.fechaEntrega == null && b.fechaEntrega == null) return 0;
      if (a.fechaEntrega == null) return 1;
      if (b.fechaEntrega == null) return -1;
      return a.fechaEntrega!.compareTo(b.fechaEntrega!);
    });

    return filtered;
  }

  void _toggleEvaluationStatus(String id) {
    setState(() {
      final index = _evaluations.indexWhere((e) => e.id == id);
      if (index != -1) {
        _evaluations[index] = _evaluations[index].copyWith(
          isDone: !_evaluations[index].isDone,
        );
      }
    });
  }

  void _deleteEvaluation(String id) {
    final evaluation = _evaluations.firstWhere((e) => e.id == id);
    
    setState(() {
      _evaluations.removeWhere((e) => e.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Evaluación "${evaluation.titulo}" eliminada'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              _evaluations.add(evaluation);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _addEvaluation(Evaluation evaluation) {
    setState(() {
      _evaluations.add(evaluation);
    });
  }

  void _showNewEvaluationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => NewEvaluationModal(
        onEvaluationCreated: _addEvaluation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvaluations = _filteredEvaluations;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Evaluaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE53E3E),
        elevation: 4,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar evaluaciones...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: FilterType.values.map((filter) {
                final isSelected = _currentFilter == filter;
                String label;
                switch (filter) {
                  case FilterType.todas:
                    label = 'Todas';
                    break;
                  case FilterType.pendientes:
                    label = 'Pendientes';
                    break;
                  case FilterType.completas:
                    label = 'Completas';
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _currentFilter = filter;
                      });
                    },
                    selectedColor: const Color(0xFFE53E3E).withOpacity(0.2),
                    checkmarkColor: const Color(0xFFE53E3E),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: filteredEvaluations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No se encontraron evaluaciones'
                              : 'No hay evaluaciones disponibles',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEvaluations.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final evaluation = filteredEvaluations[index];
                      return EvaluationItem(
                        evaluation: evaluation,
                        onToggleStatus: () => _toggleEvaluationStatus(evaluation.id),
                        onDelete: () => _deleteEvaluation(evaluation.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewEvaluationModal,
        backgroundColor: const Color(0xFFE53E3E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}
