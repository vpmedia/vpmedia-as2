/*
Copyright 2005-2006 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

interface org.asapframework.ui.buttons.radio.IRadioButton {

	public function getEnabled () : Boolean;
	public function setEnabled ( inValue:Boolean ) : Void;
	public function getSelected () : Boolean;
	public function setSelected ( inValue:Boolean ) : Void;
	public function setDisableSelf ( inValue:Boolean ) : Void ;
	public function getDisableSelf () : Boolean;
}
