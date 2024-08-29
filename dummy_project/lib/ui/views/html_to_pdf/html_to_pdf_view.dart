import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'html_to_pdf_viewmodel.dart';

class HtmlToPdfView extends StackedView<HtmlToPdfViewModel> {
  const HtmlToPdfView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(HtmlToPdfViewModel viewModel) {
    viewModel.createDocument();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    HtmlToPdfViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  HtmlToPdfViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HtmlToPdfViewModel();
}
