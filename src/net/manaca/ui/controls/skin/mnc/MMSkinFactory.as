import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.ISkinFactory;
import net.manaca.ui.controls.skin.IToolTipSkin;
import net.manaca.ui.controls.skin.IWindowSkin;
import net.manaca.ui.controls.skin.mnc.ButtonSkin;
import net.manaca.ui.controls.skin.mnc.ToolTipSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.controls.skin.mnc.WindowSkin;
import net.manaca.ui.controls.skin.IPanelSkin;
import net.manaca.ui.controls.skin.mnc.PanelSkin;
import net.manaca.ui.controls.skin.ILabelSkin;
import net.manaca.ui.controls.skin.mnc.LabelSkin;
import net.manaca.ui.controls.skin.ITextAreaSkin;
import net.manaca.ui.controls.skin.mnc.TextAreaSkin;
import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.mnc.ScrollbarSkin;
import net.manaca.ui.controls.skin.ICheckBoxSkin;
import net.manaca.ui.controls.skin.mnc.CheckBoxSkin;
import net.manaca.ui.controls.skin.ITextInputSkin;
import net.manaca.ui.controls.skin.mnc.TextInputSkin;
import net.manaca.ui.controls.skin.INumericStepperSkin;
import net.manaca.ui.controls.skin.mnc.NumericStepperSkin;
import net.manaca.ui.controls.skin.IProgressBarSkin;
import net.manaca.ui.controls.skin.mnc.ProgressBarSkin;
import net.manaca.ui.controls.skin.IListSkin;
import net.manaca.ui.controls.skin.mnc.ListSkin;
import net.manaca.ui.controls.skin.mnc.ListCellRendererSkin;
import net.manaca.ui.controls.skin.ISelectorSkin;
import net.manaca.ui.controls.skin.mnc.SelectorSkin;
import net.manaca.ui.controls.skin.IComboBoxSkin;
import net.manaca.ui.controls.skin.mnc.ComboBoxSkin;
import net.manaca.ui.controls.skin.IDateChooserSkin;
import net.manaca.ui.controls.skin.mnc.DateChooserSkin;
import net.manaca.ui.controls.skin.IDateFieldSkin;
import net.manaca.ui.controls.skin.mnc.DateFieldSkin;
import net.manaca.ui.controls.skin.IColorPickerSkin;
import net.manaca.ui.controls.skin.mnc.ColorPickerSkin;
import net.manaca.ui.controls.skin.IColorChooserSkin;
import net.manaca.ui.controls.skin.mnc.ColorChooserSkin;
import net.manaca.ui.controls.skin.ILoaderSkin;
import net.manaca.ui.controls.skin.mnc.LoaderSkin;
import net.manaca.ui.controls.skin.IRadioButtonSkin;
import net.manaca.ui.controls.skin.mnc.RadioButtonSkin;

/**
 * HaloSkinFactory 实现 ISkinFactory，满足对 MM 皮肤的构建工作。
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.skin.mnc.MMSkinFactory extends SkinFactory implements ISkinFactory {
	private var className : String = "net.manaca.ui.controls.skin.mnc.MMSkinFactory";
	public function MMSkinFactory() {
		super();
	}

	public function createButtonSkin() : IButtonSkin {
		return new ButtonSkin();
	}

	public function createWindowSkin() : IWindowSkin {
		return new WindowSkin();
	}

	public function createToolTipSkin() : IToolTipSkin {
		return new ToolTipSkin();
	}

	public function createPanelSkin() : IPanelSkin {
		return new PanelSkin();
	}
	public function createLabelSkin() : ILabelSkin {
		return new LabelSkin();
	}
	public function createTextAreaSkin() : ITextAreaSkin {
		return new TextAreaSkin();
	}
	public function createScrollbarSkin() : IScrollbarSkin {
		return new ScrollbarSkin();
	}

	public function createCheckBoxSkin() : ICheckBoxSkin {
		return new CheckBoxSkin();
	}

	public function createTextInputSkin() : ITextInputSkin {
		return new TextInputSkin();
	}

	public function createNumericStepperSkin() : INumericStepperSkin {
		return new NumericStepperSkin();
	}

	public function createProgressBarSkin() : IProgressBarSkin {
		return new ProgressBarSkin();
	}

	public function createListSkin() : IListSkin {
		return new ListSkin();
	}


	public function createSelectorSkin() : ISelectorSkin {
		return new SelectorSkin();
	}

	public function createComboBoxSkin() : IComboBoxSkin {
		return new  ComboBoxSkin();
	}

	public function createDateChooserSkin() : IDateChooserSkin {
		return new DateChooserSkin();
	}

	public function createDateFieldSkin() : IDateFieldSkin {
		return new DateFieldSkin();
	}

	public function createColorPickerSkin() : IColorPickerSkin {
		return new ColorPickerSkin();
	}

	public function createColorChooserSkin() : IColorChooserSkin {
		return new ColorChooserSkin();
	}

	public function createLoaderSkin() : ILoaderSkin {
		return new LoaderSkin();
	}

	public function createRadioButtonSkin() : IRadioButtonSkin {
		return new RadioButtonSkin();
	}


	public function createListCellRendererSkin() : IButtonSkin {
		return null;
	}

}