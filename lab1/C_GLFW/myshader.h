#ifndef __MY_SHADER__
#define __MY_SHADER__

inline double smoothStep(double v, double fMin, double fMax) {
	double smooth = (v - fMin)/(fMax - fMin);
	smooth = fmax(fmin(smooth, 1.0), 0.0);
	return smooth * smooth * (3 - 2 * smooth);
}

#endif
