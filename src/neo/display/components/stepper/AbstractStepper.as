
/* ---------- 	AbstractStepper

	AUTHOR
	
		Name : AbstractStepper
		Package : neo.display.components.stepper
		Version : 1.0.0.0
		Date :  2006-02-16
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
		
		- maximum:Number [R/W]
		
		- minimum:Number [R/W]
		
		- nextValue:Number [Read Only]
		
		- previousValue:Number [Read Only]
		
		- stepSize:Number [R/W]
		
		- value:Number [R/W]
	
	METHODS
	
		- getNextValue()
		
		- getMaximum()
		
		- getMinimum()
		
		- getPreviousValue()
		
		- getStepSize()
		
		- getValue()
		
		- setMaximum(n:Number)
		
		- setMinimum(n:Number)
		
		- setStepSize(n:Number)
		
		- setValue (n:Number)


	INHERIT 
	
		MovieClip
			|
			AbstractComponent
				|
				AbstractButton
	
	IMPLEMENTS
	
		IStepper
	
	TODO : A tester !!
	
----------  */

import neo.display.components.AbstractComponent;
import neo.display.components.IStepper;
import neo.util.factory.PropertyFactory;
import neo.util.MathsUtil;

class neo.display.components.stepper.AbstractStepper extends AbstractComponent implements IStepper {

	// ----o Constructor

	private function AbstractStepper () {
		//
	}

	// ----o Public Properties
	
	public var maximum:Number ; // [R/W]
	public var minimum:Number ; // [R/W]
	public var nextValue:Number ; // [Read Only]
	public var previousValue:Number ; // [Read Only]
	public var stepSize:Number ; // [R/W]
	public var value:Number ; // [R/W]

	// ----o Public Methods

	public function getMaximum():Number { 
		return _maximum ;
	}

	public function getMinimum():Number { 
		return _minimum  ;
	}

	public function getNextValue():Number { 
		return _value + _stepSize ;
	}

	public function getPreviousValue():Number { 
		return _value - _stepSize  ;
	}

	public function getStepSize():Number {
		return _stepSize ;
	}

	public function getValue():Number { 
		return _value  ;
	}

	public function setMaximum(n:Number):Void {
		_maximum = ( n < _minimum) ? _minimum : n ;
		if (_value > _maximum) _value = _maximum ;
		update() ;
	}

	public function setMinimum(n:Number):Void {
		_minimum = (n>_maximum) ? _maximum : n ;
		if (_value < _minimum) _value = _minimum ;
		update() ;
	}

	public function setStepSize(n:Number):Void {
		_stepSize = isNaN(n) ? 1 : n ;
	}

	public function setValue (n:Number):Void {
		_value = MathsUtil.clamp(n, _minimum, _maximum) ;
		update() ;
		notifyChanged() ;
	}

	// ----o Virtual Properties

	static private var __MAXIMUM__:Boolean = PropertyFactory.create(AbstractStepper, "maximum", true) ;
	static private var __MINIMUM__:Boolean = PropertyFactory.create(AbstractStepper, "minimum", true) ;
	static private var __NEXT_VALUE__:Boolean = PropertyFactory.create(AbstractStepper, "nextValue", true, true) ;
	static private var __PREVIOUS_VALUE__:Boolean  = PropertyFactory.create(AbstractStepper, "previousValue", true, true) ;
	static private var __STEP_SIZE__:Boolean = PropertyFactory.create(AbstractStepper, "stepSize", true) ;
	static private var __VALUE__:Boolean = PropertyFactory.create(AbstractStepper, "value", true) ;
	
	// ----o Private Properties

	private var _minimum:Number = 0 ; 	
	private var _maximum:Number = 10 ; 
	private var _stepSize:Number = 1 ;
	private var _value:Number = 0 ;


}