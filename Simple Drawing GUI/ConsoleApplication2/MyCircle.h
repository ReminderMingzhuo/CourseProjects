#pragma once
#include "MyShape.h"
class MyCircle :
	public MyShape
{
public:
	MyCircle();
	~MyCircle();
	void set(int xx, int yy, int rr, int oo = 0);
	void set(int rr, int oo = 0);
	void draw();
	virtual void paint();
};

