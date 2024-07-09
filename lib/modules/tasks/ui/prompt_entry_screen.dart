import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';
import 'package:tick_tock/modules/tasks/bloc/speech_manager.dart';
import 'package:tick_tock/modules/tasks/ui/create_task_screen.dart';
import 'package:tick_tock/shared/utils/app_toast.dart';

enum TextInputType { text, voice }

class PromptEntryScreen extends StatefulWidget {
  const PromptEntryScreen({super.key});

  @override
  State<PromptEntryScreen> createState() => _PromptEntryScreenState();
}

class _PromptEntryScreenState extends State<PromptEntryScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late TextInputType currentType;
  final speechManager = SpeechToTextManager();
  bool isLoading = false;

  @override
  void initState() {
    startService(TextInputType.voice);
    super.initState();
  }

  void startService(TextInputType type) {
    currentType = type;
    if (mounted) setState(() {});
    switch (type) {
      case TextInputType.text:
        speechManager.stop();
        focusNode.requestFocus();
      case TextInputType.voice:
        startVoice();
    }
  }

  void startVoice() {
    if (speechManager.isRunning) {
      setState(() => isLoading = false);
      speechManager.stop();
      return;
    }
    focusNode.unfocus();
    setState(() => isLoading = true);
    speechManager.run(
      onResult: (String content) {
        controller.value = TextEditingValue(text: content);
      },
      onFailure: (error) {
        setState(() => isLoading = false);
        AppToast.showToast(error);
        Future.delayed(Duration.zero, () => startService(TextInputType.text));
      },
      onReady: () {
        setState(() => isLoading = false);
      },
    );
  }

  void onTapManualEntry() {
    context.pushReplacement(BlocProvider(
      create: (context) => CreateTaskCubit(),
      child: const TaskEntrySheet(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          Padding(
            padding: Dimens.horizontalPadding,
            child: FilledButton(
              onPressed: onTapManualEntry,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: currentType == TextInputType.text
                ? context.colorScheme.errorContainer
                : context.colorScheme.primaryContainer,
            foregroundColor: currentType == TextInputType.text
                ? context.colorScheme.error
                : context.colorScheme.onPrimaryContainer,
            heroTag: 'keyboard',
            onPressed: () => startService(TextInputType.text),
            child: const Icon(Icons.keyboard),
          ),
          const GapBox(gap: Gap.s),
          ValueListenableBuilder<bool>(
              valueListenable: speechManager.speechState,
              builder: (context, value, child) {
                return FloatingActionButton(
                  backgroundColor: currentType == TextInputType.voice && value
                      ? context.colorScheme.errorContainer
                      : context.colorScheme.primaryContainer,
                  foregroundColor: currentType == TextInputType.voice && value
                      ? context.colorScheme.error
                      : context.colorScheme.onPrimaryContainer,
                  heroTag: 'voice',
                  onPressed: () => startService(TextInputType.voice),
                  child: Icon(currentType == TextInputType.voice && value
                      ? Icons.mic
                      : Icons.mic_off),
                );
              }),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            value: isLoading ? null : 0,
          ),
          Expanded(
            child: Padding(
              padding: Dimens.horizontalPadding,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                expands: true,
                minLines: null,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (String content) {
                  final trimmed =
                      content.trim().isNotEmpty ? content.trim() : null;
                },
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: currentType == TextInputType.voice
                      ? 'Tap the mic to speak'
                      : 'Enter your prompt',
                  hintStyle: context.textTheme.headlineSmall!
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                style: context.textTheme.headlineSmall!
                    .copyWith(color: context.colorScheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
    return const Placeholder();
  }
}
