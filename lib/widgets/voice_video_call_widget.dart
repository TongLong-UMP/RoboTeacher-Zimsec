// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import '../services/signaling_service.dart';

// The entire VoiceVideoCallWidget is disabled for web build due to flutter_webrtc incompatibility.
// To re-enable, uncomment and ensure flutter_webrtc is available.
/*
class VoiceVideoCallWidget extends StatefulWidget {
  final bool isVideo;
  final bool isCaller;
  // final SignalingService? signalingService; // Uncomment for real calls

  const VoiceVideoCallWidget(
      {Key? key,
      this.isVideo = true,
      this.isCaller = true /*, this.signalingService*/})
      : super(key: key);

  @override
  State<VoiceVideoCallWidget> createState() => _VoiceVideoCallWidgetState();
}

class _VoiceVideoCallWidgetState extends State<VoiceVideoCallWidget> {
  final _localRenderer = RTCVideoRenderer();
  // final _remoteRenderer = RTCVideoRenderer(); // Uncomment for real calls
  MediaStream? _localStream;
  // MediaStream? _remoteStream; // Uncomment for real calls

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startCall();
    // Uncomment for real calls
    /*
    widget.signalingService?.onAddRemoteStream = (stream) {
      setState(() {
        _remoteStream = stream;
        _remoteRenderer.srcObject = stream;
      });
    };
    widget.signalingService?.connect(isCaller: widget.isCaller);
    */
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    // _remoteRenderer.dispose();
    _localStream?.dispose();
    // widget.signalingService?.close();
    super.dispose();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    // await _remoteRenderer.initialize();
  }

  Future<void> _startCall() async {
    final mediaConstraints = {
      'audio': true,
      'video': widget.isVideo ? {'facingMode': 'user'} : false,
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
    // For real calls, handled by signaling
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isVideo ? 'Video Call' : 'Voice Call'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: widget.isVideo
            ? Stack(
                children: [
                  RTCVideoView(_localRenderer, mirror: true),
                  // Uncomment for real calls
                  /*
                  if (_remoteStream != null)
                    Positioned(
                      right: 10,
                      top: 10,
                      width: 100,
                      height: 150,
                      child: RTCVideoView(_remoteRenderer),
                    ),
                  */
                ],
              )
            : Center(child: Icon(Icons.mic, size: 100)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('End Call'),
        ),
      ],
    );
  }
}
*/
