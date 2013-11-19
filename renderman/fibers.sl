float fbm (vector pos) {
	float f = 0.0;
	f += 0.5 * noise(pos);
	f += 0.250 * noise(pos);
	f += 0.125 * noise(pos);
	f += 0.0625 * noise(pos);
	f /= 0.9375;
	return f;
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

vector veins(point pos) {
	point cellCentre1, cellCentre2;
	float dist1, dist2;
	vector turb = vturbulence(pos * 4, 4, 2, 0.7);
	voronoi(pos + 0.6 * noise(pos * 2) + 0.07 * turb, 1, cellCentre1, dist1, cellCentre2, dist2);
	return cellCentre2 - cellCentre1;
}

float edgeFinder(point sphere_center;
				 point look_dir;
				 point pos) {
	float contrast = 0.3;
	
	float angle = calcAngleFromLook(sphere_center, look_dir, N);

	float sample_distance = 0.005;
	float t = smoothstep(0, radians(100), angle);
	sample_distance = mix(0, 0.005, t);
	
	float v0 = xcomp(veins(pos));
	vector sample_point = pos + vector(sample_distance, 0, 0);
	float v1 =  xcomp(veins(sample_point));
	sample_point = pos + vector(0, sample_distance, 0);
	float v2 =  xcomp(veins(sample_point));
	sample_point = pos + vector(-sample_distance, 0, 0);
	float v3 =  xcomp(veins(sample_point));
	sample_point = pos + vector(0, -sample_distance, 0);
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

