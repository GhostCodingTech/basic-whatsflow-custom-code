
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class GhostCodingBasicVoiceChannel extends StatefulWidget {
  const GhostCodingBasicVoiceChannel({
    super.key,
    this.width,
    this.height,
    required this.token,
    required this.appID,
    required this.channelName,
    required this.backgroundValue,
    required this.headPercentageWidth,
    required this.headPercentageHeight,
    required this.mainContainerBorderRadius,
    required this.mainContainerBackground,
    required this.profilePictureWidth,
    required this.profilePictureHeight,
    required this.placeHolderImagePath,
    required this.userProfileImage,
    required this.profileBorderRadius,
    required this.profileBorderColor,
    required this.profileBorderwidth,
    required this.actionContainerBackground,
    required this.actionContainerRadiusBL,
    required this.actionContainerRadiusBR,
    required this.actionContainerRadiusTL,
    required this.actionContainerRadiusTR,
    required this.buttonRowPadding,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.endCallElevation,
    required this.endCallBorderRadius,
    required this.endCallBackground,
    required this.endCallIcon,
    this.endCallAction,
    required this.speakerButtonElevation,
    required this.speakerButtonBorderRadius,
    required this.speakerEnabledColor,
    required this.speakerDisabledColor,
    required this.speakerIconActive,
    required this.speakerIconInactive,
    required this.activeBoxBackground,
    required this.activeBoxBorderRadius,
    required this.callingTextColor,
    required this.callingTextString,
    required this.userSpeakingIcon,
    required this.userNotSpeakingIcon,
    required this.userFirstName,
  });

  final double? width;
  final double? height;
  final String token;
  final String appID;
  final String channelName;
  final Color backgroundValue;
  final double headPercentageWidth;
  final double headPercentageHeight;
  final double mainContainerBorderRadius;
  final Color mainContainerBackground;
  final double profilePictureWidth;
  final double profilePictureHeight;
  final String placeHolderImagePath;
  final String userProfileImage;
  final double profileBorderRadius;
  final Color profileBorderColor;
  final double profileBorderwidth;
  final Color actionContainerBackground;
  final double actionContainerRadiusBL;
  final double actionContainerRadiusBR;
  final double actionContainerRadiusTL;
  final double actionContainerRadiusTR;
  final double buttonRowPadding;
  final double buttonWidth;
  final double buttonHeight;
  final double endCallElevation;
  final double endCallBorderRadius;
  final Color endCallBackground;
  final Widget endCallIcon;
  final Future Function()? endCallAction;
  final double speakerButtonElevation;
  final double speakerButtonBorderRadius;
  final Color speakerEnabledColor;
  final Color speakerDisabledColor;
  final Widget speakerIconActive;
  final Widget speakerIconInactive;

  final Color activeBoxBackground;
  final double activeBoxBorderRadius;

  final Widget userSpeakingIcon;
  final Widget userNotSpeakingIcon;

  final Color callingTextColor;
  final String userFirstName;
  final String callingTextString;

  @override
  State<GhostCodingBasicVoiceChannel> createState() =>
      _GhostCodingBasicVoiceChannelState();
}

