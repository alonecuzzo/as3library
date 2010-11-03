package com.rokkan.media 
{
	
	import com.rokkan.control.interfaces.IButton;
	import com.rokkan.control.interfaces.IComponent;
	import com.rokkan.control.interfaces.IProgressIndicator;
	import com.rokkan.control.interfaces.ISlider;
	import com.rokkan.events.SliderEvent;
	import com.rokkan.events.VideoEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	/**
	 * The <code>VideoPlayerControls</code> class manages the controls for a video player. Each
	 * control must implement a particular interface and not stray from assumed functionality. If 
	 * a control is developed properly, there should not be the need to configure event handlers for
	 * that control as this class will configure and respond to the assumed mouse interactions. In
	 * addition to the interfaces, while not required, it is strongly recommended to use the abstracted 
	 * control classes when building controls for the video player.
	 * @see com.rokkan.media.VideoPlayer
	 * @see com.rokkan.control.interfaces.IButton
	 * @see com.rokkan.control.interfaces.IComponent
	 * @see com.rokkan.control.interfaces.IProgressIndicator
	 * @see com.rokkan.control.interfaces.ISlider
	 */
	public class VideoPlayerControls 
	{
		
		private var _wasPaused:Boolean;
		private var _videoPlayer:VideoPlayer;
		private var _playButton:IButton;
		private var _pauseButton:IButton;
		private var _playheadProgressBar:IProgressIndicator;
		private var _playheadSlider:ISlider;
		private var _loadProgressBar:IProgressIndicator;
		private var _bufferingIndicator:IComponent;
		private var _volumeControl:ISlider;
		
		/**
		 * Creates a new instance of the <code>VideoPlayerControls</code> class.
		 * @param	videoPlayer	A <code>VideoPlayer</code> instance
		 */
		public function VideoPlayerControls( videoPlayer:VideoPlayer ) 
		{
			_videoPlayer = videoPlayer;
			_videoPlayer.addEventListener( VideoEvent.PLAYHEAD_UPDATE, onPlayheadUpdate );
			_videoPlayer.addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			_videoPlayer.addEventListener( VideoEvent.BUFFERING, onBuffering );
			_videoPlayer.addEventListener( VideoEvent.PLAYING, onPlaying );
			_videoPlayer.addEventListener( Event.COMPLETE, onComplete );
		}
		
		/* Event Handlers */
		private function onPlayBtnClick( event:MouseEvent ):void
		{
			_videoPlayer.play();
			_playButton.disable();
			
			if ( _pauseButton )
				_pauseButton.enable();
		}
		
		private function onPauseBtnClick( event:MouseEvent ):void
		{
			_videoPlayer.pause();
			_pauseButton.disable();
			
			if ( _playButton )
				_playButton.enable();
		}
		
		private function onSliderPress( event:SliderEvent ):void
		{
			_videoPlayer.startSeek();
			_videoPlayer.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onSliderRelease( event:SliderEvent ):void
		{
			_videoPlayer.stopSeek();
			_videoPlayer.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if ( _playheadProgressBar )
				_playheadProgressBar.progress = _playheadSlider.position;
		}
		
		private function onSliderChange( event:Event ):void
		{
			_videoPlayer.seekPercent( _playheadSlider.position );
		}
		
		private function onVolumeChange( event:Event ):void
		{
			_videoPlayer.volume = _volumeControl.position;
		}
		
		private function onLoadProgress( event:ProgressEvent ):void
		{
			if ( _loadProgressBar )
				_loadProgressBar.progress = event.bytesLoaded / event.bytesTotal;
		}
		
		private function onPlayheadUpdate( event:VideoEvent ):void
		{
			var p:Number = _videoPlayer.playheadTime / _videoPlayer.duration;
			
			if( _playheadSlider )
				_playheadSlider.position = p;
				
			if ( _playheadProgressBar )
				_playheadProgressBar.progress = p;
		}
		
		private function onPlaying( event:VideoEvent ):void
		{
			if( _bufferingIndicator )
				_bufferingIndicator.hide();
		}
		
		private function onBuffering( event:VideoEvent ):void
		{
			if( _bufferingIndicator )
				_bufferingIndicator.show();
		}
		
		private function onComplete( event:Event ):void 
		{
			if ( _videoPlayer.autoRewind)
			{
				if( _playheadSlider ) _playheadSlider.position = 0;
				if ( _playheadProgressBar ) _playheadProgressBar.progress = 0;
			}
			
		}
		
		
		/* Gets & Sets */
		
		/**
		 * Specifies the button to use as the video player's play button. When the play button's
		 * <code>MouseEvent.CLICK</code> event is dispatched, the video player will attempt to
		 * begin playback of the video and also disable the button using the button's <code>disable()</code> 
		 * method. When the video is paused, the button will attempt to be enabled via the button's 
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
				
				if ( _videoPlayer.isPaused )
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
		 * Specifies the button to use as the video player's pause button. When the pause button's
		 * <code>MouseEvent.CLICK</code> event is dispatched, the video player will attempt to
		 * pause the video and also disable the button using the button's <code>disable()</code> 
		 * method. When the video resumes playback, the button will attempt to be enabled via 
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
				
				if ( _videoPlayer.isPaused )
					_pauseButton.disable();
				else
					_pauseButton.enable();
			}
		}
		
		/**
		 * Specifies the slider to use as the video player's playhead slider (sometimes called a 
		 * scrubber). As the slider's <code>Event.CHANGE</code> event is dispatched, the video player
		 * will use the slider's <code>position</code> property to seek to a position in the video. 
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
				_playheadSlider.removeEventListener( Event.CHANGE, onSliderChange );
			}
			
			_playheadSlider = v;
			
			if ( _playheadSlider )
			{
				_playheadSlider.addEventListener( SliderEvent.THUMB_PRESS, onSliderPress );
				_playheadSlider.addEventListener( SliderEvent.THUMB_RELEASE, onSliderRelease );
				_playheadSlider.addEventListener( Event.CHANGE, onSliderChange );
			}
		}
		
		/**
		 * Specifies the progress bar to display the loading progress of the video file. The 
		 * progress bar's <code>progress</code> property will be changed as the video player's 
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
		 * Specifies the progress bar to display the playhead progress of the video player. The 
		 * progress bar's <code>progress</code> property will be changed as the video player's 
		 * <code>VideoEvent.PLAYHEAD_UPDATE</code> event is dispatched. This progress bar must 
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
		 * Specifies the slider to use and the volume control for the video player. The volume of the
		 * video player will be adjusted using the slider's <code>position</code> property when the slider's 
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
		 * Specifies the buffering indicator to use for the video player. When the video is buffering
		 * the specified buffering indicator will attempt to be displayed using the indicator's 
		 * <code>show()</code> method. When the buffering has stopped the indicator will attempt to
		 * be hidden using the indicator's <code>hide()</code> method., This control must implement 
		 * the <code>IComponent</code> interface. 
		 * @see com.rokkan.control.interfaces.IComponent
		 */
		public function get bufferingIndicator():IComponent
		{
			return _bufferingIndicator;
		}
		
		public function set bufferingIndicator( v:IComponent ):void
		{
			_bufferingIndicator = v;
		}
		
	}
	
}
