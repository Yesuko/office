import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../util.dart';

class TransitionScreen extends StatelessWidget {
  final Transitions transition;

  const TransitionScreen({Key? key, this.transition = Transitions.circular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: widget(transition),
      ),
    );
  }

  Widget widget(Transitions transition) {
    Map<Transitions, Widget> temp = {
      Transitions.circular: const CircularLoader(),
      Transitions.breakdownSkeleton: const BreakdownSkeleton(),
      Transitions.jobDetailSkeleton: const JobDetailsSkeleton(),
      Transitions.attendanceRecordSkeleton: const AttendanceRocordSkeleton(),
      Transitions.jobSkeleton: const JobSkeleton(),
      Transitions.attendanceSkeleton: const AttendanceSkeleton(),
      Transitions.expenseSkeleton: const ExpenseSkeleton(),
      Transitions.employeeListSkeleton: const EmployeesListSkeleton(),
    };
    return temp[transition] ?? Container();
  }
}

class EmployeesListSkeleton extends StatelessWidget {
  const EmployeesListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (size.height * 0.9).toInt(),
        separatorBuilder: (cont, index) => const _SkeletonBase(height: 2),
        itemBuilder: (cont, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SkeletonBase(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBase(width: size.width * 0.4),
                    _SkeletonBase(width: size.width * 0.2),
                  ],
                ),
                _SkeletonBase(
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                )
              ],
            ));
  }
}

class AttendanceRocordSkeleton extends StatelessWidget {
  const AttendanceRocordSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _SkeletonBase(
      child: Column(
        children: [
          Container(
            height: size.height * 0.4,
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              children: [
                const _SkeletonBase(height: 20, width: double.infinity),
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (cont, index) => Column(
                      children: [
                        _SkeletonBase(
                          width: size.width / 9,
                          height: 20,
                        ),
                        _SkeletonBase(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                        _SkeletonBase(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                        _SkeletonBase(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                        _SkeletonBase(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                        _SkeletonBase(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 60,
              width: size.width / 1.5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          const Positioned(
            // top: size.height * 0.5,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseSkeleton extends StatelessWidget {
  const ExpenseSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const _SkeletonBase(height: 40, width: double.infinity),
        Expanded(
          child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (cont, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBase(height: 10, width: size.width * 0.5),
                          _SkeletonBase(height: 10, width: size.width * 0.3),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SkeletonBase(height: 10, width: size.width * 0.1),
                        ],
                      ),
                    ],
                  ),
              separatorBuilder: (cont, index) => const _SkeletonBase(height: 2),
              itemCount: (size.height * 0.9).toInt()),
        ),
      ],
    );
  }
}

class JobSkeleton extends StatelessWidget {
  const JobSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (cont, index) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _SkeletonBase(height: 10, width: size.width * 0.4),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SkeletonBase(height: 10, width: size.width * 0.5),
                    _SkeletonBase(height: 10, width: size.width * 0.1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SkeletonBase(height: 10, width: size.width * 0.3),
                    _SkeletonBase(height: 10, width: size.width * 0.2),
                  ],
                ),
              ],
            ),
        separatorBuilder: (cont, index) => const _SkeletonBase(height: 2),
        itemCount: (size.height * 0.9).toInt());
  }
}

class BreakdownSkeleton extends StatelessWidget {
  const BreakdownSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const _SkeletonBase(height: 40, width: double.infinity),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (cont, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBase(height: 10, width: size.width * 0.4),
                  _SkeletonBase(
                    height: 10,
                    width: size.width * 0.2,
                  )
                ],
              ),
            ),
            separatorBuilder: ((context, index) =>
                const _SkeletonBase(height: 2)),
            itemCount: (size.height * 0.9).toInt(),
          ),
        ),
      ],
    );
  }
}

class AttendanceSkeleton extends StatelessWidget {
  const AttendanceSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 0),
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (_, ind) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const _SkeletonBase(height: 20, width: 100),
                        const Expanded(child: SizedBox()),
                        Column(
                          children: const [
                            _SkeletonBase(height: 20, width: 200),
                            _SkeletonBase(height: 20, width: 200),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              _SkeletonBase(height: 50, width: size.width / 2),
              _SkeletonBase(height: 50, width: size.width / 2),
            ],
          ),
        )
      ],
    );
  }
}

class JobDetailsSkeleton extends StatelessWidget {
  const JobDetailsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SkeletonBase(
          height: 100,
          width: double.infinity,
        ),
        Expanded(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, ind) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const _SkeletonBase(height: 20, width: 100),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: const [
                          _SkeletonBase(height: 20, width: 200),
                          _SkeletonBase(height: 20, width: 200),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _SkeletonBase extends StatelessWidget {
  const _SkeletonBase({Key? key, this.height, this.width, this.child})
      : super(key: key);
  final double? height, width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: child ??
            Container(
              height: height ?? 10,
              width: width ?? 10,
              margin: const EdgeInsets.only(top: 2, left: 8, right: 8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
            ),
      ),
    );
  }
}
