package com.rokkan.media
{
	
	import com.rokkan.events.VideoEvent;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
     * Dispatched when the video is buffering.
     * @eventType com.rokkan.events.VideoEvent.BUFFERING
     */
	[Event(name="buffering", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video playhead is manually adjusted.
     * @eventType com.rokkan.events.VideoEvent.SEEKING
     */
	[Event(name="seeking", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video is paused.
     * @eventType com.rokkan.events.VideoEvent.PAUSED
     */
	[Event(name="paused", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video begins playback.
     * @eventType com.rokkan.events.VideoEvent.PLAYING
     */
	[Event(name="playing", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video is being rewinded.
     * @eventType com.rokkan.events.VideoEvent.REWINDING
     */
	[Event(name="rewinding", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Continually dispatched as the video playhead moves during playback.
     * @eventType com.rokkan.events.VideoEvent.PLAYHEAD_UPDATE
     */
	[Event(name="playheadUpdate", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video reaches a cue point.
     * @eventType com.rokkan.events.VideoEvent.CUE_POINT
     */
	[Event(name="cuePoint", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video's meta data has been received.
     * @eventType com.rokkan.events.VideoEvent.META_DATA
     */
	[Event(name="metaData", type="com.rokkan.events.VideoEvent")]
	
	/**
     * Dispatched when the video finishes playback.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
     * Continually dispatched as the video file is loading.
     * @eventType flash.events.ProgressEvent.PROGRESS
     */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
     * Dispatched when one of the following things occurs: 1) NetConnection failure 2) Invalid seek time
	 * 3) Seek failure 4) Stream not found 5) Stream failure
     * @eventType flash.events.ErrorEvent.ERROR
     */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
     * Dispatched when a security error occurs, most commonly when a crossdomain.xml file prohibits the
	 * loading of video assets.
     * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
     */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * The <code>VideoPlayer</code> class is a lightweight display object that will playback progressively
	 * loaded .flv video files over an HTTP connection. It is designed similarly to that of the FLVPlayback 
	 * component we have all used at one point but should peroform better and be more responsive. Note: This 
	 * class does not support streaming videos from a media server.
	 */
	public class VideoPlayer extends Sprite
	{
		
		/**
		 * String representing the <code>BUFFERING</code> state of the video player. A video is buffering
		 * when the playhead has reached the end of the buffer thus needing to fill the buffer before 
		 * resuming playback.
		 */
		public static const BUFFERING:String = "buffering";
		
		/**
		 * String representing the <code>PAUSED</code> state of the video player. A video is paused when
		 * the playhead is not moving.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * String representing the <code>PLAYING</code> state of the video player. A video is playing
		 * when the video's playhead is continuously moving on its own behalf.
		 */
		public static const PLAYING:String = "playing";
		
		/**
		 * String representing the <code>COMPLETE</code> state of the video player. A video is complete
		 * when the playhead has reached the length of the video's duration.
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * String representing the <code>SEEKING</code> state of the video player. A video is seeking
		 * when the video's playhead is manually adjusted by a call to the <code>seekSeconds</code> or 
		 * <code>seekPercent</code> methods.
		 */
		public static const SEEKING:String = "seeking";
		
		private var _autoSize:Boolean;
		private var _autoStart:Boolean;
		private var _autoRewind:Boolean;
		private var _seeking:Boolean;
		private var _resumeAfterSeek:Boolean;
		private var _bufferTime:Number;
		private var _contentPath:String;
		private var _controls:VideoPlayerControls;
		private var _lastPlayheadTime:Number = -1;
		private var _metaData:VideoMetaData;
		private var _netConnection:NetConnection;
		private var _netStream:NetStream
		private var _sound:SoundTransform;
		private var _video:Video;
		private var _volume:Number;
		private var _lastSeekTime:Number;
		private var _status:String;
		private var _loadTimer:Timer;
		private var _playheadTimer:Timer;
		private var _firstFrameTimer:Timer;
		
		/**
		 * Create an instance of the <code>VideoPlayer</code> class.
		 * @param	x	The initial x position of the video player
		 * @param	y	The initial y position of the video player
		 * @param	width	The initial width of the video player
		 * @param	height	The initial height of the video player
		 * @param	contentPath	The location of the video file to load
		 * @param	bufferTime	The amount of video time that should be buffered before playback
		 * @param	volume	The initial volume of the video
		 * @param	smoothing	Specifies whether the video should be smoothed (interpolated) when it is scaled
		 * @param	deblocking	Indicates the type of filter applied to decoded video as part of post-processing
		 * @param	autoSize	Specefies whether to resize the video to its actual size once loaded
		 * @param	autoStart	Specifies whether to automatically begin playing the video once loaded
		 * @param	autoRewind	Specifies whether to automatically rewind the video when playback has completed
		 */
		public function VideoPlayer( x:Number,
									 y:Number,
									 width:int, 
									 height:int, 
									 contentPath:String, 
									 bufferTime:Number,
									 volume:Number,
									 smoothing:Boolean,
									 deblocking:int,
									 autoSize:Boolean,
									 autoStart:Boolean = true, 
									 autoRewind:Boolean = false )
		{
			_bufferTime = bufferTime;
			_volume = volume;
			_autoSize = autoSize;
			_autoStart = autoStart;
			_autoRewind = autoRewind;
			_seeking = false;
			_resumeAfterSeek = false;
			
			_controls = new VideoPlayerControls( this );
			
			_video = new Video();
			_video.smoothing = smoothing;
			_video.deblocking = deblocking;
			_video.width = width;
			_video.height = height;
			
			this.addChild( _video );
			this.x = x;
			this.y = y;
			
			newVideo( contentPath );
		}
		
		private function onNetStatus( event:NetStatusEvent ):void
		{
			switch( event.info.code )
			{
				case "NetStream.Buffer.Empty" :
					onBufferEmpty();
					break;
					
				case "NetStream.Buffer.Full" :
					onBufferFull();
					break;
					
				case "NetStream.Buffer.Flush" :
					onBufferFlush();
					break;
					
				case "NetStream.Play.Start" :
					initVideo();
					break;
					
				case "NetStream.Play.Stop" :
					onNetStreamStop();
					break;
					
				case "NetStream.Play.Failed" :
					onNetStreamFailed();
					break;
					
				case "NetStream.Play.StreamNotFound" :
					onNetStreamNotFound();
					break;
					
				case "NetStream.Play.Reset" :
					onNetStreamReset();
					break;
					
				case "NetStream.Pause.Notify" :
					onNetStreamPause();
					break;
					
				case "NetStream.Seek.Failed" :
					onNetStreamSeekFailure();
					break;
					
				case "NetStream.Seek.InvalidTime" :
					onNetStreamSeekInvalid();
					break;
					
				case "NetStream.Seek.Notify" :
					onNetStreamSeek();
					break;
					
				case "NetConnection.Connect.Closed" :
					onNetConnectionClose();
					break;
					
				case "NetConnection.Connect.Failed" :
					onNetConnectionFailure();
					break;
					
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
			}
		}
		
		private function onNetConnectionFailure():void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "NetConnection failure." ) );
		}
		
		private function onNetStreamSeek():void
		{
			if( _netStream.time != _lastSeekTime )
			{
				_lastSeekTime = _netStream.time;
				dispatchEvent( new VideoEvent( VideoEvent.SEEKING ) );
			}
		}
		
		private function onNetStreamSeekInvalid():void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Invalid seek time." ) );
		}
		
		private function onNetStreamSeekFailure():void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Seek failure." ) );
		}
		
		private function onNetStreamPause():void
		{
			dispatchEvent( new VideoEvent( VideoEvent.PAUSED ) );
		}
		
		private function onNetStreamNotFound():void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Stream not found: " + _contentPath ) );
		}
		
		private function onNetStreamFailed():void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Stream failure." ) );
		}
		
		private function onNetStreamStop():void
		{	
			_playheadTimer.stop();
			_netStream.pause();
			_status = PAUSED;
			
			if( _autoRewind )
			{
				dispatchEvent( new Event("startFromBeg", false ) );
				_netStream.seek( 0 );
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function onBufferFull():void
		{
			if( _status != VideoPlayer.PLAYING && _status != VideoPlayer.SEEKING )
			{
				trace("onBufferFull.settingit");
				_status = VideoPlayer.PLAYING;
				dispatchEvent( new VideoEvent( VideoEvent.PLAYING ) );
			}
		}
		
		private function onBufferEmpty():void
		{
			if( this.bytesLoaded != this.bytesTotal )
			{
				_status = VideoPlayer.BUFFERING;
				dispatchEvent( new VideoEvent( VideoEvent.BUFFERING ) );
			}
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		/**
		 * @private
		 */
		public function onMetaData( info:Object ):void
		{
			_metaData = new VideoMetaData( info );
			
			if( _autoSize )
			{
				_video.width = _metaData.width;
				_video.height = _metaData.height;
			}
			
			dispatchEvent( new VideoEvent( VideoEvent.META_DATA ) );
		}
		
		/**
		 * @private
		 */
		public function onCuePoint( info:Object ):void
		{
			dispatchEvent( new VideoEvent( VideoEvent.CUE_POINT ) );
		}
		
		
		
		//----------EMPTY HANDLERS---------------------
		private function onNetStreamReset():void
		{
			
		}
		
		private function onNetConnectionClose():void
		{
			
		}
		
		private function onBufferFlush():void
		{
			
		}
		
		public function onXMPData(info:Object):void
		{
			
		}
		//----------EMPTY HANDLERS---------------------
		
		
		
		private function onFirstFrameTimer( event:TimerEvent ):void
		{
			if( _netStream.bytesTotal > 0 )
			{
				_firstFrameTimer.stop();
				
				if ( !_autoStart )
					pause();
				else
					_playheadTimer.start();
			}
		}
		
		private function onLoadTimer( event:TimerEvent ):void
		{
			if( _netStream.bytesTotal > 4 )
			{
				dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, _netStream.bytesLoaded, _netStream.bytesTotal ) )
				
				if( _netStream.bytesLoaded / _netStream.bytesTotal == 1 )
					_loadTimer.stop();
			}
		}
		
		private function onPlayheadTimer( event:TimerEvent = null ):void
		{
			if( _lastPlayheadTime != this.playheadTime && _metaData!=null && !isNaN( _metaData.duration ) )
			{
				if( _status != VideoPlayer.PLAYING )
				{
					_status = VideoPlayer.PLAYING;
					dispatchEvent( new VideoEvent( VideoEvent.PLAYING ) );
				}
				
				_lastPlayheadTime = this.playheadTime;
				
				dispatchEvent( new VideoEvent( VideoEvent.PLAYHEAD_UPDATE ) );
			}
		}
		
		
		/* Private Methods */
		private function connectStream():void
		{
			_netStream = new NetStream( _netConnection );
			_netStream.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			_netStream.client = this;
			_netStream.bufferTime = _bufferTime;
			
			_sound = new SoundTransform( _volume );
			_netStream.soundTransform = _sound;
			
			_video.attachNetStream( _netStream );
			
			_netStream.play( _contentPath );
		}
	
		private function initVideo():void
		{
			_playheadTimer = new Timer( 50 );
			_playheadTimer.addEventListener( TimerEvent.TIMER, onPlayheadTimer );
			
			_firstFrameTimer = new Timer( 10 );
			_firstFrameTimer.addEventListener( TimerEvent.TIMER, onFirstFrameTimer );
			
			_loadTimer = new Timer( 50 );
			_loadTimer.addEventListener( TimerEvent.TIMER, onLoadTimer );
			
			_firstFrameTimer.start();
			_loadTimer.start();
			
			if( _autoStart )
			{
				_status = VideoPlayer.BUFFERING;
				dispatchEvent( new VideoEvent( VideoEvent.BUFFERING ) );
			}
		}
		
		private function newVideo( contentPath:String ):void
		{
			if( contentPath != _contentPath )
			{
				close();
				
				_status = undefined;
				_contentPath = contentPath;
				
				_netConnection = new NetConnection();
				_netConnection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
				_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				_netConnection.connect( null );
			}
		}
		
		private function pauseForContinuousSeeking():void
		{
			_netStream.pause();
			_playheadTimer.stop();
		}
		
		private function resumeAfterContinuousSeeking():void
		{
			trace("resumeAfterContinuousSeeking.settingit");
			_status = VideoPlayer.PLAYING;
			_netStream.resume();
			_playheadTimer.start();
		}
		
		
		/* Public Methods */
		
		/**
		 * Closes the connection with the video file.
		 */
		public function close():void
		{
			if( _netStream )
			{
				_netStream.removeEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
				_netStream.close();
			}
			
			if( _netConnection ) 
			{
				_netConnection.removeEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
				_netConnection.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				_netConnection.close();
			}
		}
		
		/**
		 * Pauses the video.
		 */
		public function pause():void
		{
			if( _status != VideoPlayer.PAUSED )
			{
				_status = VideoPlayer.PAUSED;
				
				_netStream.pause();
				_playheadTimer.stop();
				
				dispatchEvent( new VideoEvent( VideoEvent.PAUSED ) );
			}	
		}
		
		/**
		 * Begins playback of the video.
		 */
		public function play():void
		{
			trace( "VideoPlayer.play: " + _status );
			//if( _status == VideoPlayer.PAUSED )
			//{
				_status = VideoPlayer.PLAYING;
				_netStream.resume();
				_playheadTimer.start();
				
				dispatchEvent( new VideoEvent( VideoEvent.PLAYING ) );
			//}
		}
		
		/**
		 * Rewinds the video to the beginning.
		 */
		public function rewind():void
		{
			trace("rewinding");
			_netStream.seek( 0 );
			dispatchEvent( new VideoEvent( VideoEvent.REWINDING ) );
		}
		
		/**
		 * Prepares the video player for seeking. This method should be called before continuous or
		 * subsequent calls to either the <code>seekSeconds</code> or <code>seekPercent</code> methods.
		 */
		public function startSeek():void
		{
			_resumeAfterSeek = ( _status == VideoPlayer.PLAYING );
			_status = VideoPlayer.SEEKING;
			
			pauseForContinuousSeeking();
		}
		
		/**
		 * Notifies the video player that the continuous seeking has finished.
		 */
		public function stopSeek():void
		{
			if ( _resumeAfterSeek ) resumeAfterContinuousSeeking();
			else _status = VideoPlayer.PAUSED;
		}
		
		/**
		 * Moves the video's playhead to the specified time.
		 * @param time	Time, in seconds, to move the playhead to.
		 */
		public function seekSeconds( time:Number ):void
		{
			_netStream.seek( time );
		}
		
		/**
		 * Moves the video's playhead to the specified percentage.
		 * @param percent	A number between 0 and 1 that represents a fractional position.
		 */
		public function seekPercent( percent:Number ):void
		{
			_netStream.seek( _metaData.duration * percent );
		}
		
		
		/* Gets & Sets */
		
		/**
		 * Equal to true if the video is paused.
		 */
		public function get isPaused():Boolean
		{
			return ( _status == VideoPlayer.PAUSED )
		}
		
		/**
		 * Specifies if the video should automatically rewind when it has completed.
		 */
		public function get autoRewind():Boolean
		{
			return _autoRewind;
		}
		
		public function set autoRewind( v:Boolean ):void
		{
			_autoRewind = v;
		}
		
		/**
		 * The amount of data, in seconds, currently in the buffer.
		 */
		public function get bufferLength():Number
		{
			return _netStream.bufferLength;
		}
		
		/**
		 * Specifies how much data, in seconds, to buffer before allowing playback to begin.
		 */
		public function get bufferTime():Number
		{
			return _netStream.bufferTime;
		}
		
		public function set bufferTime( v:Number ):void
		{
			_netStream.bufferTime = v;
		}
		
		/**
		 * The amount of bytes of the video that have been loaded.
		 */
		public function get bytesLoaded():Number 
		{ 
			return _netStream.bytesLoaded;
		}
		
		/**
		 * The total amount of bytes in the video file.
		 */
		public function get bytesTotal():Number	
		{ 
			return _netStream.bytesTotal; 
		}
		
		/**
		 * Specifies the video player controls manager object.
		 */
		public function get controls():VideoPlayerControls
		{
			return _controls;
		}
		
		public function set controls( v:VideoPlayerControls ):void
		{
			_controls = v;
		}
		
		/**
		 * Specifies the location of the video file to load.
		 */
		public function get contentPath():String
		{
			return _contentPath;
		}
		
		public function set contentPath( v:String ):void
		{
			newVideo( v );
		}
		
		/**
		 * The current frames per second at which the video is playing at.
		 */
		public function get currentFPS():Number
		{
			return _netStream.currentFPS;
		}
		
		/**
		 * Specifies the type of filter applied to decoded video as part of post-processing
		 */
		public function get deblocking():int
		{
			return _video.deblocking;
		}
		
		public function set deblocking( v:int ):void
		{
			_video.deblocking = v;
		}
		
		/**
		 * The duration, in seconds, of the video.
		 */
		public function get duration():Number
		{
			return _metaData.duration;
		}
		
		/**
		 * The video meta data.
		 */
		public function get metaData():VideoMetaData
		{
			return _metaData;
		}
		
		/**
		 * The position of the playhead expressed as a value between 0 and 1.
		 */
		public function get playheadPercentage():Number 
		{ 
			if (isNaN(_netStream.time) || _metaData == null ) {
				return 0;
			}
			return _netStream.time / _metaData.duration; 
		}
		
		/**
		 * Specifies the position of the playhead expressed in seconds.
		 */
		public function get playheadTime():Number
		{
			return ( _netStream != null ) ? _netStream.time : 0;
		}
		
		public function set playheadTime( v:Number ):void
		{
			seekSeconds( v );
		}
		
		/**
		 * Specifies whether the video should be smoothed (interpolated) when it is scaled.
		 */
		public function get smoothing():Boolean
		{
			return _video.smoothing;
		}
		
		public function set smoothing( v:Boolean ):void
		{
			_video.smoothing = v;
		}
		
		/**
		 * Specifies the volume of the video.
		 */
		public function get volume():Number
		{
			return _netStream.soundTransform.volume;
		}
		
		public function set volume( v:Number ):void
		{
			_netStream.soundTransform = new SoundTransform( v );
		}
		
		/**
		 * Specefies the width of the video.
		 */
		override public function get width():Number
		{
			return _video.width;
		}
		
		override public function set width( v:Number ):void
		{
			_video.width = v;
		}
		
		/**
		 * Specefies the height of the video.
		 */
		override public function get height():Number
		{
			return _video.height;
		}
		
		override public function set height( v:Number ):void
		{
			_video.height = v;
		}
		
		/**
		 * The current status/state of the video player.
		 */
		public function get status():String
		{
			return _status;
		}
		
		public function get video():Video {
			return _video;
		}
		
	}
	
}