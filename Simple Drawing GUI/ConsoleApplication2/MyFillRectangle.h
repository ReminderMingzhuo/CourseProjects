#pragma once
#include "MyRectangle.h"
#include <ege.h>


class MyFillRectangle :
	public MyRectangle
{
public:
	MyFillRectangle();
	~MyFillRectangle();
	void draw(){ ege::bar(x, y, x1, y1); }
};

