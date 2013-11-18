

public class MyShader extends Shader{
	int dim = 3;
	
	int R = 0;
	int G = 1;
	int B = 2;
	
	@Override
	void shader(double[] p, double u, double v, double t) {
		// TODO Auto-generated method stub
		double[] tresh = new double[3];
		
		int[] ID = new int[dim];
		
		//Worley noise
		double[] F = new double[dim];
		
		double[] at  = {(u-.5)*16., (.5-v)*16., 10.};
		
		double[][] delta = new double[dim][3];
		
		WorleyNoise.noise(at, dim, F, delta, ID );
		
		double a = SimplexNoise.noise((u - 0.5) * 20.0, (0.5 - v) * 20.0, t/20.);
		
		double treshCh = PerlinSimplexNoise.noise(t/50., 0, 20.);
		treshCh = Math.max( Math.min( Math.abs(treshCh), 0.2), 0.1);
		
		double T = F[1] - F[0];
		

		if(T < treshCh)
			p[R] = Math.max(a*0.5, .03);
		
		else
			p[R] = 0.;
		p[G] = 0;
		p[B] = 0;
		
		// UIUpdater kaka = new UIUpdater<E>();
		// kaka.test();
	}
	
	public static class UIUpdater<E>
	{
		public E param;
		public void test()
		{
			System.out.print(param.getClass().toString());
		}
	}
}
