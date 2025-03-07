import 'package:clean_architecture_bloc/common/network/api_result.dart';
import 'package:clean_architecture_bloc/common/usecase/usecase.dart';
import 'package:clean_architecture_bloc/features/post/data/models/post.dart';
import 'package:clean_architecture_bloc/features/post/domain/repositories/post_repository.dart';
import 'package:clean_architecture_bloc/features/user/data/models/user.dart';

class GetPostsUseCase implements UseCase<List<Post>, GetPostsParams> {
  final PostRepository postRepository;

  const GetPostsUseCase(this.postRepository);

  @override
  Future<ApiResult<List<Post>>> call(GetPostsParams params) async {
    return await postRepository.getPosts(params.user);
  }
}

class GetPostsParams {
  final User user;

  GetPostsParams({required this.user});
}
