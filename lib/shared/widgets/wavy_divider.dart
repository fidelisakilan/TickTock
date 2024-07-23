import 'package:tick_tock/app/config.dart';
import 'package:wave_divider/wave_divider.dart';

class WavyDivider extends StatelessWidget {
  const WavyDivider({super.key, this.verticalPadding});

  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return WaveDivider(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 5),
      color: context.colorScheme.primary,
    );
  }
}
