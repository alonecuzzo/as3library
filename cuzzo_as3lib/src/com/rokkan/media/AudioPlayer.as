package com.rokkan.media 
{
	import com.rokkan.events.AudioEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	
	/**
     * Dispatched when the audio playhead is manually adjusted.
     * @eventType com.rokkan.events.AudioEvent.SEEKING
     */
	[Event(name="seeking", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio is paused.
     * @eventType com.rokkan.events.AudioEvent.PAUSED
     */
	[Event(name="paused", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio begins playback.
     * @eventType com.rokkan.events.AudioEvent.PLAYING
     */
	[Event(name="playing", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio is being rewinded.
     * @eventType com.rokkan.events.AudioEvent.REWINDING
     */
	[Event(name="rewinding", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Continually dispatched as the audio playhead moves during playback.
     * @eventType com.rokkan.events.AudioEvent.PLAYHEAD_UPDATE
     */
	[Event(name="playheadUpdate", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio reaches a cue point.
     * @eventType com.rokkan.events.AudioEvent.CUE_POINT
     */
	[Event(name="cuePoint", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio's ID3 meta data has been received.
     * @eventType com.rokkan.events.AudioEvent.ID3
     */
	[Event(name="id3", type="com.rokkan.events.AudioEvent")]
	
	/**
     * Dispatched when the audio finishes playback.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
     * Continually dispatched as the audio file is loading.
     * @eventType flash.events.ProgressEvent.PROGRESS
     */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
     * Dispatched upon I/0 Error
     * @eventType flash.events.ErrorEvent.ERROR
     */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
     * Dispatched when a security error occurs, most commonly when a crossdomain.xml file prohibits the
	 * loading of audio assets.
     * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
     */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * The <code>AudioPlayer</code> class is a lightweight object that will playback .mp3 audio
	 * files over an HTTP connection.
	 */
	
	public class AudioPlayer extends EventDispatcher
	{
		
		/**
		 * String representing the <code>PAUSED</code> state of the audio player. An audio is paused when
		 * the playhead is not moving.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * String representing the <code>PLAYING</code> state of the audio player. An audio is playing
		 * when the audio's playhead is continuously moving on its own behalf.
		 */
		public static const PLAYING:String = "playing";
		
		/**
		 * String representing the <code>COMPLETE</code> state of the audio player. An audio is complete
		 * when the playhead has reached the length of the audio's duration.
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * String representing the <code>SEEKING</code> state of the audio player. An audio is seeking
		 * when the audio's playhead is manually adjusted by a call to the <code>seekSeconds</code> or 
		 * <code>seekPercent</code> methods.
		 */
		public static const SEEKING:String = "seeking";
		
		
		private var _autoStart:Boolean;
		private var _bufferTime:Number;
		private var _contentPath:String;
		private var _context:SoundLoaderContext;
		private var _controls:AudioPlayerControls;
		private var _duration:Number;
		private var _lastPlayheadTime:Number = -1;
		private var _muted:Boolean = false;
		private var _playheadTimer:Timer;
		private var _resumeAfterSeek:Boolean;
		private var _request:URLRequest;
		private var _seeking:Boolean;
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _startTime:Number;
		private var _status:String;
		private var _unmuteVolume:Number;
		
		
		/**
		 * Create an instance of the <code>AudioPlayer</code> class.
		 * @param	contentPath	The location of the audio file to load
		 * @param	bufferTime	The amount of audio time that should be buffered before playback in milliseconds
		 * @param	volume		The initial volume of the audio
		 * @param	autoStart	Specifies whether to automatically begin playing the audio once loaded
		 * @param	autoRewind	Specifies whether to automatically rewind to beginning upon reaching the end
		 * @param	startTime	Specifies the point in milliseconds at which the audio should begin playback
		 */
		public function AudioPlayer( contentPath:String,
									 bufferTime:Number = 5,
									 volume:Number = 1,
									 pan:Number = 0,
									 autoStart:Boolean = true )
		{
			_bufferTime = bufferTime;
			_autoStart = autoStart;
			
			_soundTransform = new SoundTransform( volume, pan );
			
			newSound( contentPath );
		}
		
		
		
		
		private function onIOError( event:IOErrorEvent ):void 
		{
			_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_sound.removeEventListener( Event.OPEN, onOpen );
			
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "I/O Error" ) );
		}
		
		private function onOpen( event:Event ):void 
		{
			_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_sound.removeEventListener( Event.OPEN, onOpen );
			
			dispatchEvent( new Event( Event.OPEN, false, false ) );
			
			soundReady();
		}
		
		private function onID3( event:Event ):void 
		{
			_sound.removeEventListener( Event.ID3, onID3 );
			dispatchEvent( new AudioEvent( AudioEvent.ID3 ) );
		}
		
		private function onSoundComplete( event:Event ):void 
		{
			_status = AudioPlayer.COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function onProgress( event:ProgressEvent ):void 
		{
			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, _sound.bytesLoaded, _sound.bytesTotal ) );
		}
		
		private function onLoadComplete( event:Event ):void 
		{
			_duration = _sound.length;
		}
		
		private function onPlayheadTimer( event:TimerEvent = null ):void
		{
			if( _lastPlayheadTime != _soundChannel.position && !isNaN( _duration ) )
			{
				if( _status != AudioPlayer.PLAYING )
				{
					_status = AudioPlayer.PLAYING;
					dispatchEvent( new AudioEvent( AudioEvent.PLAYING ) );
				}
				
				_lastPlayheadTime = _soundChannel.position;
				dispatchEvent( new AudioEvent( AudioEvent.PLAYHEAD_UPDATE ) );
			}
		}
		
		
		
		private function newSound( contentPath:String ):void
		{
			if ( contentPath != _contentPath )
			{
				close();
				
				_status = AudioPlayer.PAUSED;
				_seeking = _resumeAfterSeek = false;
				_lastPlayheadTime = 0;
				
				_contentPath = contentPath;
				
				_request = new URLRequest( _contentPath );
				_context = new SoundLoaderContext( _bufferTime );
				
				_sound = new Sound( _request, _context );
				
				_sound.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				_sound.addEventListener( Event.OPEN, onOpen );
			}
		}
		
		
		private function soundReady():void
		{
			_sound.addEventListener( ProgressEvent.PROGRESS, onProgress );
			_sound.addEventListener( Event.COMPLETE, onLoadComplete );
			_sound.addEventListener( Event.ID3, onID3 );
			
			_playheadTimer = new Timer( 50 );
			_playheadTimer.addEventListener( TimerEvent.TIMER, onPlayheadTimer );
			
			startSound();
			
			_status = AudioPlayer.PLAYING;
			
			if ( !_autoStart )
			{
				pause();
				_lastPlayheadTime = 0;
			}
		}
		
		private function startSound():void
		{
			_soundChannel = _sound.play( _lastPlayheadTime, 0, _soundTransform );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			_playheadTimer.start();
		}
		
		private function stopSound():void
		{
			_soundChannel.stop();
			_playheadTimer.stop();
		}
		
		internal function startSeek():void
		{
			_resumeAfterSeek = ( _status == AudioPlayer.PLAYING );
			_status = AudioPlayer.SEEKING;
			stopSound();
		}

		internal function endSeek( resumePoint:Number ):void
		{
			_lastPlayheadTime = resumePoint * _duration;
			
			if ( _resumeAfterSeek ) 
			{
				startSound();
				_status = AudioPlayer.PLAYING;
			}
			else
			{
				_status = AudioPlayer.PAUSED;
			}
		}
		
		
		/**
		 * Pauses the playback of the audio.
		 */
		public function pause():void
		{
			if( _status != AudioPlayer.PAUSED )
			{
				_status = AudioPlayer.PAUSED;
				
				_lastPlayheadTime = _soundChannel.position;
				
				stopSound();
				
				dispatchEvent( new AudioEvent( AudioEvent.PAUSED ) );
			}	
		}
		
		/**
		 * Begins or resumes playback of the audio.
		 */
		public function play():void
		{
			if( _status != AudioPlayer.PLAYING )
			{
				_status = AudioPlayer.PLAYING;
				
				startSound();
				
				dispatchEvent( new AudioEvent( AudioEvent.PLAYING ) );
			}
		}

		/**
		 * Rewinds the audio to the beginning.
		 */
		public function rewind():void
		{
			stopSound();
			_lastPlayheadTime = 0;
			if ( _status == AudioPlayer.PLAYING ) startSound();
			dispatchEvent( new AudioEvent( AudioEvent.REWINDING ) );
		}
		
		/**
		 * Mutes the audio.
		 */
		public function mute():void
		{
			_muted = true;
			_unmuteVolume = volume;
			volume = 0;
		}
		
		/**
		 * Unmutes the audio.
		 */
		public function unmute():void
		{
			_muted = false;
			volume = _unmuteVolume;
		}
		
		/**
		 * Changes the point at which the audio will resume playing to a time in seconds. Playback
		 * will not resume until the <code>play()</code> function is called.
		 * @param time	Time, in seconds, to move the playhead to.
		 */
		public function seekSeconds( time:Number ):void
		{
			stopSound();
			_lastPlayheadTime = time;
			startSound();
		}
		
		/**
		 * Changes the point at which the audio will resume playing to a percentage of the total 
		 * duration. Playback will not resume until the <code>play()</code> function is called.
		 * @param percent	A number between 0 and 1 that represents a fractional position.
		 */
		public function seekPercent( percent:Number ):void
		{
			stopSound();
			_lastPlayheadTime = _duration * percent;
			startSound();
		}
		
		/**
		 * Closes the connection with the audio file.
		 */
		public function close():void
		{
			if ( _sound )
			{
				_sound.close();
				_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				_sound.removeEventListener( Event.OPEN, onOpen );
				_sound.removeEventListener( ProgressEvent.PROGRESS, onProgress );
				_sound.removeEventListener( Event.ID3, onID3 );
				
				if ( _playheadTimer ) _playheadTimer.removeEventListener( TimerEvent.TIMER, onPlayheadTimer );
				if( _soundChannel ) _soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			}
		}
		
		
		/* Gets & Sets */
		
		/**
		 * Audio volume. A number between 0 and 1.
		 */
		public function get volume():Number 
		{ 
			return _soundTransform.volume; 
		}
		
		public function set volume( value:Number ):void 
		{
			_soundTransform.volume = value;
			_soundChannel.soundTransform = _soundTransform;
		}
		
		/**
		 * Audio panning. A number between -1 and 1 representing the balance between left and right speakers.
		 */
		public function get pan():Number
		{
			return _soundTransform.pan;
		}
		
		public function set pan( value:Number):void
		{
			_soundTransform.pan = value;
			_soundChannel.soundTransform = _soundTransform;
		}
		
		/**
		 * Audio status. Defined by class constants.
		 */
		public function get status():String 
		{ 
			return _status; 
		}
		
		/**
		 * The amount of bytes loaded.
		 */
		public function get bytesLoaded():Number 
		{ 
			return _sound.bytesLoaded 
		}
		
		/**
		 * The total amount of bytes.
		 */
		public function get bytesTotal():Number 
		{ 
			return _sound.bytesTotal 
		}
		
		/**
		 * The audio player's controls mediator.
		 */
		public function get controls():AudioPlayerControls 
		{ 
			if( !_controls ) _controls = new AudioPlayerControls( this );
			return _controls; 
		}
		
		/**
		 * The current position of the playhead in seconds.
		 */
		public function get playheadTime():Number
		{
			return ( _soundChannel != null ) ? _soundChannel.position : 0;
		}
		
		/**
		 * The duration of the audio.
		 */
		public function get duration():Number 
		{ 
			return _duration; 
		}
		
		/**
		 * ID3 meta data object.
		 */
		public function get id3info():ID3Info 
		{ 
			return _sound.id3; 
		}
		
		/**
		 * Indicates if the audio is muted or not.
		 */
		public function get muted():Boolean  
		{
			return _muted;
		}
		
	}
	
}