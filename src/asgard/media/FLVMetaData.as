/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;

/**
 * The FLVMetaData instances contains all datas values injected in the external FLV video.
 * <p>More informations in the <a href='http://www.buraks.com/flvmdi/'>flvmdi page</a> write by Burak.</p>
 * @author eKameleon
 */
class asgard.media.FLVMetaData extends CoreObject 
{
	
	/**
	 * Creates a new FLVMetaData object.
	 * @param o An object with all MetaData properties to fill this instance.
	 */
	public function FLVMetaData( o ) 
	{
		for (var prop:String in o)
		{
			this[prop] = o[prop] ;	
		}
	}
	
	/**
	 * Audio codec ID number used in the FLV. (Uncompressed = 0, ADPCM = 1, MP3 = 2, NellyMoser = 5 and 6).
	 * @see asgard.media.AudioCodec
	 */
	public var audiocodecid:Number ;
	
	/**
	 * The audio data rate (Defaults to 0).
	 */
	public var audiodatarate:Number ;
	
	/**
	 * Audio delay in seconds. Flash 8 encoder delays the video for better synch with audio 
	 * (Audio and video does not start both at time 0, Video starts a bit later). 
	 * This value is also important for Flash 8 Video Encoder injected Cue Points, because logical time of the cue points does not correspond to physical time they are inserted in the FLV. 
	 * (Cue points are injected before encoding, when the video is shifted by 'audio delay' seconds, cue points are also shifted and their physical time in the FLV changes).
	 */
	public var audiodelay:Number ;
	
	/**
	 * The audio data size.
	 */
	public var audiosize:Number ;
	
	/**
	 * Is {@code true} if the last video tag is a key frame and hence can be 'seek'ed.
	 */
	public var canSeekToEnd:Boolean ;
	
	/**
	 * The date of creation of the video.
	 */
	public var creationdate:String ;

	/**
	 * The data size of the video.
	 */
	public var datasize:Number ;
	
	/**
	 * Length of the FLV in seconds. FLVMDI computes this value.
	 */
	public var duration:Number ;

	/**
	 * The size of the file.
	 */
	public var filesize:Number ;

	/**
	 * The framerate of the video.
	 */
	public var framerate:Number ;

	/**
	 * Height of the video in pixels. (Flash exporter 1.1 sets this to 0).
	 */
	public var height:Number ;

	/**
	 * This object is added only if you specify the /k switch. 
	 * 'keyframes' is known to FLVMDI and if /k switch is not specified, 'keyframes' object will be deleted.
	 * 'keyframes' object has 2 arrays : 'filepositions' and 'times'. 
	 * Both arrays have the same number of elements, which is equal to the number of key frames in the FLV.
	 * Values in times array are in 'seconds'. Each correspond to the timestamp of the n'th key frame.
	 * Values in filepositions array are in 'bytes'. Each correspond to the fileposition of the nth key frame video tag (which starts with byte tag type 9).
	 */
	public var keyframes:Object ;

	/**
	 * TimeStamp of the last video tag which is a key frame. 
	 * This info might be needed because seeking a frame after this time usually does not work.
	 */
	public var lastkeyframetimestamp:Number ;

	/**
	 * TimeStamp of the last tag in the FLV file. 
	 */
	public var lasttimestamp:Number ;

	/**
	 * Date and time metadata added. (Note that this is not of type string like 'creationdate').
	 */
	public var metadatacreator:Date ;

	/**
	 * The metadata date of the video.
	 */
	public var metadatadate:Date ;

	/**
	 * Video codec ID number used in the FLV. (Sorenson H.263 =2, Screen Video =3, On2 VP6 = 4 and 5, Screen Video V2 = 6).
	 */
	public var videocodecid:Number ;

	/**
	 * The video data rate (Defaults to 0).
	 */
	public var videodatarate:Number ;

	/**
	 * The video data size.
	 */
	public var videosize:Number ;
	
	/**
	 * Width of the video in pixels. (Flash exporter 1.1 sets this to 0).
	 */
	public var width:Number ;

	/**
	 * Additional string data if specified.
	 */
	public var xtradata:String ;
	

}