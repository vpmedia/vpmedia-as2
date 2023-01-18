import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.IToolTipSkin;
import net.manaca.ui.controls.skin.IWindowSkin;
import net.manaca.ui.controls.skin.IPanelSkin;
import net.manaca.ui.controls.skin.ILabelSkin;
import net.manaca.ui.controls.skin.ITextAreaSkin;
import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.ICheckBoxSkin;
import net.manaca.ui.controls.skin.ITextInputSkin;
import net.manaca.ui.controls.skin.INumericStepperSkin;
import net.manaca.ui.controls.skin.IProgressBarSkin;
import net.manaca.ui.controls.skin.IListSkin;
import net.manaca.ui.controls.skin.ISelectorSkin;
import net.manaca.ui.controls.skin.IComboBoxSkin;
import net.manaca.ui.controls.skin.IDateChooserSkin;
import net.manaca.ui.controls.skin.IDateFieldSkin;
import net.manaca.ui.controls.skin.IColorPickerSkin;
import net.manaca.ui.controls.skin.IColorChooserSkin;
import net.manaca.ui.controls.skin.ILoaderSkin;
import net.manaca.ui.controls.skin.IRadioButtonSkin;
/**
 * 用于处理组件对皮肤的需求，ISkinFactory接口定义可构建的皮肤种类
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
interface net.manaca.ui.controls.skin.ISkinFactory {
	public function createButtonSkin():IButtonSkin;
	public function createWindowSkin():IWindowSkin;
	public function createToolTipSkin():IToolTipSkin;
	public function createPanelSkin():IPanelSkin;
	public function createLabelSkin():ILabelSkin;
	public function createTextAreaSkin():ITextAreaSkin;
	public function createScrollbarSkin():IScrollbarSkin;
	public function createCheckBoxSkin():ICheckBoxSkin;
	public function createTextInputSkin():ITextInputSkin;
	public function createNumericStepperSkin():INumericStepperSkin;
	public function createProgressBarSkin():IProgressBarSkin;
	public function createListSkin():IListSkin;
	public function createListCellRendererSkin():IButtonSkin;
	public function createSelectorSkin() : ISelectorSkin;
	public function createComboBoxSkin() : IComboBoxSkin;
	public function createDateChooserSkin() : IDateChooserSkin;
	public function createDateFieldSkin() : IDateFieldSkin;
	public function createColorPickerSkin() : IColorPickerSkin;
	public function createColorChooserSkin() : IColorChooserSkin;
	public function createLoaderSkin() : ILoaderSkin;
	public function createRadioButtonSkin() : IRadioButtonSkin;

}