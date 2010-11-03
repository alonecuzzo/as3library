package com.rokkan.media 
{
	/**
	 * The <code>VideoMetaData</code> class holds the meta data received from a video file.
	 */
	public class VideoMetaData 
	{
		
		/**
		 * The encoded frame rate of the video file.
		 */
		public var framerate:Number;
		
		/**
		 * The duration of the video.
		 */
		public var duration:Number;
		
		/**
		 * The width in pixels of the video file.
		 */
		public var width:Number;
		
		/**
		 * The height in pixels of the video file.
		 */
		public var height:Number;
		
		/**
		 * The max video data rate the video was encoded at.
		 */
		public var videoDataRate:Number;
		
		/**
		 * The audio data rate the video was encoded at.
		 */
		public var audioDataRate:Number;
		
		/**
		 * The date the video was created.
		 */
		public var creationDate:String;
		
		/**
		 * Specifies if the video can seek to its end.
		 */
		public var canSeekToEnd:Boolean;
		
		/**
		 * Video codec ID.
		 */
		public var videoCodecID:Number;
		
		/**
		 * Audio codec ID.
		 */
		public var audioCodecID:Number;
		
		/**
		 * Creates an instance of the <code>VideoMetaData</code> class.
		 * @param	metaInfo	The meta data info object received from the video file
		 */
		public function VideoMetaData( metaInfo:Object )
		{
			duration = isNaN( metaInfo.duration ) ? null : metaInfo.duration;
			framerate = isNaN( metaInfo.framerate ) ? null : metaInfo.framerate;
			width = isNaN( metaInfo.width ) ? null : metaInfo.width;
			height = isNaN( metaInfo.height )? null : metaInfo.height;
			videoDataRate = isNaN( metaInfo.videoDataRate )? null : metaInfo.videoDataRate;
			audioDataRate = isNaN( metaInfo.audioDataRate ) ? null : metaInfo.audioDataRate;
			creationDate = ( metaInfo.creationDate == undefined ) ? null : metaInfo.creationDate;
			canSeekToEnd = ( metaInfo.canSeekToEnd == undefined ) ? false : metaInfo.canSeekToEnd;
			videoCodecID = isNaN( metaInfo.videocodecid ) ? null : metaInfo.videocodecid;
			audioCodecID = isNaN( metaInfo.audiocodecid ) ? null : metaInfo.audiocodecid;
		}
		
	}
	
}
