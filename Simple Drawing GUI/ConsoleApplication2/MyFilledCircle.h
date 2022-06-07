#pragma once
#include "MyCircle.h"
#include <ege.h>

using namespace ege;

class MyFilledCircle :
	public MyCircle
{
public:
	MyFilledCircle();
	~MyFilledCircle();
	void draw() { pieslice(x, y, 0, 360, r); }
};

