public class DemoShader extends Shader {

	void shader(double[] p, double u, double v, double t) {

		double g;
		g = 0.5 + 0.5*SimplexNoise.noise((u-0.5)*16.0, (0.5-v)*16.0, t*0.1);
		p[0]=g;
		p[1]=g;
		p[2]=g;
	}

}
