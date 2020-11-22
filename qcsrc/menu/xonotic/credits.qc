#include "credits.qh"

#define CREDITS(TITLE, FUNCTION, PERSON, PERSON_, NL) \
	TITLE(_("Created by Rocket Jump Zone")) \
		PERSON(GL HF!) \
	NL() \
	FUNCTION(_("Website")) \
		PERSON(rocketjump.zone/ch1mpnotic) \
	NL() \
	FUNCTION(_("Contribute")) \
		PERSON(rocketjump.zone/contribute) \
	NL() \
	TITLE(_("Special Thanks to")) \
		PERSON(The Xonotic Core Team) \
	NL() \
	NL() \



int credits_get()
{
	int n = buf_create();
	#define CREDITS_TITLE(t) bufstr_add(n, strcat("**", t), 0);
	#define CREDITS_FUNCTION(f) bufstr_add(n, strcat("*", f), 0);
	#define CREDITS_PERSON(p) bufstr_add(n, p, 0);
	#define _CREDITS_PERSON(p) CREDITS_PERSON(#p)
	#define CREDITS_NL() bufstr_add(n, "", 0);
    CREDITS(CREDITS_TITLE, CREDITS_FUNCTION, _CREDITS_PERSON, CREDITS_PERSON, CREDITS_NL)
	#undef CREDITS_TITLE
	#undef CREDITS_FUNCTION
	#undef CREDITS_PERSON
	#undef _CREDITS_PERSON
	#undef CREDITS_NL
	return n;
}

#undef CREDITS

entity makeXonoticCreditsList()
{
	entity me;
	me = NEW(XonoticCreditsList);
	me.configureXonoticCreditsList(me);
	return me;
}
void XonoticCreditsList_configureXonoticCreditsList(entity me)
{
	me.configureXonoticListBox(me);
    me.bufferIndex = credits_get();
	me.nItems = buf_getsize(me.bufferIndex);
}
void XonoticCreditsList_destroy(entity me)
{
	buf_del(me.bufferIndex);
}
void XonoticCreditsList_draw(entity me)
{
	if(me.scrolling)
	{
		me.scrollPos = bound(0, (time - me.scrolling) * me.itemHeight, me.nItems * me.itemHeight - 1);
		me.scrollPosTarget = me.scrollPos;
	}
	SUPER(XonoticCreditsList).draw(me);
}
void XonoticCreditsList_resizeNotify(entity me, vector relOrigin, vector relSize, vector absOrigin, vector absSize)
{
	SUPER(XonoticCreditsList).resizeNotify(me, relOrigin, relSize, absOrigin, absSize);

	me.realFontSize_y = me.fontSize / (absSize.y * me.itemHeight);
	me.realFontSize_x = me.fontSize / (absSize.x * (1 - me.controlWidth));
	me.realUpperMargin = 0.5 * (1 - me.realFontSize.y);
}
void XonoticCreditsList_drawListBoxItem(entity me, int i, vector absSize, bool isSelected, bool isFocused)
{
	string s;
	float theAlpha;
	vector theColor;

	s = bufstr_get(me.bufferIndex, i);

	if(substring(s, 0, 2) == "**")
	{
		s = substring(s, 2, strlen(s) - 2);
		theColor = SKINCOLOR_CREDITS_TITLE;
		theAlpha = SKINALPHA_CREDITS_TITLE;
	}
	else if(substring(s, 0, 1) == "*")
	{
		s = substring(s, 1, strlen(s) - 1);
		theColor = SKINCOLOR_CREDITS_FUNCTION;
		theAlpha = SKINALPHA_CREDITS_FUNCTION;
	}
	else
	{
		theColor = SKINCOLOR_CREDITS_PERSON;
		theAlpha = SKINALPHA_CREDITS_PERSON;
	}

	draw_CenterText(me.realUpperMargin * eY + 0.5 * eX, s, me.realFontSize, theColor, theAlpha, 0);
}

float XonoticCreditsList_keyDown(entity me, float key, float ascii, float shift)
{
	me.scrolling = 0;
	return SUPER(XonoticCreditsList).keyDown(me, key, ascii, shift);
}
