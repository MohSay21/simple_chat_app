import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/providers/users.dart';
import 'package:chat_app/providers/receiver.dart';
import 'package:chat_app/services/firestore_db.dart';
import 'package:chat_app/ui/widgets/user_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/ui/widgets/loading.dart';
import 'package:chat_app/services/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeV extends ConsumerWidget {

  final _auth = FirebaseAuth.instance;

  HomeV({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedInEmail = ref.watch(myUserP).email.isEmpty
        ? _auth.currentUser!.email!
        : ref.watch(myUserP).email;
    final user = ref.watch(getUserP(signedInEmail));
    return Scaffold(
      appBar: _myAppBar(context),
      drawer: _myDrawer(context, ref, user),
      body: _myBody(context, ref, user),
    );
  }

  AppBar _myAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        'Chat App',
        style: GoogleFonts.alegreyaSans(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      foregroundColor: theme.colorScheme.secondary,
      backgroundColor: mainColor,
    );
  }

  Widget _myDrawer(BuildContext context, WidgetRef ref, AsyncValue<MyUser> futureUser) {
    final firestoreDB = FirestoreDB();
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Drawer(
      child: Center(
        child: futureUser.when(
          loading: () => loading(),
          error: (ex, stack) => Text(ex.toString()),
          data: (user) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.08),
                      CircleAvatar(
                        radius: size.width / 6 + 4,
                        backgroundColor: mainColor,
                        child: userImage(size.width / 3, user.image),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(myUserP.notifier).changeUser(
                            name: user.name,
                            email: user.email,
                            image: user.image,
                          );
                          Navigator.of(context).pushNamed('/edit');
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          primary: mainColor,
                          fixedSize: Size(size.width / 2.5, size.height / 15),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width / 12),
                        child: const Divider(),
                      ),
                      SizedBox(height: size.height * 0.05),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                          fixedSize: Size(size.width / 2, size.height / 15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.settings, color: theme.colorScheme.secondary,),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                          fixedSize: Size(size.width / 2, size.height / 15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rate us',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.star, color: theme.colorScheme.secondary,),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextButton(
                        onPressed: () async {
                          ref.read(myUserP.notifier).changeUser(
                            name: '',
                            email: '',
                            image: '',
                          );
                          await _auth.signOut();
                        },
                        child: Text(
                          'Sign-out',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: theme.colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                'Delete account',
                              ),
                              content: const Text(
                                'Are you sure you want to delete this account permanently?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: mainColor,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    ref.read(myUserP.notifier).changeUser(
                                      name: '',
                                      email: '',
                                      image: '',
                                    );
                                    await firestoreDB.deleteUser(user.email);
                                    await _auth.currentUser!.delete();
                                    await _auth.signOut();
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                              backgroundColor: theme.scaffoldBackgroundColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            barrierDismissible: false,
                          );
                        },
                        child: Text(
                          'Delete account',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: theme.colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                      const Text(
                        'V. 1.0.0',
                      ),
                    ],
            ),
        ),
        ),
    );
  }

  Widget _myBody(BuildContext context, WidgetRef ref, AsyncValue<MyUser> futureUser) {
    final streamUsers = ref.watch(usersP);
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(size.width / 10),
              bottomRight: Radius.circular(size.width / 10),
            ),
          ),
          width: size.width,
          height: size.height * 0.04,
        ),
        SizedBox(height: size.height * 0.04),
        Padding(
          padding: EdgeInsets.only(left: size.width / 9),
          child: const Text(
            'Friends',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.04),
        SizedBox(
          height: size.height,
          child: streamUsers.when(
            loading: () => loading(),
            error: (ex, stack) => Text(ex.toString()),
            data: (users) => futureUser.when(
              error: (ex, stackTrace) => Center(child: Text(ex.toString())),
              loading: () => loading(),
              data: (user) {
                users.remove(user);
                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No friends found!',
                    ),
                  );
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    itemCount: users.length,
                    itemBuilder: (context, idx) => GestureDetector(
                      onTap: () {
                        ref.read(myUserP.notifier).changeUser(
                          name: user.name,
                          email: user.email,
                          image: user.image,
                        );
                        ref.read(receiverP.notifier).changeState(users[idx].email);
                        Navigator.of(context).pushNamed('/chat');
                      },
                      child: ListTile(
                        leading: userImage(size.width / 8, users[idx].image),
                        title: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            users[idx].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text('status'),
                        trailing: const SizedBox(width: 1, height: 1),
                      ),
                    ),
                    separatorBuilder: (context, idx) => const Divider(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

}