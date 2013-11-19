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

	float distR = v;
	float angle = u;

	float dist = distR + 0.1 * fbm(15.0 * N);
	float rand = fbm(vector(6.0 * distR, 40 * angle, 0.0));

	float rays = angle * 30 + 5 * noise(10 * s, 10 * t);
	float rayt = distR * 10;
	float raypattern = clamp(-0.5 + 2 * noise(rays, rayt), 0, 1);
		
	color center = mix(irisColor, bg, raypattern);
	center = mix(center, bg, smoothstep(0.07, 0.2, dist));
	center = mix(color(0,0,0), center, smoothstep(0.06, 0.08, distR));
	return center;
}

color sstep(color old;
			color add;
			float i;
			float r;
			float a)
{
	float f = smoothstep(0.3, 1.0, fbm(vector(6.0 * r + 10 * i, 40 * a + 10 * i, 0.0)));
	return mix(old, add, f);
}

color create_inner(point sphere_center;
				   point look_dir;
				   float radius;) {

	float r = v;
	float a = u;
	// add noise
	a += 0.1 * fbm(15.0 * N);
	
	color c1 = color(0, .08, 0.92);
	/* color c2 = color(a / (2 * 3.1415)); */
	color c2 = color(1);

	color tot = sstep(c1, c2, 0, r, a);
	float i;
	for (i = 0; i < 2; i += 1) {
		tot = sstep(tot, c2, i, r, a);
	}
	return mix(tot, c1, smoothstep(0.19, 0.23, r));
}

color color_part(point sphere_center;
				 point look_dir;
				 float dilation;
				 float radius;) {
	float dist = v;
	color c1 = color(1);//calc_veins(sphere_center, look_dir);
	color c2 = create_inner(sphere_center, look_dir, radius);
	
	float tval = smoothstep(0.21, 0.23, dist);
	color c = create_yellow(sphere_center, look_dir, mix(c2, c1, tval));
	/* color c = mix(c2, c1, tval); */
	return c;
}

surface surface_shader(point sphere_center = vector(0, 0, 0);
					   point look_dir = vector(0.5, 0.5, 0.);
					   float dilation = 29.;
					   float radius = .5;) {
	color c = color_part(sphere_center, look_dir, dilation, radius);
	Ci = c;
}
