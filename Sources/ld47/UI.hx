package ld47;

import zui.Id;
import zui.Themes;
import zui.Zui;

class UI {

	public static var THEME : TTheme = {
		NAME: "LD47",
		ACCENT_COL: 0xff444444,
		ACCENT_HOVER_COL: 0xff494949,
		ACCENT_SELECT_COL: 0xff606060,
		ARROW_SIZE: 5,
		BUTTON_COL: 0xff464646,
		BUTTON_H: 32,
		BUTTON_HOVER_COL: 0xff494949,
		BUTTON_PRESSED_COL: 0xff1b1b1b,
		BUTTON_TEXT_COL: 0xffe8e7e5,
		CHECK_SELECT_SIZE: 8,
		CHECK_SIZE: 15,
		CONTEXT_COL: 0xff222222,
		ELEMENT_H: 24,
		ELEMENT_OFFSET: 12,
		ELEMENT_W: 100,
		FILL_ACCENT_BG: false,
		FILL_BUTTON_BG: true,
		FILL_WINDOW_BG: false,
		FONT_SIZE: 13,
		HIGHLIGHT_COL: 0xff205d9c,
		LABEL_COL: 0xffc8c8c8,
		LINK_STYLE: Line,
		PANEL_BG_COL: 0xff3b3b3b,
		SCROLL_W: 6,
		SEPARATOR_COL: 0xff272727,
		TAB_W: 6,
		TEXT_COL: 0xffe8e7e5,
		TEXT_OFFSET: 8,
		WINDOW_BG_COL: 0xff333333,
		WINDOW_TINT_COL: 0xffffffff,
	};

	public static var font : kha.Font;
	public static var fontSize = 14; // Jetbrain mono
	//public static var fontSize = 11; // Anonymou Pro

	public static function init( done : Void->Void ) {
		Data.getFont( 'mono.ttf', f -> {
			font = f;
			done();
		});
    }

}