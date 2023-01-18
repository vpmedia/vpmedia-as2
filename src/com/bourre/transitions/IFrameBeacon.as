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
 * {@code IFrameBeacon} defines basic rules for tween synchronizer implementation.
 * 
 * <p>Take a look at {@link com.bourre.transitions.FPSBeacon} and 
 * {@link com.bourre.transitions.MSBeacon} for concrete implementation.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
import com.bourre.transitions.IFrameListener;

interface com.bourre.transitions.IFrameBeacon 
{
	/**
	 * Starts the process.
	 */
	public function start() : Void;
	
	/**
	 * Stops the process.
	 */
	public function stop() : Void;
	
	/**
	 * Indicates if FPSBeacon's running.
	 * 
	 * @return {@code true} if {@code FPSBeacon} is running, either {@code false}
	 */
	public function isPlaying() : Boolean;
	
	/**
	 * Adds listener for receiving all {@code IFrameBeacon} events.
	 * 
	 * @param oL Listener object which implements {@link IFrameListener} interface.
	 */
	public function addFrameListener(oL:IFrameListener) : Void;
	
	/**
	 * Removes passed-in listener for receiving all {@code IFrameBeacon} events.
	 * 
	 * @param oL Listener object which implements {@link IFrameListener} interface.
	 */
	public function removeFrameListener(oL:IFrameListener) : Void;
}