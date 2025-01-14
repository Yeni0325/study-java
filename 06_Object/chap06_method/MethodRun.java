package com.kh.chap06_method.run;
import java.util.Scanner;

import com.kh.chap06_method.controller.NonStaticMethod;
import com.kh.chap06_method.controller.OverloadingTest;
import com.kh.chap06_method.controller.StaticMethod;

public class MethodRun {

	public static void main(String[] args) {
		
		//---------NonStaticMetod-----------
		NonStaticMethod test = new NonStaticMethod();
		
		// 1. 古鯵痕呪 蒸壱 鋼発葵 蒸澗 五社球 硲窒
		test.method1();
		
		//2. 古鯵痕呪 蒸壱 鋼発葵 赤澗 五社球 硲窒
		//test.method2();
		/*
		String str = test.method2();
		System.out.println(str);
		=> 廃 腰 葵聖 奄系廃 板 醗遂拝 鯉旋戚檎 戚 号狛生稽 馬澗依戚 限陥.
		*/
		
		System.out.println(test.method2());
		// 葵 奄系 板 紺亀税 醗遂 蒸戚 窒径幻 拝 井酔 是人 旭戚 廃匝稽 硲窒亀 亜管馬陥!
		
		//3. 古鯵痕呪 赤壱 鋼発葵戚 蒸澗  五社球 硲窒
		test.method3(10, 0);
		//int a = test.method3(10, 20);
		//鋼発葵戚 蒸澗 五社球戚奄 凶庚拭 是人 旭精 衣引葵聖 痕呪拭 煽舌馬澗 依戚 災亜管馬陥.
		
		//4. 古鯵痕呪亀 赤壱 鋼発葵亀 赤澗 五社球 硲窒
		char ch = test.method4("pineapple", 3);
		System.out.println(ch);
		//System.out.println(test.method4("pineapple", 3));
		// 葵 奄系 板 紺亀税 醗遂 蒸戚 窒径幻 拝 井酔 是人 旭戚 廃 匝稽 硲窒 亜管!
		
		//誓遂1.
		Scanner sc = new Scanner(System.in);
		
		System.out.print("庚切伸 脊径 : ");
		String str = sc.nextLine();
		
		System.out.print("舛呪 : ");
		int num = sc.nextInt();
		
		System.out.println("衣引 : " + test.method5(str, num));
		
		System.out.println();
		System.out.println();
		System.out.println("===StaticMethod===");
		//------------StaticMethod--------------
		StaticMethod test2 = new StaticMethod();
		
		//1.
		StaticMethod.method1();
		
		//2.
		System.out.println(StaticMethod.method2());
		
		//3. 
		StaticMethod.method3("畠掩疑");
		
		//4. 
		System.out.println(StaticMethod.method4("apple", "apple"));
		
		System.out.println();
		System.out.println();
		System.out.println("===OverloadingTEST===");
		//------------OverloadingTest--------------
		OverloadingTest ot = new OverloadingTest();
		ot.test();
		ot.test(20);
		ot.test(10, "ぞぞぞ");
		ot.test("ぞぞぞ", 20);
		ot.test(10,20);
		
		//神獄稽漁税 企妊旋昔 森 => 窒径庚 print()
		System.out.print(10);
		System.out.print("いい");
		System.out.print(0.0);
		//System.out.println
	}

}
