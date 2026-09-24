import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/effect_model.dart';
import '../models/user_model.dart';

/// All Firestore reads/writes for a signed-in user's data live here.
///
/// Firestore layout:
/// users (collection)
///   {uid} (doc)               -> fullName, email, photoUrl, createdAt
///     effects (sub-collection)
///       {effectId} (doc)      -> name, effectType, colors, zones,
///                                 upTime, offTime, isOn, isFavorite, lastUsedAt
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _effectsRef(String uid) =>
      _userDoc(uid).collection('effects');

  Future<UserModel?> getUserProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists) return null;
    return UserModel.fromMap(uid, snap.data()!);
  }

  /// Powers the "Effects" list + All/Running/Favorites/Recents tabs on Home.
  Stream<List<EffectModel>> watchEffects(String uid) {
    return _effectsRef(uid).orderBy('name').snapshots().map(
          (snap) => snap.docs.map((d) => EffectModel.fromDoc(d)).toList(),
        );
  }

  Future<void> toggleEffect(String uid, String effectId, bool isOn) {
    return _effectsRef(uid).doc(effectId).update({'isOn': isOn});
  }

  Future<void> addEffect(String uid, EffectModel effect) {
    return _effectsRef(uid).doc(effect.id).set(effect.toMap());
  }

  Future<void> deleteEffect(String uid, String effectId) {
    return _effectsRef(uid).doc(effectId).delete();
  }
}
