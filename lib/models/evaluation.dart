class Evaluation {
    final String id;
    final String titulo;
    final String? nota;
    final DateTime? fechaEntrega;
    bool isDone;

    Evaluation({
        required this.id,
        required this.titulo,
        this.nota,
        this.fechaEntrega,
        this.isDone = false,
    });

    EvaluationStatus get status {
        if (isDone) return EvaluationStatus.completada;

        if (fechaEntrega != null){
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final entrega = DateTime(fechaEntrega!.year, fechaEntrega!.month, fechaEntrega!.day);

            if(entrega.isBefore(today)){
                return EvaluationStatus.vencida;
            }
        }

        return EvaluationStatus.pendiente;
    }

    Evaluation copyWith({
        String? id,
        String? titulo,
        String? nota,
        DateTime? fechaEntrega,
        bool? isDone,
    }){
        return Evaluation(
            id: id ?? this.id,
            titulo: titulo ?? this.titulo,
            nota: nota ?? this.nota,
            fechaEntrega: fechaEntrega ?? this.fechaEntrega,
            isDone: isDone ?? this.isDone,
        );
    }
}

enum EvaluationStatus{
    pendiente,
    completada,
    vencida,
}

enum FilterType{
    todas,
    pendientes,
    completas,
}