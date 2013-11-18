#include "/usr/share/aqsis/shaders/include/patterns.sl"

vector veins(point pos) {
	point cellCentre1, cellCentre2;
	float dist1, dist2;
	vector turb = vturbulence(pos * 4, 4, 2, 0.7);
	voronoi(pos + 0.6 * noise(pos * 2) + 0.07 * turb, 1, cellCentre1, dist1, cellCentre2, dist2);
	return cellCentre2 - cellCentre1;
}

float calcAngleFromLook(point sphere_center;
						point look_dir;
						vector pos) {
	vector centerToPoint =  pos;
	vector centerToLook = look_dir;
	centerToPoint = normalize(centerToPoint);
	centerToLook = normalize(centerToLook);
	return acos(centerToPoint . centerToLook);	
}

float edgeFinder(point sphere_center;
				 point look_dir) {
	float contrast = 0.3;
	
	float angle = calcAngleFromLook(sphere_center, look_dir, N);

	float sample_distance = 0.005;
	float t = smoothstep(0, radians(100), angle);
	sample_distance = mix(0, 0.005, t);
	
	float v0 = xcomp(veins(P));
	vector sample_point = P + vector(sample_distance, 0, 0);
	float v1 =  xcomp(veins(sample_point));
	sample_point = P + vector(0, sample_distance, 0);
	float v2 =  xcomp(veins(sample_point));
	sample_point = P + vector(-sample_distance, 0, 0);
	float v3 =  xcomp(veins(sample_point));
	sample_point = P + vector(0, -sample_distance, 0);
	float v4 =  xcomp(veins(sample_point));	
	float val = 0;
	if ((abs(v0 - v1) > contrast) ||
		 (abs(v0 - v2) > contrast) ||
		 (abs(v0 - v3) > contrast) ||
		 (abs(v0 - v4) > contrast))
	{
		val = 1;
	}
	return val;
}
color calc_veins(point sphere_center;
				 point look_dir) {
	float val = edgeFinder(sphere_center, look_dir);
	color c1 = color(255 / 254, 236 / 255, 215 / 255);
	color c2 = color(1, 0, 0);
	return mix(c1, c2, val);
}

color create_inner(point sphere_center;
				   point look_dir;) {
	float angle = calcAngleFromLook(sphere_center, look_dir, N);
	return color(0,0,0);
}

color color_part(point sphere_center;
				 point look_dir;
				 float dilation) {
	float angle = calcAngleFromLook(sphere_center, look_dir, N + 0.1 * noise(P));
	color c1 = calc_veins(sphere_center, look_dir);
	color c2 = create_inner(sphere_center, look_dir);
	float t = smoothstep(dilation - 1, dilation + 1, degrees(angle));
	
	return mix(c2, c1, t);
}

surface surface_shader(point sphere_center = vector(0, 0, 0);
					   point look_dir = vector(0.1, 0.6, -1);
					   float dilation = 29.;) {
	color c = color_part(sphere_center, look_dir, dilation);
	Ci = c;
}
