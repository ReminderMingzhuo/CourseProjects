#pragma once
#include "MyShape.h"
#include <ege.h>

class MyLine :
	public MyShape
{
private:
	int x1;
	int y1;

public:
	MyLine();
	~MyLine();
	void set(int xx, int yy, int x11, int y11);
	void set(int x11, int y11);
	void draw(){ege::line(x, y, x1, y1);}
	virtual void paint();
};

