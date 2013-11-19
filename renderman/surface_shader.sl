#include "/usr/share/aqsis/shaders/include/patterns.sl"
#include "fibers.sl"

color calc_veins(point sphere_center;
				 point look_dir) {
	float val = edgeFinder(sphere_center, look_dir, P);
	color c1 = color(255 / 254, 236 / 255, 215 / 255);
	color c2 = color(1, 0, 0);
	return mix(c1, c2, val);
}

color create_yellow(point sphere_center;
					point look_dir;
					color bg;) {
	color yellow = color(1, 1, 0);
	color orange = color(1, 69 / 255, 0);
	color irisColor = mix(yellow, orange, xcomp(noise(N * 10)));
	
	float angleReal = calcAngleFromLook(sphere_center, look_dir, N);
	float angle = angleReal + 0.1 * noise(10 * s, 10 * t);
	angle += 0.05 * noise(20 * s, 20 * t);
	angle += 0.025 * noise(40 * s, 40 * t);
	color center = mix(irisColor, bg, smoothstep(radians(8), radians(30), angle));
	center = mix(color(0,0,0), center, smoothstep(radians(7), radians(9), angleReal));
	return center;
}

color create_inner(point sphere_center;
				   point look_dir;
				   float radius;) {
	float angle = calcAngleFromLook(sphere_center, look_dir, N);
	/* float n = noise(P * 5) + noise(P * 20) + noise(P(0), P(1)); */

	float r = distance(P, look_dir * radius);
	float a = atan(xcomp(P), ycomp(P));
	
	float f = fbm( 5 * P );

	vector irisCenter = radius * look_dir;
	
	color c = mix(color(25/255, 25/255, 112/255), color(1,1,1), f);
	float ang2 = angle + 0.1 * fbm(20.0 * P);
	
	f = smoothstep(0.3, 1.0, fbm(vector(6.0 * r, 20.0 * ang2, 0.0)));
	c = mix(c, color(1.0), f);
	
	float t = smoothstep(8, 10, degrees(angle));
	c = mix(color(0, 0, 0), c, t);
	return c;
}

color color_part(point sphere_center;
				 point look_dir;
				 float dilation;
				 float radius;) {
	float angle = calcAngleFromLook(sphere_center, look_dir, N);
	color c1 = calc_veins(sphere_center, look_dir);
	color c2 = create_inner(sphere_center, look_dir, radius);
	float t = smoothstep(dilation - 1, dilation + 1, degrees(angle));
	color c = create_yellow(sphere_center, look_dir, mix(c2, c1, t));
	return c;
}

surface surface_shader(point sphere_center = vector(0, 0, 0);
					   point look_dir = vector(0.0, 1., 0);
					   float dilation = 29.;
					   float radius = .5;) {
	color c = color_part(sphere_center, look_dir, dilation, radius);
	Ci = c;
}
