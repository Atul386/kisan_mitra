import 'package:uuid/uuid.dart';

/// Device-generated IDs so farmers can create records fully offline (§37).
/// The same ID is reused when the record eventually syncs to Firestore.
const _uuid = Uuid();

String newId() => _uuid.v4();
