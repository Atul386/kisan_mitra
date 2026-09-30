import '../../../l10n/app_localizations.dart';
import '../domain/farm_document.dart';

String documentCategoryLabel(AppLocalizations t, DocumentCategory c) => switch (c) {
      DocumentCategory.extract712 => t.docCat712,
      DocumentCategory.extract8a => t.docCat8a,
      DocumentCategory.soilHealthCard => t.docCatSoil,
      DocumentCategory.cropInsurance => t.docCatInsurance,
      DocumentCategory.bankDocuments => t.docCatBank,
      DocumentCategory.pmKisan => t.docCatPmKisan,
      DocumentCategory.mahadbt => t.docCatMahadbt,
      DocumentCategory.other => t.docCatOther,
    };

String documentRejectionText(AppLocalizations t, DocumentRejection r) => switch (r) {
      DocumentRejection.unsupportedType => t.docUnsupported,
      DocumentRejection.tooLarge => t.docTooLarge,
      DocumentRejection.empty => t.docEmptyFile,
    };

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
