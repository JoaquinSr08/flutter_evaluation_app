import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/evaluation.dart';

class EvaluationItem extends StatelessWidget {
  final Evaluation evaluation;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const EvaluationItem({
    super.key,
    required this.evaluation,
    required this.onToggleStatus,
    required this.onDelete,
  });

  Color _getStatusColor() {
    switch (evaluation.status) {
      case EvaluationStatus.completada:
        return Colors.green;
      case EvaluationStatus.vencida:
        return Colors.red;
      case EvaluationStatus.pendiente:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    switch (evaluation.status) {
      case EvaluationStatus.completada:
        return 'Completada';
      case EvaluationStatus.vencida:
        return 'Vencida';
      case EvaluationStatus.pendiente:
        return 'Pendiente';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(evaluation.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: evaluation.isDone,
                onChanged: (_) => onToggleStatus(),
                activeColor: const Color(0xFFE53E3E),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evaluation.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: evaluation.isDone 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                        color: evaluation.isDone 
                            ? Colors.grey[600] 
                            : Colors.black87,
                      ),
                    ),
                    
                    if (evaluation.nota != null && evaluation.nota!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        evaluation.nota!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: evaluation.isDone 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        if (evaluation.fechaEntrega != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(evaluation.fechaEntrega!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor().withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Botón de eliminar
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.grey[400],
                onPressed: onDelete,
                tooltip: 'Eliminar evaluación',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
