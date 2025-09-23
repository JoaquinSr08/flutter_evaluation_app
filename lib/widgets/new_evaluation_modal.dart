import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/evaluation.dart';

class NewEvaluationModal extends StatefulWidget {
  final Function(Evaluation) onEvaluationCreated;

  const NewEvaluationModal({
    super.key,
    required this.onEvaluationCreated,
  });

  @override
  State<NewEvaluationModal> createState() => _NewEvaluationModalState();
}

class _NewEvaluationModalState extends State<NewEvaluationModal> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _notaController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _tituloController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFFE53E3E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _createEvaluation() {
    if (_formKey.currentState!.validate()) {
      final evaluation = Evaluation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text.trim(),
        nota: _notaController.text.trim().isEmpty 
            ? null 
            : _notaController.text.trim(),
        fechaEntrega: _selectedDate,
        isDone: false,
      );

      widget.onEvaluationCreated(evaluation);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Evaluación "${evaluation.titulo}" creada exitosamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.add_task,
                    color: Color(0xFFE53E3E),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Nueva Evaluación',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título *',
                  hintText: 'Ingrese el título de la evaluación',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE53E3E),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _notaController,
                decoration: InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Detalles adicionales (opcional)',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE53E3E),
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Fecha de entrega (opcional)'
                            : 'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null 
                              ? Colors.grey[600] 
                              : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFFE53E3E)),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFFE53E3E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Crear',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
