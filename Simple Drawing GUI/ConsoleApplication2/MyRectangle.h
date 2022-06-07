#pragma once
#include "MyShape.h"
class MyRectangle :
	public MyShape
{
protected:
	int x1;
	int y1;

public:
	MyRectangle();
	~MyRectangle();
	void set(int, int, int, int);
	void set(int, int);
	void draw();
	void virtual paint();
};

