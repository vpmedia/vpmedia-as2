/**
 * Formfield Interface
 * @author tPS
 * @version 1.1
 **/

interface com.tPS.ui.form.IFormField{
	public function getValue():Object;
	public function validate():Boolean;
}