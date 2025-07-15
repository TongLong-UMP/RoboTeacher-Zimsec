// import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

// import 'package:flutter_webrtc/flutter_webrtc.dart';
// All code in this file is commented out for web build compatibility.
// To re-enable, uncomment and ensure flutter_webrtc is available.

class SignalingService {
  final String roomId;
  final String wsUrl;
  // WebSocketChannel? _channel;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  Function(MediaStream stream)? onAddRemoteStream;

  SignalingService({required this.roomId, required this.wsUrl});

  Future<void> connect({required bool isCaller}) async {
    // Uncomment for real signaling
    /*
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _channel!.stream.listen(_onMessage);
    _channel!.sink.add(jsonEncode({'type': 'join', 'room': roomId}));
    */
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    });
    _localStream = await navigator.mediaDevices
        .getUserMedia({'audio': true, 'video': true});
    _peerConnection!.addStream(_localStream!);
    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        // Uncomment for real signaling
        /*
        _channel!.sink.add(jsonEncode({
          'type': 'signal',
          'room': roomId,
          'payload': {'candidate': candidate.toMap()}
        }));
        */
      }
    };
    _peerConnection!.onAddStream = (stream) {
      if (onAddRemoteStream != null) onAddRemoteStream!(stream);
    };
    if (isCaller) {
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      // Uncomment for real signaling
      /*
      _channel!.sink.add(jsonEncode({
        'type': 'signal',
        'room': roomId,
        'payload': {'sdp': offer.toMap()}
      }));
      */
    }
  }

  void _onMessage(dynamic message) async {
    final data = jsonDecode(message);
    if (data['type'] == 'signal') {
      final payload = data['payload'];
      if (payload['sdp'] != null) {
        RTCSessionDescription desc = RTCSessionDescription(
          payload['sdp']['sdp'],
          payload['sdp']['type'],
        );
        await _peerConnection!.setRemoteDescription(desc);
        if (desc.type == 'offer') {
          RTCSessionDescription answer = await _peerConnection!.createAnswer();
          await _peerConnection!.setLocalDescription(answer);
          // Uncomment for real signaling
          /*
          _channel!.sink.add(jsonEncode({
            'type': 'signal',
            'room': roomId,
            'payload': {'sdp': answer.toMap()}
          }));
          */
        }
      } else if (payload['candidate'] != null) {
        RTCIceCandidate candidate = RTCIceCandidate(
          payload['candidate']['candidate'],
          payload['candidate']['sdpMid'],
          payload['candidate']['sdpMLineIndex'],
        );
        await _peerConnection!.addCandidate(candidate);
      }
    }
  }

  void close() {
    _peerConnection?.close();
    _localStream?.dispose();
    // Uncomment for real signaling
    // _channel?.sink.close();
  }
}
