import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class VerifyShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  Future<List<Map<String, dynamic>>> fetchVerificationData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('verificationData').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      logger.i('Error fetching verification data: $e');
      return [];
    }
  }

  Future<void> updateVerificationStatus(String serviceProviderUid, String newStatus) async {
    try {
      await _firestore.collection('automotiveShops_profile').doc(serviceProviderUid).update({
        'verificationStatus': newStatus,
      });
      logger.i('Successfully updated verification status for $serviceProviderUid to $newStatus');
    } catch (e) {
      logger.e('Error updating verification status for $serviceProviderUid: $e');
    }
  }

  Future<void> updateVerificationStatusForValidationModel(String serviceProviderUid, String newStatus) async {
    try {
      await _firestore.collection('verificationData').doc(serviceProviderUid).update({
        'verificationStatus': newStatus,
      });
      logger.i('Successfully updated verification status for $serviceProviderUid to $newStatus');
    } catch (e) {
      logger.e('Error updating verification status for $serviceProviderUid: $e');
    }
  }
}