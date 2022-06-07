#pragma warning(disable : 4996)
#include <iostream>
#include <ege.h>
#include "MyShape.h"

using namespace ege;

void menubar()
{
	for (int i = 0; i < 7; i++){
		rectangle(60 + 60 * i, 0, 120 + 60 * i, 60);
	}	
	for (int i = 1; i < 9; i++) {
		rectangle(0, 60 * i, 60, 60 + 60 * i);
	}

	fillellipsef(90, 30, 15, 10);
	arc(150, 30, 0, 360, 10);
	rectangle(195, 40, 225, 20);
	line(260, 40, 280, 20);
	setfillcolor(BLUE);
	fillellipsef(330, 30, 15, 10);

	pieslice(390, 30, 0, 360, 10);
	bar(435, 40, 465, 20);
	rectangle(435, 40, 465, 20);

	bar(0, 120, 60, 60);

	setfillcolor(RED);
	bar(0, 180, 60, 120);
	setfillcolor(GREEN);

	bar(0, 240, 60, 180);
	setfillcolor(YELLOW);
	bar(0, 300, 60, 240);

	setfillcolor(WHITE);
	bar(0, 360, 60, 300);
	setfont(-16, 0, "ËÎÌå");

	outtextxy(10, 380, "Ï¸");
	outtextxy(10, 440, "ÖÐÏ¸");
	outtextxy(10, 500, "´Ö");

}

void ChooseShape(int & cc)
{
		mouse_msg msg = MyShape::msg;

		if (msg.x > 60 && msg.x < 120 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 0;
		}
		if (msg.x > 120 && msg.x < 180 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 1;
		}
		if (msg.x > 180 && msg.x < 240 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 2;
		}
		if (msg.x > 240 && msg.x < 300 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 3;
		}
		if (msg.x > 300 && msg.x < 360 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 4;
		}
		if (msg.x > 360 && msg.x < 420 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 5;
		}
		if (msg.x > 420 && msg.x < 480 && msg.y>0 && msg.y < 60)
		{
				if (msg.is_left())cc = 6;
		}
}


void ChooseColor1()
{
	mouse_msg msg = MyShape::msg;
	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 60 && msg.y <= 120)
	{
			if (msg.is_left())setfillcolor(BLUE);
	}
	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 120 && msg.y <= 180)
	{
			if (msg.is_left())setfillcolor(RED);
	}
	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 180 && msg.y <= 240)
	{
			if (msg.is_left())setfillcolor(GREEN);
	}
	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 240 && msg.y <= 300)
	{
			if (msg.is_left())setfillcolor(YELLOW);
	}
	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 300 && msg.y <= 360)
	{
			if (msg.is_left())setfillcolor(WHITE);
	}

}

void ChooseWidth()
{
	mouse_msg msg = MyShape::msg;

	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 360 && msg.y <= 420)
	{
			if (msg.is_left()){setlinewidth(2); setcolor(WHITE); setfillstyle(SOLID_FILL, WHITE);}
	}

	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 420 && msg.y <= 480)
	{
			if (msg.is_left()){setlinewidth(15); setcolor(WHITE); setfillstyle(SOLID_FILL, WHITE);}
	}

	if (msg.x >= 0 && msg.x <= 60 && msg.y >= 480 && msg.y <= 540)
	{
			if (msg.is_left()){setlinewidth(30); setcolor(WHITE); setfillstyle(SOLID_FILL, WHITE);}
	}
}

