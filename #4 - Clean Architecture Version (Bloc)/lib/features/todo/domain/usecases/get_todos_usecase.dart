import 'package:clean_architecture_bloc/common/network/api_result.dart';
import 'package:clean_architecture_bloc/common/usecase/usecase.dart';
import 'package:clean_architecture_bloc/features/todo/data/models/todo.dart';
import 'package:clean_architecture_bloc/features/todo/domain/entities/todo_entity.dart';
import 'package:clean_architecture_bloc/features/todo/domain/repositories/todo_repository.dart';

class GetTodoUseCase implements UseCase<List<ToDo>, GetTodoParams> {
  final TodoRepository todoRepository;

  GetTodoUseCase(this.todoRepository);

  @override
  Future<ApiResult<List<ToDo>>> call(GetTodoParams params) async {
    return await todoRepository.getTodos(params.userId, status: params.status);
  }
}

class GetTodoParams {
  int userId;
  TodoStatus? status;

  GetTodoParams({required this.userId, this.status});
}
