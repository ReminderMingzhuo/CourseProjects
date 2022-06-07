#pragma once
#include "MyShape.h"
#include <ege.h>


class MyEllipse :
	public MyShape
{
protected:
	int xr;
	int yr;

public:

	MyEllipse();

	~MyEllipse();

	void set(int xx, int yy, int xrr, int yrr);
	void set(int xrr, int yrr);
	int getx() const{return x;}
	int gety() const{return y;}
	void draw(){ege::ellipse(x, y, 0, 360, xr, yr);}
	virtual void paint();
};

