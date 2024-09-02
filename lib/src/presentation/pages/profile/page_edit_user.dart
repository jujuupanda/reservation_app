import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_app/src/presentation/pages/profile/widget_profile_text_field.dart';

import '../../../data/bloc/register/register_bloc.dart';
import '../../../data/model/user_model.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/pop_up.dart';
import 'widget_custom_text_form_field.dart';
import 'widget_subtitle.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController idController;
  late TextEditingController agencyController;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController temporaryController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEdit = GlobalKey<FormState>();
  late RegisterBloc registerBloc;

  /// fungsi mengedit user
  editUser() {
    registerBloc = context.read<RegisterBloc>();
    registerBloc.add(EditUserAdmin(
      idController.text,
      agencyController.text,
      usernameController.text,
      passwordController.text,
      fullNameController.text,
      emailController.text,
      phoneController.text,
    ));
  }

  /// fungsi mengedit username
  changeUsername() {
    registerBloc = context.read<RegisterBloc>();
    registerBloc.add(ChangeUsername(
      idController.text,
      usernameController.text,
    ));
  }

  /// fungsi untuk mendapatkan info list user
  getAllUserByAgency() {
    registerBloc = context.read<RegisterBloc>();
    registerBloc.add(GetAllUser());
  }

  popWhenEditUser() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.blueAccent,
                  ),
                ),
                Gap(10),
                Text(
                  'Simpan perubahan?',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    editUser();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent),
                    child: const Center(
                      child: Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// popup ketika mengedit 1 field
  popUpEditUsername(
    String fieldName,
    TextEditingController controller,
    IconData prefixIcon,
  ) {
    temporaryController.text = controller.text;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is ChangeUsernameSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: Center(
              child: Text(
                "Edit $fieldName",
                style: GoogleFonts.openSans(),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 90,
              child: Form(
                key: formKeyEdit,
                child: Column(
                  children: [
                    CustomTextFormField(
                      fieldName: fieldName,
                      controller: temporaryController,
                      prefixIcon: prefixIcon,
                    ),

                    /// error when username is exist
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is ChangeUsernameFailed) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                state.error,
                                style: GoogleFonts.openSans(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        } else if (state is RegisterLoading) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      getAllUserByAgency();
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.blueAccent,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (formKeyEdit.currentState!.validate()) {
                        controller.text = temporaryController.text;
                        changeUsername();
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent),
                      child: const Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    idController = TextEditingController(text: widget.userModel.id);
    agencyController = TextEditingController(text: widget.userModel.agency);
    usernameController = TextEditingController(text: widget.userModel.username);
    fullNameController = TextEditingController(text: widget.userModel.fullName);
    emailController = TextEditingController(text: widget.userModel.email);
    phoneController = TextEditingController(text: widget.userModel.phone);
    passwordController = TextEditingController(text: widget.userModel.password);
    temporaryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    agencyController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    temporaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is EditSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil melakukan perubahan",
            Icons.check_circle,
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const HeaderDetailPage(
              pageName: "Edit User",
            ),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(10),
                                const SubtitleProfileWidget(
                                  subtitle: "Username",
                                ),
                                CustomProfileTextFormField(
                                  fieldName: "Username",
                                  controller: usernameController,
                                  prefixIcon: Icons.person,
                                  isEdit: true,
                                  function: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      popUpEditUsername(
                                        "Username",
                                        usernameController,
                                        Icons.person,
                                      );
                                    });
                                  },
                                ),
                                const SubtitleProfileWidget(
                                  subtitle: "Instansi",
                                ),
                                CustomTextFormField(
                                  fieldName: "Nama Lengkap",
                                  controller: agencyController,
                                  prefixIcon: Icons.corporate_fare,
                                ),
                                const SubtitleProfileWidget(
                                  subtitle: "Nama",
                                ),
                                CustomTextFormField(
                                  fieldName: "Nama Lengkap",
                                  controller: fullNameController,
                                  prefixIcon: Icons.person,
                                ),
                                const SubtitleProfileWidget(subtitle: "E-Mail"),
                                CustomTextFormField(
                                  fieldName: "E-Mail",
                                  controller: emailController,
                                  prefixIcon: Icons.email,
                                ),
                                const SubtitleProfileWidget(
                                  subtitle: "Nomor Telepon",
                                ),
                                CustomTextFormField(
                                  fieldName: "Nomor Telepon",
                                  controller: phoneController,
                                  prefixIcon: Icons.phone_android,
                                ),
                                const SubtitleProfileWidget(
                                  subtitle: "Password",
                                ),
                                CustomTextFormField(
                                  fieldName: "Password",
                                  controller: passwordController,
                                  prefixIcon: Icons.lock,
                                ),
                                const Gap(20),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ButtonPositive(
                                    name: "Simpan Perubahan",
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        popWhenEditUser();
                                      }
                                    },
                                  ),
                                ),
                                const Gap(30),
                              ],
                            )),
                      ),
                    ),
                  ),
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return Container(
                          decoration:
                              const BoxDecoration(color: Color(0x80FFFFFF)),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
