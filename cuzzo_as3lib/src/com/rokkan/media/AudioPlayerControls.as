package com.rokkan.media 
{
	import com.rokkan.control.interfaces.IButton;
	import com.rokkan.control.interfaces.IComponent;
	import com.rokkan.control.interfaces.IProgressIndicator;
	import com.rokkan.control.interfaces.ISlider;
	import com.rokkan.control.interfaces.IValueSlider;
	import com.rokkan.events.AudioEvent;
	import com.rokkan.events.SliderEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	
	public class AudioPlayerControls 
	{
		private var _wasPaused:Boolean;
		private var _isMuted:Boolean;
		private var _previousVolume:Number;
		private var _audioPlayer:AudioPlayer;
		private var _playButton:IButton;
		private var _pauseButton:IButton;
		private var _muteButton:IButton;
		private var _panControl:IValueSlider;
		private var _volumeControl:ISlider;
		private var _playheadSlider:ISlider;
		private var _playheadProgressBar:IProgressIndicator;
		private var _loadProgressBar:IProgressIndicator;
		
		
		public function AudioPlayerControls( audioPlayer:AudioPlayer ) 
		{
			_audioPlayer = audioPlayer;
			
			_isMuted = ( _audioPlayer.volume == 0 ) ? true : false;
			_previousVolume = ( _audioPlayer.volume == 0 ) ? .5 : _audioPlayer.volume;
			
			_audioPlayer.addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			_audioPlayer.addEventListener( AudioEvent.PLAYHEAD_UPDATE, onPlayheadUpdate );
		}
		
		/* Event Handlers */
		
		private function onPlayBtnClick( event:MouseEvent ):void
		{
			_audioPlayer.play();
			_playButton.disable();
			
			if ( _pauseButton )
				_pauseButton.enable();
		}
		
		private function onPauseBtnClick( event:MouseEvent ):void
		{
			_audioPlayer.pause();
			_pauseButton.disable();
			
			if ( _playButton )
				_playButton.enable();
		}
		
		private function onMuteBtnClick( event:MouseEvent ):void
		{			
			if ( _audioPlayer.muted ) _audioPlayer.unmute();
			else _audioPlayer.mute();
		}
		
		private function onSliderPress( event:SliderEvent ):void
		{
			_audioPlayer.startSeek();
		}
		
		private function onSliderRelease( event:SliderEvent ):void
		{
			_audioPlayer.endSeek( _playheadSlider.position );
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if ( _playheadProgressBar )
				_playheadProgressBar.progress = _playheadSlider.position;
		}
		
		private function onVolumeChange( event:Event ):void
		{
			_audioPlayer.volume = _volumeControl.position;
		}
		
		private function onPanChange( event:Event ):void
		{
			_audioPlayer.pan = _panControl.value;
		}
		
		private function onLoadProgress( event:ProgressEvent ):void
		{
			if ( _loadProgressBar )
				_loadProgressBar.progress = event.bytesLoaded / event.bytesTotal;
		}
		
		private function onPlayheadUpdate( event:AudioEvent ):void
		{
			var p:Number = _audioPlayer.playheadTime / _audioPlayer.duration;
			
			if( _playheadSlider )
				_playheadSlider.position = p;
				
			if ( _playheadProgressBar )
				_playheadProgressBar.progress = p;
		}
		
		/* Gets & Sets */
		
		/**
		 * Specifies the button to use as the audio player's play button. When the play button's
		 * <code>MouseEvent.CLICK</code> event is dispatched, the audio player will attempt to
		 * begin playback of the audio and also disable the button using the button's <code>disable()</code> 
		 * method. When the audio is paused, the button will attempt to be enabled via the button's 
		 * <code>enable()</code> method.This button must implement the <code>IButton</code> interface. 
		 * It is also recommended that this button extend the <code>AbstractButton</code> class.
		 * @see com.rokkan.control.interfaces.IButton
		 * @see com.rokkan.control.abstract.AbstractButton
		 */
		public function set playButton( v:IButton ):void
		{
			if( _playButton )
				_playButton.removeEventListener( MouseEvent.CLICK, onPlayBtnClick );
			
			_playButton = v;
			
			if ( _playButton )
			{
				_playButton.addEventListener( MouseEvent.CLICK, onPlayBtnClick );
				
				if ( _audioPlayer.status == AudioPlayer.PAUSED )
					_playButton.enable();
				else
					_playButton.disable();
			}
		}
		
		public function get playButton():IButton
		{
			return _playButton;
		}
		
		/**
		 * Specifies the button to use as the audio player's pause button. When the pause button's
		 * <code>MouseEvent.CLICK</code> event is dispatched, the audio player will attempt to
		 * pause the audio and also disable the button using the button's <code>disable()</code> 
		 * method. When the audio resumes playback, the button will attempt to be enabled via 
		 * the button's <code>enable()</code> method. This button must implement the 
		 * <code>IButton</code> interface. It is also recommended that this button extend the 
		 * <code>AbstractButton</code> class.
		 * @see com.rokkan.control.interfaces.IButton
		 * @see com.rokkan.control.abstract.AbstractButton
		 */
		public function get pauseButton():IButton
		{
			return _pauseButton;
		}
		
		public function set pauseButton( v:IButton ):void
		{
			if( _pauseButton )
				_pauseButton.removeEventListener( MouseEvent.CLICK, onPauseBtnClick );
			
			_pauseButton = v;
			
			if ( _pauseButton )
			{
				_pauseButton.addEventListener( MouseEvent.CLICK, onPauseBtnClick );
				
				if ( _audioPlayer.status == AudioPlayer.PAUSED )
					_pauseButton.disable();
				else
					_pauseButton.enable();
			}
		}
		
		/**
		 * Specifies the button to use as the audio player's mute button. When the mute button's
		 * <code>MouseEvent.CLICK</code> event is dispatched, the audio player will attempt to 
		 * mute or unmute the audio. This button must implement the <code>IButton</code> interface. It 
		 * is also recommended that this button extend the <code>AbstractButton</code> class.
		 * @see com.rokkan.control.interfaces.IButton
		 * @see com.rokkan.control.abstract.AbstractButton
		 */
		
		public function get muteButton():IButton
		{
			return _muteButton;
		}
		
		public function set muteButton( v:IButton ):void
		{
			if ( _muteButton )
				_muteButton.removeEventListener( MouseEvent.CLICK, onMuteBtnClick );
				
			_muteButton = v;
			
			if ( _muteButton )
				_muteButton.addEventListener( MouseEvent.CLICK, onMuteBtnClick );
		}
		 
		 
		/**
		 * Specifies the slider to use as the audio player's playhead slider (sometimes called a 
		 * scrubber). As the slider's <code>Event.CHANGE</code> event is dispatched, the audio player
		 * will use the slider's <code>position</code> property to seek to a position in the audio. 
		 * This slider must implement the <code>ISlider</code> interface. It is also recommended that 
		 * this button extend the <code>AbstractSlider</code> class.
		 * @see com.rokkan.control.interfaces.ISlider
		 * @see com.rokkan.control.abstract.AbstractSlider
		 */
		public function get playheadSlider():ISlider
		{
			return _playheadSlider;
		}
		
		public function set playheadSlider( v:ISlider ):void
		{
			if( _playheadSlider )
			{
				_playheadSlider.removeEventListener( SliderEvent.THUMB_PRESS, onSliderPress );
				_playheadSlider.removeEventListener( SliderEvent.THUMB_RELEASE, onSliderRelease );
			}
			
			_playheadSlider = v;
			
			if ( _playheadSlider )
			{
				_playheadSlider.addEventListener( SliderEvent.THUMB_PRESS, onSliderPress );
				_playheadSlider.addEventListener( SliderEvent.THUMB_RELEASE, onSliderRelease );
			}
		}
		
		/**
		 * Specifies the progress bar to display the loading progress of the audio file. The 
		 * progress bar's <code>progress</code> property will be changed as the audio player's 
		 * <code>ProgressEvent.PROGRESS</code> event is dispatched. This progress bar must 
		 * implement the <code>IProgressIndicator</code> interface. It is also recommended that 
		 * this button extend the <code>AbstractProgressBar</code> class.
		 * @see com.rokkan.control.interfaces.IProgressIndicator
		 * @see com.rokkan.control.abstract.AbstractProgressBar
		 */
		public function get loadProgressBar():IProgressIndicator
		{
			return _loadProgressBar;
		}
		
		public function set loadProgressBar( v:IProgressIndicator ):void
		{
			_loadProgressBar = v;
		}
		
		/**
		 * Specifies the progress bar to display the playhead progress of the audio player. The 
		 * progress bar's <code>progress</code> property will be changed as the audio player's 
		 * <code>audioEvent.PLAYHEAD_UPDATE</code> event is dispatched. This progress bar must 
		 * implement the <code>IProgressIndicator</code> interface. It is also recommended that 
		 * this button extend the <code>AbstractProgressBar</code> class.
		 * @see com.rokkan.control.interfaces.IProgressIndicator
		 * @see com.rokkan.control.abstract.AbstractProgressBar
		 */
		public function get playheadProgressBar():IProgressIndicator
		{
			return _playheadProgressBar;
		}
		
		public function set playheadProgressBar( v:IProgressIndicator ):void
		{
			_playheadProgressBar = v;
		}
		
		/**
		 * Specifies the slider to use and the volume control for the audio player. The volume of the
		 * audio player will be adjusted using the slider's <code>position</code> property when the slider's 
		 * <code>Event.CHANGE</code> event is dispatched. This slider must implement the <code>ISlider</code> 
		 * interface. It is also recommended that this slider extend the <code>AbstractSlider</code> class.
		 * @see com.rokkan.control.interfaces.ISlider
		 * @see com.rokkan.control.abstract.AbstractSlider
		 */
		public function get volumeControl():ISlider
		{
			return _volumeControl;
		}
		
		public function set volumeControl( v:ISlider ):void
		{
			if( _volumeControl )
				_volumeControl.removeEventListener( Event.CHANGE, onVolumeChange );
			
			_volumeControl = v;
			
			if( _volumeControl )
				_volumeControl.addEventListener( Event.CHANGE, onVolumeChange );
		}
		
		/**
		 * Specifies the slider to use and the pan control for the audio player. The pan of the
		 * audio player will be adjusted using the slider's <code>position</code> property when the slider's 
		 * <code>Event.CHANGE</code> event is dispatched. This slider must implement the <code>ISlider</code> 
		 * interface. It is also recommended that this slider extend the <code>AbstractSlider</code> class.
		 * @see com.rokkan.control.interfaces.ISlider
		 * @see com.rokkan.control.abstract.AbstractSlider
		 */
		public function get panControl():IValueSlider
		{
			return _panControl;
		}
		
		public function set panControl( v:IValueSlider ):void
		{
			if( _panControl )
				_panControl.removeEventListener( Event.CHANGE, onPanChange );
			
			_panControl = v;
			
			if( _panControl )
				_panControl.addEventListener( Event.CHANGE, onPanChange );
		}
		
		
	}
}