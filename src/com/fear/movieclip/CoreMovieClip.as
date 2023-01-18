/*
*
* @authors
*	Toby Boudreaux <tj@tobyjoe.com>
*	Caleb Haye <me@caleb.org> 
*
* @license 
*	ActionScript FEAR (Flash Extension and Application Repository)
* 	http://sourceforge.net/projects/actionscript
* 	Copyright (C) 2005 Caleb Haye, Toby Boudreaux
* 
* 	This program is free software; you can redistribute it and/or
* 	modify it under the terms of the GNU General Public License
* 	as published by the Free Software Foundation; either version 2
* 	of the License, or (at your option) any later version.
* 
* 	This program is distributed in the hope that it will be useful,
* 	but WITHOUT ANY WARRANTY; without even the implied warranty of
* 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* 	GNU General Public License for more details.
* 
* 	You should have received a copy of the GNU General Public License
* 	along with this program; if not, write to the Free Software
* 	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*
*	@cvs
*	Revision: $Revision: 1.1 $
*	Date: $Date: 2005/03/10 02:37:51 $
*	Author: $Author: calebhaye $
*	Name: $Name:  $
*	Id: $Id: CoreMovieClip.as,v 1.1 2005/03/10 02:37:51 calebhaye Exp $
*/
import com.fear.core.CoreInterface;

class com.fear.movieclip.CoreMovieClip extends MovieClip implements CoreInterface{
	private var $instanceDescription:String;

	function CoreMovieClip(Void){
		super();
		this.setClassDescription('com.fear.movieclip.CoreMovieClip');
	}

	public function toString(Void):String{
		return this.$instanceDescription;
	}

	private function setClassDescription(d:String):Void{
		this.$instanceDescription = d;
	}

}

