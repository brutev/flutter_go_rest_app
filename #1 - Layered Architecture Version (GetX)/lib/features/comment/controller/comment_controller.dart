import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../common/controller/base_controller.dart';
import '../data/model/comment.dart';
import '../data/provider/remote/comment_api.dart';

class CommentController extends GetxController with StateMixin<List<Comment>>, BaseController {

  Rx<Either<String, List<Comment>>>? comments;

  final CommentApi commentApi = CommentApi();

  void createComment(Comment comment) {
    createItem(commentApi.createComment(comment));
  }

  void deleteComment(Comment comment) {
    deleteItem(commentApi.deleteComment(comment));
  }

  Future<void> getUserComments(int postId) async {

    change(null, status: RxStatus.loading());

    comments = (await commentApi.getUserComments(postId)).obs;

    comments?.value.fold(
      (String failure) {
        change(null, status: RxStatus.error(failure));
      },
      (List<Comment> comments) {
        if (comments.isEmpty) {
          change(null, status: RxStatus.empty());
          return true;
        } else {
          change(comments, status: RxStatus.success());
        }
      },
    );
  }
}
