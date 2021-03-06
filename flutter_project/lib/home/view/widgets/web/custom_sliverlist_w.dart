import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/models/nivedhanam_model.dart';
import 'package:mpapp/home/bloc/home_bloc.dart';

class CustomPageView extends StatefulWidget {
  const CustomPageView(
    pageController, {
    Key? key,
  })  : pageController = pageController,
        super(key: key);
  final pageController;
  @override
  _CustomPageViewState createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late HomeBloc _homeBloc;

  var nPerView = 20;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageTurn);
    _homeBloc = context.read<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, state) {
        return PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: widget.pageController,
            itemBuilder: pageBuilder,
            itemCount: _homeBloc.state.hasReachedMax
                ? (_homeBloc.state.nivedhanams.length / nPerView).ceil()
                : (_homeBloc.state.nivedhanams.length / nPerView).ceil() + 1);
      },
    );
  }

  Widget pageBuilder(context, pageNumber) {
    ScrollController _scroll = ScrollController();
    late List<Nivedhanam> currentpagenivedhanam = _homeBloc.state.nivedhanams
        .sublist(
            pageNumber * nPerView,
            _homeBloc.state.nivedhanams.length >
                    (pageNumber * nPerView + nPerView)
                ? pageNumber * nPerView + nPerView
                : null);
    return pageNumber >= (_homeBloc.state.nivedhanams.length / nPerView).ceil()
        ? BottomLoaderW()
        : Scrollbar(
            controller: _scroll,
            isAlwaysShown: true,
            child: ListView(
                controller: _scroll,
                children: currentpagenivedhanam
                    .map<Widget>((nivedhanam) => CustomListTileW(nivedhanam))
                    .toList()),
          );
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    super.dispose();
  }

  void _onPageTurn() {
    if (_isBottom) {
      _homeBloc.add(NivedhanamFetchedEvent());
    }
  }

  bool get _isBottom {
    if (!widget.pageController.hasClients) return false;
    final maxScroll = widget.pageController.position.maxScrollExtent;
    final currentScroll = widget.pageController.offset;
    return currentScroll >= (maxScroll * 0.7);
  }
}

class CustomListTileW extends StatelessWidget {
  const CustomListTileW(
    Nivedhanam nivedhanam, {
    Key? key,
  })  : nivedhanam = nivedhanam,
        super(key: key);
  final Nivedhanam nivedhanam;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      onTap: () async {
        context.read<HomeBloc>().add(AddNivedhanamToRecent(nivedhanam));
        final result = await Navigator.pushNamed(context, '/editor',
            arguments: nivedhanam);
        if (result == true) {
          context.read<HomeBloc>().add(RefreshNivedhanamEvent());
        }
      },
      shape: Border(
        bottom:
            BorderSide(color: Colors.grey, width: .3, style: BorderStyle.solid),
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              child: Center(child: Text(nivedhanam.siNo.toString()))),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    width: 2,
                    color: nivedhanam.status != "recieved"
                        ? Colors.grey.shade600
                        : Colors.grey)),
            child: Icon(
              Icons.description_rounded,
              color: nivedhanam.status != "recieved"
                  ? Colors.grey.shade600
                  : Colors.grey,
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              toBeginningOfSentenceCase(nivedhanam.name) ?? "",
              style: TextStyle(fontWeight: FontWeight.w600),
              textScaleFactor: 1.1,
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              toBeginningOfSentenceCase(nivedhanam.address) ?? "",
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              "-" + nivedhanam.remarks!,
              textScaleFactor: 1.1,
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              nivedhanam.status,
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Text(
              nivedhanam.date,
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}

class BottomLoaderW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
