import 'package:dartz/dartz.dart';

import '../../../../common/usecase/usecase.dart';
import '../../data/models/todo.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodoUseCase implements UseCase<List<ToDo>, GetTodoParams> {
  final TodoRepository todoRepository;

  GetTodoUseCase(this.todoRepository);

  @override
  Future<Either<String, List<ToDo>>> call(GetTodoParams params) async {
    return await todoRepository.getTodos(params.userId, status: params.status);
  }
}

class GetTodoParams {
  int userId;
  TodoStatus? status;

  GetTodoParams({required this.userId, this.status});
}