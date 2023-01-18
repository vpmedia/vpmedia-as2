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

import com.bourre.commands.Command;
import com.bourre.data.libs.ILibListener;

interface com.bourre.data.libs.ILib 
	extends Command
{
	public function load() : Void;
	public function getPerCent() : Number;
	public function getURL() : String;
	public function setURL(sURL:String) : Void;
	public function addListener( oL : ILibListener ) : Void;
	public function removeListener( oL : ILibListener ) : Void;
	public function getName() : String;
	public function setName( sURL : String ) : Void;
	public function setAntiCache( b : Boolean ) : Void;
	public function prefixURL( sURL : String ) : Void;
}