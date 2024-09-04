import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:reservation_app/src/presentation/widgets/general/widget_custom_loading.dart';

import '../../../data/bloc/history/history_bloc.dart';
import '../../../data/model/history_model.dart';
import '../../utils/general/parsing.dart';
import '../../widgets/general/header_pages.dart';
import 'widget_history_card_view.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryBloc _historyBloc;

  _getHistory() {
    _historyBloc = context.read<HistoryBloc>();
    _historyBloc.add(GetHistoryUser());
  }

  @override
  void didChangeDependencies() {
    _getHistory();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                const HeaderPage(
                  name: "Riwayat Reservasi",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getHistory();
                    },
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(8),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.filter_alt),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              BlocBuilder<HistoryBloc, HistoryState>(
                                builder: (context, state) {
                                  if (state is HistoryGetSuccess) {
                                    final histories = state.histories;
                                    histories.sort(
                                      (a, b) => a.dateFinished!
                                          .compareTo(b.dateFinished!),
                                    );
                                    if (histories.isNotEmpty) {
                                      return GroupedListView<HistoryModel,
                                          String>(
                                        padding: EdgeInsets.zero,
                                        elements: histories,
                                        shrinkWrap: true,
                                        groupBy: (element) =>
                                            ParsingDate().convertDateOnlyMonth(
                                          element.dateCreated!,
                                        ),
                                        order: GroupedListOrder.DESC,
                                        sort: true,
                                        groupSeparatorBuilder:
                                            (String groupByValue) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                              top: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  groupByValue,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                  height: 1,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        itemBuilder: (context, element) {
                                          return HistoryCardView(
                                            history: element,
                                            function: () {},
                                          );
                                        },
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          const Gap(30),
                                          Center(
                                            child: Text(
                                              "Tidak ada riwayat reservasi",
                                              style: GoogleFonts.openSans(
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Center(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const CustomLoading();
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
