/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.data.libs.LibEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplay;
import com.bourre.utils.StringUtils;

class com.bourre.medias.video.VideoDisplayEvent 
	extends LibEvent
{
	public function VideoDisplayEvent ( e : EventType, oLib : VideoDisplay )
	{
		super( e, oLib );
	}
	
	public function getLib() : VideoDisplay
	{
		return VideoDisplay( _oLib );
	}
	
	public function getView() : MovieClip
	{
		return getLib().getHolder();
	}
	
	public function getDuration() : Number
	{
		return VideoDisplay( _oLib ).getDuration();
	}
	
	public function getPlayheadTime() : Number
	{
		return VideoDisplay( _oLib ).getPlayheadTime();
	}
	
	public function getFormattedPlayheadTime() : String
	{
		return  StringUtils.getFormattedTime( Math.round(VideoDisplay( _oLib ).getPlayheadTime()) );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}