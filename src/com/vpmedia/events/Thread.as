import mx.events.EventDispatcher;
class com.vpmedia.events.Thread {
	private var m_objInterval;
	private var m_intInterval;
	private var m_intCounter;
	
	public function Thread(intInterval:Number) {
		EventDispatcher.initialize(this);
		m_objInterval = {};
		m_intInterval = intInterval;
		m_intCounter = 0;
	}
	
	public function stop() {
		m_intCounter = 0;
		clearInterval(m_objInterval);
	}
	
	public function start() {
		pause();
		m_objInterval = setInterval(this, "onInterval", m_intInterval);
	}
	
	public function pause() {
		clearInterval(m_objInterval);
	}
	
	public function resume() {
		pause();
		m_objInterval = setInterval(this, "onInterval", m_intInterval);
	}
	
	private function onInterval() {
		m_intCounter++;
		dispatchEvent({target:this, type:"onInterval", count:m_intCounter});
	}
	
	public function addEventListener() {
	}
	
	private function dispatchEvent() {
	}
}
