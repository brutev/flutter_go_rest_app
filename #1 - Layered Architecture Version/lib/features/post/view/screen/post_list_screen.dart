import 'package:layered_architecture/core/app_extension.dart';
import 'package:layered_architecture/features/post/view/screen/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/controller/api_operation.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/empty_widget.dart';
import '../../../../common/widget/spinkit_indicator.dart';
import '../../../user/data/model/user.dart';
import '../../controller/post_controller.dart';
import '../../data/model/post.dart';
import 'create_post_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final PostController postController;

  @override
  void initState() {
    postController = Get.put(PostController());
    getData();
    super.initState();
  }

  getData() async {
    await postController.getPosts(widget.user);
  }

  PreferredSizeWidget get appBar {
    return AppBar(
      title: const Text("Posts"),
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      actions: [
        IconButton(
          onPressed: () async => getData(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }

  Widget floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.note_add),
      label: const Text("Create a new post"),
      onPressed: () async {
        var resultFromCreatePostScreen = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return CreatePostScreen(user: widget.user);
            },
          ),
        );
        if (resultFromCreatePostScreen != null && resultFromCreatePostScreen) {
          postController.getPosts(widget.user);
        }
      },
    );
  }

  Widget get header {
    return Card(
      child: Row(
        children: [
          Image.asset(widget.user.gender.name.getGenderWidget, height: 75),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                Obx(
                  () {
                    return Text(
                      "Posts :${postController.postLength}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  void deletePost(Post post) {
    postController.deletePost(post);
    showDialog(
      context: context,
      builder: (_) {
        return Obx(
          () {
            switch (postController.apiStatus.value) {
              case ApiState.loading:
                return const ProgressDialog(
                    title: "Deleting post...", isProgressed: true);
              case ApiState.success:
                return ProgressDialog(
                    title: "successfully deleted",
                    onPressed: () {
                      postController.getPosts(widget.user);
                      Navigator.pop(context);
                    },
                    isProgressed: false);
              case ApiState.failure:
                return RetryDialog(
                  title: postController.errorMessage.value,
                  onRetryPressed: () => postController.deletePost(post),
                );
            }
          },
        );
      },
    );
  }

  Widget userPostItem(List<Post> posts) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (_, index) {
          Post post = posts[index];
          return Dismissible(
            key: Key("$index"),
            onDismissed: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                deletePost(post);
              }

              if (direction == DismissDirection.endToStart) {
                var resultFromCreatePostScreen = await Navigator.push(
                  _,
                  MaterialPageRoute(
                    builder: (_) {
                      return CreatePostScreen(
                          user: widget.user, post: post, mode: PostMode.update);
                    },
                  ),
                );
                if (resultFromCreatePostScreen != null &&
                    resultFromCreatePostScreen) {
                  postController.getPosts(widget.user);
                }
              }
            },
            background: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
            secondaryBackground: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    _,
                    MaterialPageRoute(
                      builder: (_) {
                        return PostDetailScreen(post: post);
                      },
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(post.body,
                                  maxLines: 3, overflow: TextOverflow.ellipsis)
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_sharp)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(context),
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              "Posts",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ),
          postController.obx(
            (state) => userPostItem(state!),
            onLoading: const Center(child: SpinKitIndicator()),
            onError: (error) => RetryDialog(
                title: "$error",
                onRetryPressed: () => postController.getPosts(widget.user)),
            onEmpty: const EmptyWidget(message: "No post"),
          ),
        ],
      ),
    );
  }
}
