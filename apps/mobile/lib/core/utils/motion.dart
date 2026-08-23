import 'package:flutter/material.dart';

/// Returns [duration], or [Duration.zero] when the platform has "reduce
/// motion" enabled. Use this to wrap any animation duration in the design
/// system so decorative motion (shimmer, page transitions, pulses) honors
/// the user's accessibility preference instead of forcing it on everyone.
Duration motionDuration(BuildContext context, Duration duration) {
  final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return disableAnimations ? Duration.zero : duration;
}
