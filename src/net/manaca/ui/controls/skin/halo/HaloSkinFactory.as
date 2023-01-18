import net.manaca.ui.controls.skin.halo.ButtonSkin;
import net.manaca.ui.controls.skin.halo.ToolTipSkin;
import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.ISkinFactory;
import net.manaca.ui.controls.skin.IToolTipSkin;
import net.manaca.ui.controls.skin.IWindowSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.controls.skin.halo.WindowSkin;
import net.manaca.ui.controls.skin.IPanelSkin;
import net.manaca.ui.controls.skin.halo.PanelSkin;
import net.manaca.ui.controls.skin.*;

/**
 * HaloSkinFactory 实现 ISkinFactory，满足对 Halo 皮肤的构建工作。
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.skin.halo.HaloSkinFactory extends SkinFactory implements ISkinFactory{
	private var className : String = "net.manaca.ui.controls.skin.halo.HaloSkinFactory";
	function HaloSkinFactory() {
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
		return null;
	}

	public function createTextAreaSkin() : ITextAreaSkin {
		return null;
	}

	public function createScrollbarSkin() : IScrollbarSkin {
		return null;
	}

	public function createCheckBoxSkin() : ICheckBoxSkin {
		return null;
	}

	public function createTextInputSkin() : ITextInputSkin {
		return null;
	}

	public function createNumericStepperSkin() : INumericStepperSkin {
		return null;
	}

	public function createProgressBarSkin() : IProgressBarSkin {
		return null;
	}

	public function createListSkin() : IListSkin {
		return null;
	}

	public function createListCellRendererSkin() : IButtonSkin {
		return null;
	}

	public function createSelectorSkin() : ISelectorSkin {
		return null;
	}

	public function createComboBoxSkin() : IComboBoxSkin {
		return null;
	}

	public function createDateChooserSkin() : IDateChooserSkin {
		return null;
	}

	public function createDateFieldSkin() : IDateFieldSkin {
		return null;
	}

	public function createColorPickerSkin() : IColorPickerSkin {
		return null;
	}

	public function createColorChooserSkin() : IColorChooserSkin {
		return null;
	}

	public function createLoaderSkin() : ILoaderSkin {
		return null;
	}

	public function createRadioButtonSkin() : IRadioButtonSkin {
		return null;
	}

}