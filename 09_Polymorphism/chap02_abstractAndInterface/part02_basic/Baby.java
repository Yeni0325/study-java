package com.kh.chap02_abstractAndInterface.part02_basic.model.vo;

public class Baby extends Person implements Basic {
	
	public Baby() {
		
	}
	
	public Baby(String name, double weight, int health) {
		super(name, weight, health);
	}
	
	@Override
	public String toString() {
		return "Baby [" + super.toString() + "]";
	}

	@Override
	public void eat() {
		//������� ������ 3����
		super.setWeight(super.getWeight() + 3);
		
		//������� �ǰ��� 1����
		super.setHealth(super.getHealth() + 1);
	}

	@Override
	public void sleep() {
		//���ڸ� �ǰ��� 3����
		super.setHealth(super.getHealth() + 3);
	}
	
	
	
	
	
	
}
