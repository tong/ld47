package ld47;

import zui.Id;
import zui.Themes;
import zui.Zui;

class UI {

	// #ff00ff;

	public static inline var COLOR_ENABLED = 0xffffffff;
	public static inline var COLOR_DISABLED = 0xff505050;

	public static var THEME_1 : TTheme = {
		NAME: "LD47.1",
		ACCENT_COL: 0xff000000,
		ACCENT_HOVER_COL: 0xfff0f0f0,
		ACCENT_SELECT_COL: 0xffffffff,
		ARROW_SIZE: 64,
		BUTTON_H: 40,
		BUTTON_COL: 0x00ffffff,
		BUTTON_HOVER_COL: 0x00ffffff,
		BUTTON_PRESSED_COL: 0x00ffffff,
		BUTTON_TEXT_COL: 0xffffffff,
		CHECK_SELECT_SIZE: 7,
		CHECK_SIZE: 12,
		CONTEXT_COL: 0xff222222,
		ELEMENT_H: 32,
		ELEMENT_OFFSET: 4,
		ELEMENT_W: 200,
		FILL_ACCENT_BG: false,
		FILL_BUTTON_BG: false,
		FILL_WINDOW_BG: false,
		FONT_SIZE: 16,
		HIGHLIGHT_COL: 0xff205d9c,
		LABEL_COL: 0xffffffff,
		LINK_STYLE: Line,
		PANEL_BG_COL: 0xff000000,
		SCROLL_W: 6,
		SEPARATOR_COL: 0xff0000ff,
		TAB_W: 6,
		TEXT_COL: 0xffffffff,
		TEXT_OFFSET: 8,
		WINDOW_BG_COL: 0x00000000,
		WINDOW_TINT_COL: 0xffffffff,
	};

	public static var THEME_2 : TTheme = cast {
		NAME: "LD47.2",
		ACCENT_COL: 0xff444444,
		ACCENT_HOVER_COL: 0xff494949,
		ACCENT_SELECT_COL: 0xff606060,
		ARROW_SIZE: 5,
		BUTTON_H: 40,
		BUTTON_COL: 0x00ffffff,
		BUTTON_HOVER_COL: 0x00ffffff,
		BUTTON_PRESSED_COL: 0x00ffffff,
		BUTTON_TEXT_COL: 0xffffffff,
		CHECK_SELECT_SIZE: 40,
		CHECK_SIZE: 48,
		CONTEXT_COL: 0xff222222,
		ELEMENT_H: 68,
		ELEMENT_OFFSET: 0,
		ELEMENT_W: 100,
		FILL_ACCENT_BG: false,
		FILL_BUTTON_BG: false,
		FILL_WINDOW_BG: false,
		FONT_SIZE: 60,
		HIGHLIGHT_COL: 0xff205d9c,
		LABEL_COL: 0xffc8c8c8,
		LINK_STYLE: Line,
		PANEL_BG_COL: 0xff3b3b3b,
		SCROLL_W: 6,
		SEPARATOR_COL: 0xff272727,
		TAB_W: 6,
		TEXT_COL: 0xffe8e7e5,
		TEXT_OFFSET: 8,
		WINDOW_BG_COL: 0x00000000,
		WINDOW_TINT_COL: 0xffffffff,
	};

	public static var THEME = THEME_2;

	public static var font : kha.Font;
	public static var fontSize = 14; // Jetbrain mono

	public static var fontTitle : kha.Font;
	public static var fontTitleSize = 60;

	public static function init( ?done : Void->Void ) {
		Data.getFont( 'mono.ttf', f -> {
			font = f;
			Data.getFont( "title.ttf", f -> {
				fontTitle = f;
				if( done != null ) done();
			});
		});
	}
	
}