#pragma once
#include "MyEllipse.h"
class MyFillEllipse :
	public MyEllipse
{
public:
	MyFillEllipse();
	~MyFillEllipse();
	void draw() { fillellipse(x, y, xr, yr); }
};

