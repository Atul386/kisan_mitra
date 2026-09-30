import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_sync_specs.dart';

/// The few cloud operations sync needs. The app uses [FirestoreCloudStore];
/// tests use an in-memory implementation, so sync logic can be verified
/// without a Firebase project.
abstract class CloudStore {
  /// Creates or overwrites the document at [docPath] (alternating
  /// collection/document ids, e.g. `['users', uid, 'farms', farmId]`).
  Future<void> set(List<String> docPath, Json data);

  Future<Json?> get(List<String> docPath);

  /// Every document in the collection at [collectionPath] (odd length).
  Future<List<Json>> list(List<String> collectionPath);
}

class FirestoreCloudStore implements CloudStore {
  FirestoreCloudStore(this._firestore, {this.timeout = const Duration(seconds: 20)});

  final FirebaseFirestore _firestore;

  /// Firestore queues writes offline and only completes the future once the
  /// server has them, so without a timeout an offline push would hang.
  final Duration timeout;

  DocumentReference<Json> _doc(List<String> path) {
    assert(path.length.isEven && path.length >= 2, 'a document path needs collection/doc pairs');
    var ref = _firestore.collection(path[0]).doc(path[1]);
    for (var i = 2; i < path.length; i += 2) {
      ref = ref.collection(path[i]).doc(path[i + 1]);
    }
    return ref;
  }

  CollectionReference<Json> _collection(List<String> path) {
    assert(path.length.isOdd, 'a collection path has an odd number of segments');
    var ref = _firestore.collection(path[0]);
    for (var i = 1; i < path.length; i += 2) {
      ref = ref.doc(path[i]).collection(path[i + 1]);
    }
    return ref;
  }

  @override
  Future<void> set(List<String> docPath, Json data) => _doc(docPath).set(data).timeout(timeout);

  @override
  Future<Json?> get(List<String> docPath) async {
    final snap = await _doc(docPath).get().timeout(timeout);
    return snap.exists ? snap.data() : null;
  }

  @override
  Future<List<Json>> list(List<String> collectionPath) async {
    final snap = await _collection(collectionPath).get().timeout(timeout);
    return [for (final d in snap.docs) d.data()];
  }
}
