import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/create_task/bloc/create_task_cubit.dart';
import 'package:tick_tock/modules/create_task/services/speech_manager.dart';
import 'package:tick_tock/modules/create_task/ui/create_task_screen.dart';
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

  @override
  void initState() {
    startService(TextInputType.voice);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    speechManager.dispose();
  }

  void startService(TextInputType type, {bool toggleKeyboard = true}) {
    currentType = type;
    if (mounted) setState(() {});
    switch (type) {
      case TextInputType.text:
        speechManager.stop();
        focusNode.requestFocus();
        if (toggleKeyboard) {
          SystemChannels.textInput.invokeMethod("TextInput.show");
        }

      case TextInputType.voice:
        startVoice();
    }
  }

  void startVoice() {
    if (speechManager.isRunning) {
      speechManager.stop();
      return;
    }
    focusNode.unfocus();
    speechManager.run(onResult: (String content) {
      controller.value = TextEditingValue(text: content);
    }, onFailure: (error) {
      AppToast.showToast(error);
      Future.delayed(Duration.zero, () => startService(TextInputType.text));
    }, onComplete: () {
      Future.delayed(Duration.zero, () => startService(TextInputType.text));
    });
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
      body: ValueListenableBuilder<bool>(
        valueListenable: speechManager.speechState,
        builder: (context, value, child) {
          return Stack(
            children: [
              Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: value ? null : 0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: Dimens.horizontalPadding,
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        readOnly: value,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        onTap: () => startService(TextInputType.text),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (String content) {},
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: currentType == TextInputType.voice
                              ? 'Tap the mic to speak'
                              : 'Enter your prompt',
                          hintStyle: context.textTheme.headlineSmall!.copyWith(
                              color: context.colorScheme.onSurfaceVariant),
                        ),
                        style: context.textTheme.headlineSmall!
                            .copyWith(color: context.colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
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
                              backgroundColor:
                                  currentType == TextInputType.voice && value
                                      ? context.colorScheme.errorContainer
                                      : context.colorScheme.primaryContainer,
                              foregroundColor:
                                  currentType == TextInputType.voice && value
                                      ? context.colorScheme.error
                                      : context.colorScheme.onPrimaryContainer,
                              heroTag: 'voice',
                              onPressed: () =>
                                  startService(TextInputType.voice),
                              child: Icon(
                                  currentType == TextInputType.voice && value
                                      ? Icons.mic
                                      : Icons.mic_off),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