class _GhostCodingBasicVoiceChannelState
    extends State<GhostCodingBasicVoiceChannel> {
  bool isSpeakerEnabled = false;
  RtcEngine? _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool isRemoteUserSpeaking = false;

  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    // Check and request necessary permissions: microphone and camera
    // This is required for mobile apps; permissions are typically managed by the browser for web apps
    if (!kIsWeb) {
      await Permission.microphone.request();
    }

    // Create the Agora engine using the App ID provided by Agora.io
    _engine = await RtcEngine.create(widget.appID);

    // Enable audio volume indication
    await _engine?.enableAudioVolumeIndication(
      50, // interval in ms to report volume indication
      3, // the sensitivity of the volume, ranging from 0 to 10
      true, // whether to report the volume of local speakers
    );

    // Define the event handler to handle events such as user joining, user offline, etc.
    _engine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print("Local user $uid joined channel: $channel");
        setState(() {
          _localUserJoined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        print("Remote user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print("Remote user $uid left channel");
        setState(() {
          if (_remoteUid == uid) {
            _remoteUid = null;
          }
        });
      },
      audioVolumeIndication: (List<AudioVolumeInfo> speakers, int totalVolume) {
        for (var speaker in speakers) {
          if (speaker.uid == _remoteUid && speaker.volume > 3) {
            setState(() {
              isRemoteUserSpeaking = true;
            });
          } else if (speaker.uid == _remoteUid && speaker.volume == 3) {
            setState(() {
              isRemoteUserSpeaking = false;
            });
          }
        }
      },
    ));

    // Join the channel with a token, channel name, and optional additional information (empty string here)
    await _engine!.joinChannel(widget.token, widget.channelName, null, 0);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _engine?.destroy();
    _engine?.leaveChannel();
    super.dispose();
  }

  void _onToggleSpeaker() {
    setState(() {
      isSpeakerEnabled = !isSpeakerEnabled;
      _engine?.setEnableSpeakerphone(isSpeakerEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.backgroundValue,
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional(-1.0, 1.0),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Stack(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width *
                                    widget.headPercentageWidth,
                                height: MediaQuery.sizeOf(context).height *
                                    widget.headPercentageHeight,
                                decoration: BoxDecoration(
                                  color: widget.mainContainerBackground,
                                  borderRadius: BorderRadius.circular(
                                      widget.mainContainerBorderRadius),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                              ),
                            ),
                            // only be displayed if profile is null
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Container(
                                width: widget.profilePictureWidth,
                                height: widget.profilePictureHeight,
                                decoration: BoxDecoration(
                                  color: widget.mainContainerBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.asset(
                                      widget.placeHolderImagePath,
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      widget.profileBorderRadius),
                                ),
                              ),
                            ),
                            // url to be set to user profile photo
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Container(
                                width: widget.profilePictureWidth,
                                height: widget.profilePictureHeight,
                                decoration: BoxDecoration(
                                  color: widget.mainContainerBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      widget.userProfileImage,
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      widget.profileBorderRadius),
                                  border: Border.all(
                                    color: widget.profileBorderColor,
                                    width: widget.profileBorderwidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 0.0, 10.0),
                        child: _remoteAudio(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: widget.actionContainerBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.actionContainerRadiusBL),
              bottomRight: Radius.circular(widget.actionContainerRadiusBR),
              topLeft: Radius.circular(widget.actionContainerRadiusTL),
              topRight: Radius.circular(widget.actionContainerRadiusTR),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.buttonRowPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // end channel
                Material(
                  elevation: widget.endCallElevation,
                  borderRadius:
                      BorderRadius.circular(widget.endCallBorderRadius),
                  color: widget.endCallBackground,
                  child: Container(
                    width: widget.buttonWidth, // Set the desired width
                    height: widget.buttonHeight, // Set the desired height
                    decoration: BoxDecoration(
                      color: widget.endCallBackground,
                      borderRadius: BorderRadius.circular(widget
                          .endCallBorderRadius), // Set the desired border radius
                    ),
                    child: FloatingActionButton(
                      backgroundColor: widget
                          .endCallBackground, // Make the FAB's background transparent
                      elevation:
                          0, // Remove the elevation to match the container's styling
                      child: widget.endCallIcon,
                      onPressed: () async {
                        _engine?.destroy();
                        _engine?.leaveChannel();
                        if (widget.endCallAction != null) {
                          await widget.endCallAction!();
                        }
                      },
                    ),
                  ),
                ),
                // Speaker button
                Material(
                  elevation: widget.speakerButtonElevation,
                  borderRadius:
                      BorderRadius.circular(widget.speakerButtonBorderRadius),
                  color: isSpeakerEnabled
                      ? widget.speakerEnabledColor
                      : widget.speakerDisabledColor,
                  child: Container(
                    width: widget.buttonWidth, // Set the desired width
                    height: widget
                        .buttonHeight, // Set the desired height // Set the desired height
                    decoration: BoxDecoration(
                      color: isSpeakerEnabled
                          ? widget.speakerEnabledColor
                          : widget.speakerDisabledColor,
                      borderRadius: BorderRadius.circular(widget
                          .speakerButtonBorderRadius), // Set the desired border radius
                    ),
                    child: FloatingActionButton(
                      backgroundColor: isSpeakerEnabled
                          ? widget.speakerEnabledColor
                          : widget.speakerDisabledColor,
                      elevation:
                          0, // Remove the elevation to match the container's styling
                      child: isSpeakerEnabled
                          ? widget.speakerIconActive
                          : widget.speakerIconInactive,
                      onPressed: _onToggleSpeaker,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _remoteAudio() {
    if (_remoteUid != null) {
      return Container(
        decoration: BoxDecoration(
          color: widget.activeBoxBackground,
          borderRadius: BorderRadius.circular(widget.activeBoxBorderRadius),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  isRemoteUserSpeaking
                      ? widget.userSpeakingIcon
                      : widget.userNotSpeakingIcon,
                ],
              ),
              Text(
                widget.userFirstName,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Space Grotesk',
                      letterSpacing: 0.0,
                      color: widget.callingTextColor,
                    ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: widget.activeBoxBackground,
          borderRadius: BorderRadius.circular(widget.activeBoxBorderRadius),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.callingTextString,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Space Grotesk',
                      letterSpacing: 0.0,
                      color: widget.callingTextColor,
                    ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
        ),
      );
    }
  }
}