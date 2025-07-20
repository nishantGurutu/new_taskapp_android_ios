import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:task_management/model/lead_list_model.dart';
import 'package:task_management/service/lead_service.dart';

class NetworkService {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "Network Connected",
          toastLength: Toast.LENGTH_SHORT,
        );

        // final offlineLeads = await DatabaseHelper.instance.getLeads();

        // for (var leadMap in offlineLeads) {
        //   final lead = LeadListData.fromJson(leadMap);
        //   await _uploadOfflineLead(lead);
        // }

        // // After all are uploaded, clear offline leads table
        // await DatabaseHelper.instance.clearLeadsTable();
        // Fluttertoast.showToast(
        //   msg: "api calling",
        //   toastLength: Toast.LENGTH_SHORT,
        // );
      } else {
        Fluttertoast.showToast(
          msg: "No Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }

  Future<void> _uploadOfflineLead(LeadListData lead) async {
    try {
      // Assume audio is saved locally, get it from path
      File audioFile = File(lead.audio ?? '');

      final result = await LeadService().addLeadsApi(
        leadName: lead.leadName,
        companyName: lead.company,
        phone: lead.phone,
        email: lead.email,
        source: lead.source,
        industry: lead.company,
        status: lead.status,
        tag: '',
        description: lead.description,
        address: '',
        pickedFile: lead.image,
        audio: audioFile,
      );

      if (result != null) {
        debugPrint("Offline lead ${lead.leadName} synced successfully.");
      } else {
        debugPrint("Failed to sync offline lead: ${lead.leadName}");
      }
    } catch (e) {
      debugPrint("Exception during lead sync: $e");
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
