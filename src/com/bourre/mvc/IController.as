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
 * {@code IController} defines basic rules for {@code controller} instance 
 * using Pixlib MVC pattern.
 * 
 * <p>All controllers must extends {@link AbstractController} and 
 * implement {@code IController} interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.mvc.IModel;
import com.bourre.mvc.IView;

interface com.bourre.mvc.IController 
{
	/**
	 * Associates passed-in {@code oModel} model with current controller.
	 * 
	 * @param oModel {@link IModel} instance
	 */
	public function setModel(oModel:IModel) : Void;
	
	/**
	 * Returns controller's associated model.
	 * 
	 * @return {@link IModel} instance 
	 */
	public function getModel() : IModel;
	
	/**
	 * Associates passed-in {@link IView} with current controller.
	 * 
	 * @param oView {@link IView} instance
	 */
	public function setView(oView:IView) : Void;
	
	/**
	 * Returns controller's associated view.
	 * 
	 * @return {@link IView} instance 
	 */
	public function getView() : IView;
}